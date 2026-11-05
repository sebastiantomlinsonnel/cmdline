part of '../../../cmd.dart';

class _Net {
  const _Net._();

  /// Downloads [url] and saves it to the file [saveTo].
  ///
  /// With [showProgress], a [ProgressBar] fills as the file arrives (or a
  /// spinner, if the server doesn't say how big it is). The Windows Terminal
  /// taskbar icon shows the progress too. It ends with a themed tick line, or
  /// a cross line if the download fails.
  ///
  /// Missing folders for [saveTo] are created. An existing file is replaced
  /// only when [overwrite] is true. Throws a [FileError] if the file is there
  /// already, and an [HttpException] if the server doesn't answer with 200 OK.
  ///
  /// ```dart
  /// await fetch(
  ///   'https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION',
  ///   join(pwd, 'build', 'VERSION.json'),
  /// );
  /// ```
  Future<void> fetch(
    String url,
    String saveTo, {
    bool showProgress = true,
    bool overwrite = false,
  }) async {
    if (!overwrite && CMD.fs.exists(saveTo))
      throw FileError('Already exists', saveTo);

    final theme = CliTheme.current;
    final name = CMD.fs.basename(saveTo);
    final client = HttpClient();
    final partial = File('$saveTo.part');
    ProgressBar? bar;

    try {
      final response = await (await client.getUrl(Uri.parse(url))).close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'The server answered ${response.statusCode} ${response.reasonPhrase}',
          uri: Uri.parse(url),
        );
      }

      final total = response.contentLength;
      if (showProgress) {
        if (total > 0) {
          bar = ProgressBar('Downloading $name', total: total);
        } else {
          Logger.instance.startSpinner('Downloading $name');
        }
      }

      CMD.fs.createDir(CMD.fs.dirname(saveTo));
      final sink = partial.openWrite();
      var received = 0;
      var lastPercent = -1;
      try {
        await for (final chunk in response) {
          sink.add(chunk);
          received += chunk.length;
          if (bar == null) continue;

          bar.update(received);
          final percent = received * 100 ~/ total;
          if (percent != lastPercent) {
            lastPercent = percent;
            stdout.write(taskbarProgress(percent));
          }
        }
      } finally {
        await sink.close();
      }

      if (CMD.fs.exists(saveTo)) File(saveTo).deleteSync();
      partial.renameSync(saveTo);

      if (showProgress) {
        _endProgress(bar);
        CliTheme.say(theme.successLine('Downloaded ${name.bold}'));
      }
    } catch (_) {
      if (showProgress) {
        _endProgress(bar);
        CliTheme.say(theme.errorLine('Download failed: ${url.dim}'));
      }
      if (partial.existsSync()) partial.deleteSync();
      rethrow;
    } finally {
      client.close();
    }
  }

  /// Wipes the bar or spinner and clears the taskbar progress.
  void _endProgress(ProgressBar? bar) {
    stdout.write(TASKBAR_CLEAR);
    if (bar != null) {
      // Leave no PASS/FAIL line from the bar; fetch prints its own.
      stdout.write('$CLEAR_LINE$SHOW_CURSOR');
    } else if (Logger.instance.isSpinning) {
      Logger.instance.stopSpinner(null, Level.log);
    }
  }

  /// Download over the internet
  Future<File> download(Uri link, File file) async {
    if (file.existsSync()) file.createSync(recursive: true);

    return await file.writeAsBytes(
      await http.readBytes(link),
      mode: FileMode.write,
    );
  }
}
