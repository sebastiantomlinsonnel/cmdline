import 'package:cmdline/cmdline.dart';

/// Shows off the interactive prompts, pickers, progress and layout widgets.
///
/// The prompt scenes need a real terminal. Piped, they ask one typed line at
/// a time instead; with `CMDLINE_PROMPTS=unattended` they take defaults.
class WidgetsDemo {
  const WidgetsDemo._();

  /// Text, password, number, confirm and multi-line prompts.
  static void prompts() {
    final name = Prompts.ask('Project name', defaultValue: 'my_app');
    final password = Prompts.password(
      'Password',
      validator: (p) => p.length < 4 ? 'Use at least 4 characters' : null,
    );
    final port = Prompts.integer('Port', defaultValue: 8080, min: 1, max: 65535);
    final ratio = Prompts.decimal('Cache ratio', defaultValue: 0.5, min: 0, max: 1, step: 0.1);
    final notes = Prompts.multiline('Release notes', defaultValue: 'First release');
    final save = Prompts.confirm('Save these settings?', defaultValue: true);

    AnsiTheme.say(
      Widgets.box(
        Widgets.keyValue({
          'Name': name.bold,
          'Password': AnsiTheme.current.glyphs.mask * password.length,
          'Port': port,
          'Ratio': ratio,
          'Notes': notes,
          'Saved': save ? 'yes' : 'no',
        }),
        title: 'Answers',
      ),
    );
  }

  /// Lists: select, multi-select, search, tags, grid and toggles.
  static void choose() {
    final template = Prompts.select(
      'Template',
      ['console', 'package', 'server-shelf', 'web'],
      note: (t) => switch (t) {
        'console' => 'A command-line app',
        'package' => 'A library to share',
        'server-shelf' => 'A web server',
        _ => 'A web app',
      },
    );
    final features = Prompts.multiSelect(
      'Features',
      ['Logging', 'Tests', 'Docs', 'CI', 'Docker'],
      selected: ['Tests'],
      min: 1,
    );
    final command = Prompts.search(
      'Run a command',
      ['git checkout', 'git commit', 'git cherry-pick', 'go build', 'grep', 'dart test', 'dart format'],
      note: (c) => c.split(' ').first,
    );
    final labels = Prompts.tags('Labels', suggestions: ['bug', 'feature', 'docs', 'help wanted']);
    final size = Prompts.grid('T-shirt size', ['XS', 'S', 'M', 'L', 'XL', 'XXL'], columns: 3);
    final settings = Prompts.toggles('Settings', {
      'Dark mode': true,
      'Telemetry': false,
      'Auto update': true,
    });

    AnsiTheme.say(
      Widgets.keyValue({
        'Template': template,
        'Features': features.join(', '),
        'Command': command,
        'Labels': labels.join(', '),
        'Size': size,
        'Settings': settings.entries.where((e) => e.value).map((e) => e.key).join(', '),
      }),
    );
  }

  /// Pickers: slider, range, rating, date, file and colour.
  static void pickers() {
    final volume = Pickers.slider('Volume', start: 70, unit: '%');
    final price = Pickers.range('Price', max: 500, step: 10, initial: (start: 50, end: 200));
    final stars = Pickers.rating('How was it?', labels: ['Awful', 'Bad', 'Okay', 'Good', 'Great']);
    final due = Pickers.date('Due date', first: DateTime.now());
    final file = Pickers.file('Open a file');
    final accent = Pickers.colour('Accent colour');

    AnsiTheme.say(
      Widgets.keyValue({
        'Volume': '$volume%',
        'Price': '${price.start} - ${price.end}',
        'Stars': stars,
        'Due': DatePrompt.iso(due),
        'File': file,
        'Accent': '  '.background(accent),
      }),
    );
  }

  /// Spinners, progress bars and tasks running side by side.
  static Future<void> progress() async {
    final spinner = Spinner('Resolving packages').start();
    await Future<void>.delayed(const Duration(milliseconds: 800));
    spinner.log('Found 12 packages');
    await Future<void>.delayed(const Duration(milliseconds: 800));
    spinner.pass('Resolved 12 packages');

    await Spinner.run(
      'Checking the network',
      () => Future<void>.delayed(const Duration(seconds: 1)),
      frames: kSPINNER_ARC,
    );

    final bar = ProgressBar('Copying files', total: 40);
    for (var i = 0; i < 40; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
      bar.add();
    }
    bar.done('Copied 40 files');

    final reports = await Tasks.run([
      Task('Download', (task) async {
        for (var i = 1; i <= 20; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 60));
          task.progress(i, 20);
        }
      }),
      Task('Compile', (task) async {
        for (final step in ['parsing', 'checking types', 'writing']) {
          task.update(step);
          await Future<void>.delayed(const Duration(milliseconds: 500));
        }
        task.update('');
      }),
      Task('Lint', (task) async {
        await Future<void>.delayed(const Duration(milliseconds: 700));
        throw Exception('3 problems');
      }),
      Task('Upload', (task) async {
        await Future<void>.delayed(const Duration(milliseconds: 600));
      }),
    ], concurrency: 3);
    final failed = reports.where((r) => !r.ok).length;
    AnsiTheme.say(Widgets.rule(title: '$failed of ${reports.length} tasks failed'));
  }

  /// Boxes, callouts, tables, trees and lists.
  static void layout() {
    final parts = [
      Widgets.rule(title: 'Layout widgets'),
      Widgets.callout('The config file is missing, so the defaults are used.', tone: Tone.warn),
      Widgets.callout('Deployed to production.', tone: Tone.success),
      Widgets.table(
        [
          ['prompts.dart', 'Text, numbers, confirm, lists, search and tags', 420],
          ['pickers.dart', 'Sliders, ranges, ratings, dates, files and colours', 190],
          ['widgets.dart', 'Boxes, tables, trees and lists', 300],
        ],
        header: ['File', 'What it holds', 'Lines'],
        rightAligned: {2},
        maxWidth: 60,
      ),
      Widgets.tree([
        const TreeNode('lib', [
          TreeNode('src', [
            TreeNode('cli', [
              TreeNode('tui', [TreeNode('prompts.dart'), TreeNode('widgets.dart')]),
            ]),
          ]),
          TreeNode('cmdline.dart'),
        ]),
      ]),
      Widgets.bullets(['Install Dart', 'Run dart pub get', 'Run dart test'], numbered: true),
      Widgets.hotkeys([('↑↓', 'move'), ('enter', 'pick'), ('esc', 'cancel')]),
    ];
    parts.forEach(AnsiTheme.say);
  }
}
