import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// The shells [ShellCommand] can run commands in.
enum TerminalShell {
  /// PowerShell. Uses PowerShell 7 (`pwsh`) if it is installed
  powershell,

  /// The Windows Command Prompt (`cmd`).
  cmd,

  /// Bash, on Mac and Linux (or Git Bash / WSL on Windows).
  bash,

  /// The basic POSIX shell (`/bin/sh`) on Mac and Linux.
  sh,
}

/// Runs commands as if you typed them into a terminal.
///
/// The command goes to a shell (PowerShell on Windows by default), so you can
/// use anything you would type yourself: pipes, variables, `cd`, cmdlets and
/// so on. What it prints shows up in your terminal as it happens, and you
/// also get it back to read.
///
/// The folder is remembered between commands, just like a terminal window,
/// so a `cd` carries over to the next command:
///
/// ```dart
/// await TerminalCommand.run('cd ~');
/// await TerminalCommand.run('dir');              // Lists your home folder.
/// await TerminalCommand.run(r'Get-Content $PROFILE');
///
/// final result = await TerminalCommand.run('git status', show: false);
/// if (result.ok) print(result.lines);
///
/// await TerminalCommand.run('dir /b', shell: TerminalShell.cmd);
/// ```
///
/// Variables you set (like `$env:NAME = 'x'`) only last for that one
/// command, since each command gets a fresh shell.
class ShellCommand {
  /// The shell command
  final String command;

  /// The type of shells [ShellCommand] can commands in
  final TerminalShell? shell;

  /// Whether to show it in the current terminal
  final bool show;

  /// Running as interactive allows writing to the process's [stdin]
  final bool interactive;

  /// [command]
  const ShellCommand(
    this.command, {
    this.shell,
    this.show = true,
    this.interactive = false,
  });

  Future<ProcessResult> start() async {
    return await run(
      command,
      show: show,
      interactive: interactive,
      shell: shell,
    );
  }

  /// Runs [command] in a shell and gives back what happened.
  ///
  /// * [shell]: the shell to use. Defaults to [defaultShell].
  /// * [show]: print what the command prints as it runs. Turn it off to
  ///   only read the result.
  /// * [interactive]: hand your keyboard and terminal over to the command,
  ///   for things that ask questions or take over the screen (like `ssh`,
  ///   `vim` or `Read-Host`). The result's output is then empty, because it
  ///   went straight to the terminal.
  ///
  /// Without [interactive], the command can't read typed input, so anything
  /// that asks a question gets no answer instead of waiting forever.
  ///
  /// The result works with the `ok`, `output`, `lines` and `throwIfFailed`
  /// helpers.
  static Future<ProcessResult> run(
    String command, {
    TerminalShell? shell,
    bool show = true,
    bool interactive = false,
  }) async {
    final chosen = shell ?? defaultShell;

    // The shell writes the folder it ended in to this file, so the next
    // command can start there.
    final temp = Directory.systemTemp.createTempSync('cmdline_');
    final folderFile = '${temp.path}${Platform.pathSeparator}folder.txt';

    try {
      final (program, args) = await _startArgs(
        chosen,
        command,
        folderFile,
        temp.path,
        interactive,
      );

      final process = await Process.start(
        program,
        args,
        workingDirectory: _startFolder(),
        mode: interactive
            ? ProcessStartMode.inheritStdio
            : ProcessStartMode.normal,
      );

      var output = '';
      var errors = '';
      if (!interactive) {
        // Nothing gets typed in, so close the input straight away.
        unawaited(process.stdin.close().catchError((_) {}));
        final outputDone = _collect(process.stdout, show ? stdout : null);
        final errorsDone = _collect(process.stderr, show ? stderr : null);
        output = await outputDone;
        errors = await errorsDone;
      }
      final exitCode = await process.exitCode;

      _rememberFolder(folderFile);

      return ProcessResult(process.pid, exitCode, output, errors);
    } finally {
      try {
        temp.deleteSync(recursive: true);
      } catch (_) {
        // Just a leftover temp file, so it's fine to leave it.
      }
    }
  }

  /// The shell used when [run] isn't given one.
  ///
  /// Starts as [TerminalShell.powershell].
  static TerminalShell defaultShell = TerminalShell.powershell;

  static String _directory = Directory.current.path;

  /// The folder the next command starts in.
  ///
  /// Starts as the folder your app was started in, and changes whenever a
  /// command moves somewhere else (with `cd`, for example).
  static String get directory => _directory;

  static set directory(String path) {
    final folder = Directory(path);
    if (!folder.existsSync()) {
      throw ArgumentError.value(path, 'directory', 'The folder does not exist');
    }
    _directory = folder.absolute.path;
  }

  /// The PowerShell program to use, found the first time it is needed.
  static String? _powershell;

