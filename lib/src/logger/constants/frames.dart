/// The default spinner: braille dots going round.
const List<String> kSPINNER_FRAMES = <String>[
  '⠋',
  '⠙',
  '⠹',
  '⠸',
  '⠼',
  '⠴',
  '⠦',
  '⠧',
  '⠇',
  '⠏',
];

/// A spinner made from plain keyboard characters: `| / - \`.
///
/// Works in every terminal, even ones without Unicode.
const List<String> kSPINNER_LINE = <String>['|', '/', '-', r'\'];

/// An arc going round a circle: `◜◠◝◞◡◟`.
const List<String> kSPINNER_ARC = <String>['◜', '◠', '◝', '◞', '◡', '◟'];

/// A circle filling up from each side in turn: `◐◓◑◒`.
const List<String> kSPINNER_CIRCLE = <String>['◐', '◓', '◑', '◒'];

/// A dot bouncing up and down: `⠁⠂⠄⠂`.
const List<String> kSPINNER_BOUNCE = <String>['⠁', '⠂', '⠄', '⠂'];