  /// The program and arguments that run [command] in [shell].
  static Future<(String, List<String>)> _startArgs(
    TerminalShell shell,
    String command,
    String folderFile,
    String tempFolder,
    bool interactive,
  ) async {
    switch (shell) {
      case TerminalShell.powershell:
        final script = _powershellScript(command, folderFile);
        // An encoded command dodges every quoting problem, because Windows
        // can mangle quotes inside normal arguments.
        final encoded = base64.encode(_utf16le(script));

        return (
          await _findPowershell(),
          [
            '-NoProfile',
            '-NoLogo',
            if (!interactive) '-NonInteractive',
            '-ExecutionPolicy',
            'Bypass',
            '-EncodedCommand',
            encoded,
          ],
        );

      case TerminalShell.cmd:
        // A batch file dodges cmd's quoting rules for "cmd /c".
        final batch = File('$tempFolder${Platform.pathSeparator}command.bat');
        batch.writeAsStringSync(_cmdScript(command, folderFile));

        return (
          Platform.environment['ComSpec'] ?? 'cmd.exe',
          ['/d', '/c', batch.path],
        );

      case TerminalShell.bash:
      case TerminalShell.sh:
        final program = shell == TerminalShell.bash ? 'bash' : '/bin/sh';

        return (program, ['-c', _shScript(command, folderFile)]);
    }
  }

  /// Wraps [command] so PowerShell prints UTF-8 and saves its folder.
  static String _powershellScript(String command, String folderFile) {
    // It ends with SetShouldExit instead of "exit", because "exit" throws
    // away table output PowerShell hasn't printed yet.
    return '''
\$ProgressPreference = 'SilentlyContinue'
\$__cmdlineEncoding = [Console]::OutputEncoding
try { [Console]::OutputEncoding = [Text.UTF8Encoding]::new(\$false) } catch {}
\$__cmdlineOk = \$false
\$__cmdlineCode = \$null
try {
$command
\$__cmdlineOk = \$?
\$__cmdlineCode = \$LASTEXITCODE
} finally {
try { [Console]::OutputEncoding = \$__cmdlineEncoding } catch {}
try {
[IO.File]::WriteAllText(${_psQuote(folderFile)}, (Get-Location -PSProvider FileSystem).ProviderPath)
} catch {}
}
\$__cmdlineExit = if (\$__cmdlineOk) { 0 } elseif (\$__cmdlineCode) { \$__cmdlineCode } else { 1 }
\$Host.SetShouldExit(\$__cmdlineExit)
''';
  }

  /// Wraps [command] in a batch file that prints UTF-8 and saves its folder.
  static String _cmdScript(String command, String folderFile) {
    // Switch to UTF-8 (code page 65001) while the command runs, then put
    // back the old code page, since it is shared with your terminal.
    return [
      '@echo off',
      'for /f "tokens=2 delims=:." %%a in (\'chcp\') do set "__cmdline_cp=%%a"',
      'chcp 65001 >nul',
      command,
      'set "__cmdline_code=%errorlevel%"',
      'cd > "$folderFile"',
      'chcp %__cmdline_cp% >nul',
      'exit /b %__cmdline_code%',
      '',
    ].join('\r\n');
  }

  /// Wraps [command] so `sh` or `bash` saves its folder when it finishes.
  static String _shScript(String command, String folderFile) {
    // The trap runs even if the command calls "exit", and keeps its exit code.
    final save = _shQuote('pwd > ${_shQuote(folderFile)}');

    return 'trap $save EXIT\n$command';
  }

  /// Where the next command starts, falls back to your app's folder if the remembered one was deleted.
  static String _startFolder() {
    if (!Directory(_directory).existsSync()) {
      _directory = Directory.current.path;
    }

    return _directory;
  }

  /// Reads the folder the shell ended in, if it saved one.
  static void _rememberFolder(String folderFile) {
    final file = File(folderFile);
    if (!file.existsSync()) return;

    var path = file.readAsStringSync().trim();
    // Some shells start the file with an invisible byte order mark.
    if (path.startsWith('﻿')) path = path.substring(1);
    if (path.isNotEmpty && Directory(path).existsSync()) _directory = path;
  }

  /// Finds PowerShell 7 (`pwsh`), or Windows PowerShell if it isn't installed.
  static Future<String> _findPowershell() async {
    if (_powershell != null) return _powershell!;

    // Only Windows has Windows PowerShell to fall back on.
    if (!Platform.isWindows) return _powershell = 'pwsh';

    var found = 'powershell';
    try {
      final result = await Process.run('where', ['pwsh']);
      if (result.exitCode == 0) found = 'pwsh';
    } catch (_) {
      // No way to look it up, so stick with Windows PowerShell.
    }

    return _powershell = found;
  }

  /// Reads [stream] as UTF-8 text, copying it to [echo] as it arrives.
  static Future<String> _collect(Stream<List<int>> stream, IOSink? echo) async {
    final text = StringBuffer();
    final decoded = stream.transform(const Utf8Decoder(allowMalformed: true));
    await for (final chunk in decoded) {
      text.write(chunk);
      echo?.write(chunk);
    }

    return text.toString();
  }

  /// [text] as UTF-16 little-endian bytes, which `-EncodedCommand` expects.
  static List<int> _utf16le(String text) {
    final bytes = <int>[];
    for (final unit in text.codeUnits) {
      bytes
        ..add(unit & 0xFF)
        ..add(unit >> 8);
    }

    return bytes;
  }

  /// Wraps [text] in single quotes for PowerShell.
  static String _psQuote(String text) => "'${text.replaceAll("'", "''")}'";

  /// Wraps [text] in single quotes for `sh` and `bash`.
  static String _shQuote(String text) => "'${text.replaceAll("'", r"'\''")}'";
}
