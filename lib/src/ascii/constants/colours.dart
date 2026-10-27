import 'package:cmdline/cmdline.dart';

/// Palette parameters for standard black (colour index 0).
///
/// Usually about #000000, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [BLACK_FG], [BLACK_BG].
const String BLACK = '5;0';

/// Palette parameters for standard red (colour index 1).
///
/// Usually about #CD0000, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [RED_FG], [RED_BG].
const String RED = '5;1';

/// Palette parameters for standard green (colour index 2).
///
/// Usually about #00CD00, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [GREEN_FG], [GREEN_BG].
const String GREEN = '5;2';

/// Palette parameters for standard yellow (colour index 3).
///
/// Usually about #CDCD00, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [YELLOW_FG], [YELLOW_BG].
const String YELLOW = '5;3';

/// Palette parameters for standard blue (colour index 4).
///
/// Usually about #0000EE, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [BLUE_FG], [BLUE_BG].
const String BLUE = '5;4';

/// Palette parameters for standard magenta (colour index 5).
///
/// Usually about #CD00CD, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [MAGENTA_FG], [MAGENTA_BG].
const String MAGENTA = '5;5';

/// Palette parameters for standard cyan (colour index 6).
///
/// Usually about #00CDCD, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [CYAN_FG], [CYAN_BG].
const String CYAN = '5;6';

/// Palette parameters for standard white (colour index 7).
///
/// Usually about #E5E5E5, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [WHITE_FG], [WHITE_BG].
const String WHITE = '5;7';

/// Palette parameters for bright black (colour index 8).
///
/// Usually about #7F7F7F, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [HIGH_BLACK_FG], [HIGH_BLACK_BG].
const String HIGH_BLACK = '5;8';

/// Palette parameters for bright red (colour index 9).
///
/// Usually about #FF0000, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [HIGH_RED_FG], [HIGH_RED_BG].
const String HIGH_RED = '5;9';

/// Palette parameters for bright green (colour index 10).
///
/// Usually about #00FF00, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [HIGH_GREEN_FG], [HIGH_GREEN_BG].
const String HIGH_GREEN = '5;10';

/// Palette parameters for bright yellow (colour index 11).
///
/// Usually about #FFFF00, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [HIGH_YELLOW_FG], [HIGH_YELLOW_BG].
const String HIGH_YELLOW = '5;11';

/// Palette parameters for bright blue (colour index 12).
///
/// Usually about #5C5CFF, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [HIGH_BLUE_FG], [HIGH_BLUE_BG].
const String HIGH_BLUE = '5;12';

/// Palette parameters for bright magenta (colour index 13).
///
/// Usually about #FF00FF, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [HIGH_MAGENTA_FG], [HIGH_MAGENTA_BG].
const String HIGH_MAGENTA = '5;13';

/// Palette parameters for bright cyan (colour index 14).
///
/// Usually about #00FFFF, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [HIGH_CYAN_FG], [HIGH_CYAN_BG].
const String HIGH_CYAN = '5;14';

/// Palette parameters for bright white (colour index 15).
///
/// Usually about #FFFFFF, but the terminal theme decides. Goes after `38;`
/// (text), `48;` (background) or `58;` (underline) in an SGR sequence.
/// Ready-made codes: [HIGH_WHITE_FG], [HIGH_WHITE_BG].
const String HIGH_WHITE = '5;15';

/// Palette parameters for colour-cube red 0, green 0, blue 0 (colour index 16).
///
/// About #000000. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_000_FG],
/// [RGB_000_BG].
const String RGB_000 = '5;16';

/// Palette parameters for colour-cube red 0, green 0, blue 1 (colour index 17).
///
/// About #00005F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_001_FG],
/// [RGB_001_BG].
const String RGB_001 = '5;17';

/// Palette parameters for colour-cube red 0, green 0, blue 2 (colour index 18).
///
/// About #000087. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_002_FG],
/// [RGB_002_BG].
const String RGB_002 = '5;18';

/// Palette parameters for colour-cube red 0, green 0, blue 3 (colour index 19).
///
/// About #0000AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_003_FG],
/// [RGB_003_BG].
const String RGB_003 = '5;19';

/// Palette parameters for colour-cube red 0, green 0, blue 4 (colour index 20).
///
/// About #0000D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_004_FG],
/// [RGB_004_BG].
const String RGB_004 = '5;20';

/// Palette parameters for colour-cube red 0, green 0, blue 5 (colour index 21).
///
/// About #0000FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_005_FG],
/// [RGB_005_BG].
const String RGB_005 = '5;21';

/// Palette parameters for colour-cube red 0, green 1, blue 0 (colour index 22).
///
/// About #005F00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_010_FG],
/// [RGB_010_BG].
const String RGB_010 = '5;22';

/// Palette parameters for colour-cube red 0, green 1, blue 1 (colour index 23).
///
/// About #005F5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_011_FG],
/// [RGB_011_BG].
const String RGB_011 = '5;23';

/// Palette parameters for colour-cube red 0, green 1, blue 2 (colour index 24).
///
/// About #005F87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_012_FG],
/// [RGB_012_BG].
const String RGB_012 = '5;24';

/// Palette parameters for colour-cube red 0, green 1, blue 3 (colour index 25).
///
/// About #005FAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_013_FG],
/// [RGB_013_BG].
const String RGB_013 = '5;25';

/// Palette parameters for colour-cube red 0, green 1, blue 4 (colour index 26).
///
/// About #005FD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_014_FG],
/// [RGB_014_BG].
const String RGB_014 = '5;26';

/// Palette parameters for colour-cube red 0, green 1, blue 5 (colour index 27).
///
/// About #005FFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_015_FG],
/// [RGB_015_BG].
const String RGB_015 = '5;27';

/// Palette parameters for colour-cube red 0, green 2, blue 0 (colour index 28).
///
/// About #008700. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_020_FG],
/// [RGB_020_BG].
const String RGB_020 = '5;28';

/// Palette parameters for colour-cube red 0, green 2, blue 1 (colour index 29).
///
/// About #00875F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_021_FG],
/// [RGB_021_BG].
const String RGB_021 = '5;29';

/// Palette parameters for colour-cube red 0, green 2, blue 2 (colour index 30).
///
/// About #008787. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_022_FG],
/// [RGB_022_BG].
const String RGB_022 = '5;30';

/// Palette parameters for colour-cube red 0, green 2, blue 3 (colour index 31).
///
/// About #0087AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_023_FG],
/// [RGB_023_BG].
const String RGB_023 = '5;31';

/// Palette parameters for colour-cube red 0, green 2, blue 4 (colour index 32).
///
/// About #0087D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_024_FG],
/// [RGB_024_BG].
const String RGB_024 = '5;32';

/// Palette parameters for colour-cube red 0, green 2, blue 5 (colour index 33).
///
/// About #0087FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_025_FG],
/// [RGB_025_BG].
const String RGB_025 = '5;33';

/// Palette parameters for colour-cube red 0, green 3, blue 0 (colour index 34).
///
/// About #00AF00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_030_FG],
/// [RGB_030_BG].
const String RGB_030 = '5;34';

/// Palette parameters for colour-cube red 0, green 3, blue 1 (colour index 35).
///
/// About #00AF5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_031_FG],
/// [RGB_031_BG].
const String RGB_031 = '5;35';

/// Palette parameters for colour-cube red 0, green 3, blue 2 (colour index 36).
///
/// About #00AF87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_032_FG],
/// [RGB_032_BG].
const String RGB_032 = '5;36';

/// Palette parameters for colour-cube red 0, green 3, blue 3 (colour index 37).
///
/// About #00AFAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_033_FG],
/// [RGB_033_BG].
const String RGB_033 = '5;37';

/// Palette parameters for colour-cube red 0, green 3, blue 4 (colour index 38).
///
/// About #00AFD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_034_FG],
/// [RGB_034_BG].
const String RGB_034 = '5;38';

/// Palette parameters for colour-cube red 0, green 3, blue 5 (colour index 39).
///
/// About #00AFFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_035_FG],
/// [RGB_035_BG].
const String RGB_035 = '5;39';

/// Palette parameters for colour-cube red 0, green 4, blue 0 (colour index 40).
///
/// About #00D700. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_040_FG],
/// [RGB_040_BG].
const String RGB_040 = '5;40';

/// Palette parameters for colour-cube red 0, green 4, blue 1 (colour index 41).
///
/// About #00D75F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_041_FG],
/// [RGB_041_BG].
const String RGB_041 = '5;41';

/// Palette parameters for colour-cube red 0, green 4, blue 2 (colour index 42).
///
/// About #00D787. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_042_FG],
/// [RGB_042_BG].
const String RGB_042 = '5;42';

/// Palette parameters for colour-cube red 0, green 4, blue 3 (colour index 43).
///
/// About #00D7AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_043_FG],
/// [RGB_043_BG].
const String RGB_043 = '5;43';

/// Palette parameters for colour-cube red 0, green 4, blue 4 (colour index 44).
///
/// About #00D7D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_044_FG],
/// [RGB_044_BG].
const String RGB_044 = '5;44';

/// Palette parameters for colour-cube red 0, green 4, blue 5 (colour index 45).
///
/// About #00D7FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_045_FG],
/// [RGB_045_BG].
const String RGB_045 = '5;45';

/// Palette parameters for colour-cube red 0, green 5, blue 0 (colour index 46).
///
/// About #00FF00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_050_FG],
/// [RGB_050_BG].
const String RGB_050 = '5;46';

/// Palette parameters for colour-cube red 0, green 5, blue 1 (colour index 47).
///
/// About #00FF5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_051_FG],
/// [RGB_051_BG].
const String RGB_051 = '5;47';

/// Palette parameters for colour-cube red 0, green 5, blue 2 (colour index 48).
///
/// About #00FF87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_052_FG],
/// [RGB_052_BG].
const String RGB_052 = '5;48';

/// Palette parameters for colour-cube red 0, green 5, blue 3 (colour index 49).
///
/// About #00FFAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_053_FG],
/// [RGB_053_BG].
const String RGB_053 = '5;49';

/// Palette parameters for colour-cube red 0, green 5, blue 4 (colour index 50).
///
/// About #00FFD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_054_FG],
/// [RGB_054_BG].
const String RGB_054 = '5;50';

/// Palette parameters for colour-cube red 0, green 5, blue 5 (colour index 51).
///
/// About #00FFFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_055_FG],
/// [RGB_055_BG].
const String RGB_055 = '5;51';

/// Palette parameters for colour-cube red 1, green 0, blue 0 (colour index 52).
///
/// About #5F0000. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_100_FG],
/// [RGB_100_BG].
const String RGB_100 = '5;52';

/// Palette parameters for colour-cube red 1, green 0, blue 1 (colour index 53).
///
/// About #5F005F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_101_FG],
/// [RGB_101_BG].
const String RGB_101 = '5;53';

/// Palette parameters for colour-cube red 1, green 0, blue 2 (colour index 54).
///
/// About #5F0087. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_102_FG],
/// [RGB_102_BG].
const String RGB_102 = '5;54';

/// Palette parameters for colour-cube red 1, green 0, blue 3 (colour index 55).
///
/// About #5F00AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_103_FG],
/// [RGB_103_BG].
const String RGB_103 = '5;55';

/// Palette parameters for colour-cube red 1, green 0, blue 4 (colour index 56).
///
/// About #5F00D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_104_FG],
/// [RGB_104_BG].
const String RGB_104 = '5;56';

/// Palette parameters for colour-cube red 1, green 0, blue 5 (colour index 57).
///
/// About #5F00FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_105_FG],
/// [RGB_105_BG].
const String RGB_105 = '5;57';

/// Palette parameters for colour-cube red 1, green 1, blue 0 (colour index 58).
///
/// About #5F5F00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_110_FG],
/// [RGB_110_BG].
const String RGB_110 = '5;58';

/// Palette parameters for colour-cube red 1, green 1, blue 1 (colour index 59).
///
/// About #5F5F5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_111_FG],
/// [RGB_111_BG].
const String RGB_111 = '5;59';

/// Palette parameters for colour-cube red 1, green 1, blue 2 (colour index 60).
///
/// About #5F5F87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_112_FG],
/// [RGB_112_BG].
const String RGB_112 = '5;60';

/// Palette parameters for colour-cube red 1, green 1, blue 3 (colour index 61).
///
/// About #5F5FAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_113_FG],
/// [RGB_113_BG].
const String RGB_113 = '5;61';

/// Palette parameters for colour-cube red 1, green 1, blue 4 (colour index 62).
///
/// About #5F5FD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_114_FG],
/// [RGB_114_BG].
const String RGB_114 = '5;62';

/// Palette parameters for colour-cube red 1, green 1, blue 5 (colour index 63).
///
/// About #5F5FFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_115_FG],
/// [RGB_115_BG].
const String RGB_115 = '5;63';

/// Palette parameters for colour-cube red 1, green 2, blue 0 (colour index 64).
///
/// About #5F8700. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_120_FG],
/// [RGB_120_BG].
const String RGB_120 = '5;64';

/// Palette parameters for colour-cube red 1, green 2, blue 1 (colour index 65).
///
/// About #5F875F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_121_FG],
/// [RGB_121_BG].
const String RGB_121 = '5;65';

/// Palette parameters for colour-cube red 1, green 2, blue 2 (colour index 66).
///
/// About #5F8787. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_122_FG],
/// [RGB_122_BG].
const String RGB_122 = '5;66';

/// Palette parameters for colour-cube red 1, green 2, blue 3 (colour index 67).
///
/// About #5F87AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_123_FG],
/// [RGB_123_BG].
const String RGB_123 = '5;67';

/// Palette parameters for colour-cube red 1, green 2, blue 4 (colour index 68).
///
/// About #5F87D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_124_FG],
/// [RGB_124_BG].
const String RGB_124 = '5;68';

/// Palette parameters for colour-cube red 1, green 2, blue 5 (colour index 69).
///
/// About #5F87FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_125_FG],
/// [RGB_125_BG].
const String RGB_125 = '5;69';

/// Palette parameters for colour-cube red 1, green 3, blue 0 (colour index 70).
///
/// About #5FAF00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_130_FG],
/// [RGB_130_BG].
const String RGB_130 = '5;70';

/// Palette parameters for colour-cube red 1, green 3, blue 1 (colour index 71).
///
/// About #5FAF5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_131_FG],
/// [RGB_131_BG].
const String RGB_131 = '5;71';

/// Palette parameters for colour-cube red 1, green 3, blue 2 (colour index 72).
///
/// About #5FAF87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_132_FG],
/// [RGB_132_BG].
const String RGB_132 = '5;72';

/// Palette parameters for colour-cube red 1, green 3, blue 3 (colour index 73).
///
/// About #5FAFAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_133_FG],
/// [RGB_133_BG].
const String RGB_133 = '5;73';

/// Palette parameters for colour-cube red 1, green 3, blue 4 (colour index 74).
///
/// About #5FAFD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_134_FG],
/// [RGB_134_BG].
const String RGB_134 = '5;74';

/// Palette parameters for colour-cube red 1, green 3, blue 5 (colour index 75).
///
/// About #5FAFFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_135_FG],
/// [RGB_135_BG].
const String RGB_135 = '5;75';

/// Palette parameters for colour-cube red 1, green 4, blue 0 (colour index 76).
///
/// About #5FD700. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_140_FG],
/// [RGB_140_BG].
const String RGB_140 = '5;76';

/// Palette parameters for colour-cube red 1, green 4, blue 1 (colour index 77).
///
/// About #5FD75F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_141_FG],
/// [RGB_141_BG].
const String RGB_141 = '5;77';

/// Palette parameters for colour-cube red 1, green 4, blue 2 (colour index 78).
///
/// About #5FD787. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_142_FG],
/// [RGB_142_BG].
const String RGB_142 = '5;78';

/// Palette parameters for colour-cube red 1, green 4, blue 3 (colour index 79).
///
/// About #5FD7AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_143_FG],
/// [RGB_143_BG].
const String RGB_143 = '5;79';

/// Palette parameters for colour-cube red 1, green 4, blue 4 (colour index 80).
///
/// About #5FD7D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_144_FG],
/// [RGB_144_BG].
const String RGB_144 = '5;80';

/// Palette parameters for colour-cube red 1, green 4, blue 5 (colour index 81).
///
/// About #5FD7FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_145_FG],
/// [RGB_145_BG].
const String RGB_145 = '5;81';

/// Palette parameters for colour-cube red 1, green 5, blue 0 (colour index 82).
///
/// About #5FFF00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_150_FG],
/// [RGB_150_BG].
const String RGB_150 = '5;82';

/// Palette parameters for colour-cube red 1, green 5, blue 1 (colour index 83).
///
/// About #5FFF5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_151_FG],
/// [RGB_151_BG].
const String RGB_151 = '5;83';

/// Palette parameters for colour-cube red 1, green 5, blue 2 (colour index 84).
///
/// About #5FFF87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_152_FG],
/// [RGB_152_BG].
const String RGB_152 = '5;84';

/// Palette parameters for colour-cube red 1, green 5, blue 3 (colour index 85).
///
/// About #5FFFAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_153_FG],
/// [RGB_153_BG].
const String RGB_153 = '5;85';

/// Palette parameters for colour-cube red 1, green 5, blue 4 (colour index 86).
///
/// About #5FFFD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_154_FG],
/// [RGB_154_BG].
const String RGB_154 = '5;86';

/// Palette parameters for colour-cube red 1, green 5, blue 5 (colour index 87).
///
/// About #5FFFFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_155_FG],
/// [RGB_155_BG].
const String RGB_155 = '5;87';

/// Palette parameters for colour-cube red 2, green 0, blue 0 (colour index 88).
///
/// About #870000. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_200_FG],
/// [RGB_200_BG].
const String RGB_200 = '5;88';

/// Palette parameters for colour-cube red 2, green 0, blue 1 (colour index 89).
///
/// About #87005F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_201_FG],
/// [RGB_201_BG].
const String RGB_201 = '5;89';

/// Palette parameters for colour-cube red 2, green 0, blue 2 (colour index 90).
///
/// About #870087. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_202_FG],
/// [RGB_202_BG].
const String RGB_202 = '5;90';

/// Palette parameters for colour-cube red 2, green 0, blue 3 (colour index 91).
///
/// About #8700AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_203_FG],
/// [RGB_203_BG].
const String RGB_203 = '5;91';

/// Palette parameters for colour-cube red 2, green 0, blue 4 (colour index 92).
///
/// About #8700D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_204_FG],
/// [RGB_204_BG].
const String RGB_204 = '5;92';

/// Palette parameters for colour-cube red 2, green 0, blue 5 (colour index 93).
///
/// About #8700FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_205_FG],
/// [RGB_205_BG].
const String RGB_205 = '5;93';

/// Palette parameters for colour-cube red 2, green 1, blue 0 (colour index 94).
///
/// About #875F00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_210_FG],
/// [RGB_210_BG].
const String RGB_210 = '5;94';

/// Palette parameters for colour-cube red 2, green 1, blue 1 (colour index 95).
///
/// About #875F5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_211_FG],
/// [RGB_211_BG].
const String RGB_211 = '5;95';

/// Palette parameters for colour-cube red 2, green 1, blue 2 (colour index 96).
///
/// About #875F87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_212_FG],
/// [RGB_212_BG].
const String RGB_212 = '5;96';

/// Palette parameters for colour-cube red 2, green 1, blue 3 (colour index 97).
///
/// About #875FAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_213_FG],
/// [RGB_213_BG].
const String RGB_213 = '5;97';

/// Palette parameters for colour-cube red 2, green 1, blue 4 (colour index 98).
///
/// About #875FD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_214_FG],
/// [RGB_214_BG].
const String RGB_214 = '5;98';

/// Palette parameters for colour-cube red 2, green 1, blue 5 (colour index 99).
///
/// About #875FFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_215_FG],
/// [RGB_215_BG].
const String RGB_215 = '5;99';

/// Palette parameters for colour-cube red 2, green 2, blue 0 (colour index
/// 100).
///
/// About #878700. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_220_FG],
/// [RGB_220_BG].
const String RGB_220 = '5;100';

/// Palette parameters for colour-cube red 2, green 2, blue 1 (colour index
/// 101).
///
/// About #87875F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_221_FG],
/// [RGB_221_BG].
const String RGB_221 = '5;101';

/// Palette parameters for colour-cube red 2, green 2, blue 2 (colour index
/// 102).
///
/// About #878787. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_222_FG],
/// [RGB_222_BG].
const String RGB_222 = '5;102';

/// Palette parameters for colour-cube red 2, green 2, blue 3 (colour index
/// 103).
///
/// About #8787AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_223_FG],
/// [RGB_223_BG].
const String RGB_223 = '5;103';

/// Palette parameters for colour-cube red 2, green 2, blue 4 (colour index
/// 104).
///
/// About #8787D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_224_FG],
/// [RGB_224_BG].
const String RGB_224 = '5;104';

/// Palette parameters for colour-cube red 2, green 2, blue 5 (colour index
/// 105).
///
/// About #8787FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_225_FG],
/// [RGB_225_BG].
const String RGB_225 = '5;105';

/// Palette parameters for colour-cube red 2, green 3, blue 0 (colour index
/// 106).
///
/// About #87AF00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_230_FG],
/// [RGB_230_BG].
const String RGB_230 = '5;106';

/// Palette parameters for colour-cube red 2, green 3, blue 1 (colour index
/// 107).
///
/// About #87AF5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_231_FG],
/// [RGB_231_BG].
const String RGB_231 = '5;107';

/// Palette parameters for colour-cube red 2, green 3, blue 2 (colour index
/// 108).
///
/// About #87AF87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_232_FG],
/// [RGB_232_BG].
const String RGB_232 = '5;108';

/// Palette parameters for colour-cube red 2, green 3, blue 3 (colour index
/// 109).
///
/// About #87AFAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_233_FG],
/// [RGB_233_BG].
const String RGB_233 = '5;109';

/// Palette parameters for colour-cube red 2, green 3, blue 4 (colour index
/// 110).
///
/// About #87AFD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_234_FG],
/// [RGB_234_BG].
const String RGB_234 = '5;110';

/// Palette parameters for colour-cube red 2, green 3, blue 5 (colour index
/// 111).
///
/// About #87AFFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_235_FG],
/// [RGB_235_BG].
const String RGB_235 = '5;111';

/// Palette parameters for colour-cube red 2, green 4, blue 0 (colour index
/// 112).
///
/// About #87D700. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_240_FG],
/// [RGB_240_BG].
const String RGB_240 = '5;112';

/// Palette parameters for colour-cube red 2, green 4, blue 1 (colour index
/// 113).
///
/// About #87D75F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_241_FG],
/// [RGB_241_BG].
const String RGB_241 = '5;113';

/// Palette parameters for colour-cube red 2, green 4, blue 2 (colour index
/// 114).
///
/// About #87D787. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_242_FG],
/// [RGB_242_BG].
const String RGB_242 = '5;114';

/// Palette parameters for colour-cube red 2, green 4, blue 3 (colour index
/// 115).
///
/// About #87D7AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_243_FG],
/// [RGB_243_BG].
const String RGB_243 = '5;115';

/// Palette parameters for colour-cube red 2, green 4, blue 4 (colour index
/// 116).
///
/// About #87D7D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_244_FG],
/// [RGB_244_BG].
const String RGB_244 = '5;116';

/// Palette parameters for colour-cube red 2, green 4, blue 5 (colour index
/// 117).
///
/// About #87D7FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_245_FG],
/// [RGB_245_BG].
const String RGB_245 = '5;117';

/// Palette parameters for colour-cube red 2, green 5, blue 0 (colour index
/// 118).
///
/// About #87FF00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_250_FG],
/// [RGB_250_BG].
const String RGB_250 = '5;118';

/// Palette parameters for colour-cube red 2, green 5, blue 1 (colour index
/// 119).
///
/// About #87FF5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_251_FG],
/// [RGB_251_BG].
const String RGB_251 = '5;119';

/// Palette parameters for colour-cube red 2, green 5, blue 2 (colour index
/// 120).
///
/// About #87FF87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_252_FG],
/// [RGB_252_BG].
const String RGB_252 = '5;120';

/// Palette parameters for colour-cube red 2, green 5, blue 3 (colour index
/// 121).
///
/// About #87FFAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_253_FG],
/// [RGB_253_BG].
const String RGB_253 = '5;121';

/// Palette parameters for colour-cube red 2, green 5, blue 4 (colour index
/// 122).
///
/// About #87FFD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_254_FG],
/// [RGB_254_BG].
const String RGB_254 = '5;122';

/// Palette parameters for colour-cube red 2, green 5, blue 5 (colour index
/// 123).
///
/// About #87FFFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_255_FG],
/// [RGB_255_BG].
const String RGB_255 = '5;123';

/// Palette parameters for colour-cube red 3, green 0, blue 0 (colour index
/// 124).
///
/// About #AF0000. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_300_FG],
/// [RGB_300_BG].
const String RGB_300 = '5;124';

/// Palette parameters for colour-cube red 3, green 0, blue 1 (colour index
/// 125).
///
/// About #AF005F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_301_FG],
/// [RGB_301_BG].
const String RGB_301 = '5;125';

/// Palette parameters for colour-cube red 3, green 0, blue 2 (colour index
/// 126).
///
/// About #AF0087. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_302_FG],
/// [RGB_302_BG].
const String RGB_302 = '5;126';

/// Palette parameters for colour-cube red 3, green 0, blue 3 (colour index
/// 127).
///
/// About #AF00AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_303_FG],
/// [RGB_303_BG].
const String RGB_303 = '5;127';

/// Palette parameters for colour-cube red 3, green 0, blue 4 (colour index
/// 128).
///
/// About #AF00D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_304_FG],
/// [RGB_304_BG].
const String RGB_304 = '5;128';

/// Palette parameters for colour-cube red 3, green 0, blue 5 (colour index
/// 129).
///
/// About #AF00FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_305_FG],
/// [RGB_305_BG].
const String RGB_305 = '5;129';

/// Palette parameters for colour-cube red 3, green 1, blue 0 (colour index
/// 130).
///
/// About #AF5F00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_310_FG],
/// [RGB_310_BG].
const String RGB_310 = '5;130';

/// Palette parameters for colour-cube red 3, green 1, blue 1 (colour index
/// 131).
///
/// About #AF5F5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_311_FG],
/// [RGB_311_BG].
const String RGB_311 = '5;131';

/// Palette parameters for colour-cube red 3, green 1, blue 2 (colour index
/// 132).
///
/// About #AF5F87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_312_FG],
/// [RGB_312_BG].
const String RGB_312 = '5;132';

/// Palette parameters for colour-cube red 3, green 1, blue 3 (colour index
/// 133).
///
/// About #AF5FAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_313_FG],
/// [RGB_313_BG].
const String RGB_313 = '5;133';

/// Palette parameters for colour-cube red 3, green 1, blue 4 (colour index
/// 134).
///
/// About #AF5FD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_314_FG],
/// [RGB_314_BG].
const String RGB_314 = '5;134';

/// Palette parameters for colour-cube red 3, green 1, blue 5 (colour index
/// 135).
///
/// About #AF5FFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_315_FG],
/// [RGB_315_BG].
const String RGB_315 = '5;135';

/// Palette parameters for colour-cube red 3, green 2, blue 0 (colour index
/// 136).
///
/// About #AF8700. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_320_FG],
/// [RGB_320_BG].
const String RGB_320 = '5;136';

/// Palette parameters for colour-cube red 3, green 2, blue 1 (colour index
/// 137).
///
/// About #AF875F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_321_FG],
/// [RGB_321_BG].
const String RGB_321 = '5;137';

/// Palette parameters for colour-cube red 3, green 2, blue 2 (colour index
/// 138).
///
/// About #AF8787. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_322_FG],
/// [RGB_322_BG].
const String RGB_322 = '5;138';

/// Palette parameters for colour-cube red 3, green 2, blue 3 (colour index
/// 139).
///
/// About #AF87AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_323_FG],
/// [RGB_323_BG].
const String RGB_323 = '5;139';

/// Palette parameters for colour-cube red 3, green 2, blue 4 (colour index
/// 140).
///
/// About #AF87D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_324_FG],
/// [RGB_324_BG].
const String RGB_324 = '5;140';

/// Palette parameters for colour-cube red 3, green 2, blue 5 (colour index
/// 141).
///
/// About #AF87FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_325_FG],
/// [RGB_325_BG].
const String RGB_325 = '5;141';

/// Palette parameters for colour-cube red 3, green 3, blue 0 (colour index
/// 142).
///
/// About #AFAF00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_330_FG],
/// [RGB_330_BG].
const String RGB_330 = '5;142';

/// Palette parameters for colour-cube red 3, green 3, blue 1 (colour index
/// 143).
///
/// About #AFAF5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_331_FG],
/// [RGB_331_BG].
const String RGB_331 = '5;143';

/// Palette parameters for colour-cube red 3, green 3, blue 2 (colour index
/// 144).
///
/// About #AFAF87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_332_FG],
/// [RGB_332_BG].
const String RGB_332 = '5;144';

/// Palette parameters for colour-cube red 3, green 3, blue 3 (colour index
/// 145).
///
/// About #AFAFAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_333_FG],
/// [RGB_333_BG].
const String RGB_333 = '5;145';

/// Palette parameters for colour-cube red 3, green 3, blue 4 (colour index
/// 146).
///
/// About #AFAFD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_334_FG],
/// [RGB_334_BG].
const String RGB_334 = '5;146';

/// Palette parameters for colour-cube red 3, green 3, blue 5 (colour index
/// 147).
///
/// About #AFAFFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_335_FG],
/// [RGB_335_BG].
const String RGB_335 = '5;147';

/// Palette parameters for colour-cube red 3, green 4, blue 0 (colour index
/// 148).
///
/// About #AFD700. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_340_FG],
/// [RGB_340_BG].
const String RGB_340 = '5;148';

/// Palette parameters for colour-cube red 3, green 4, blue 1 (colour index
/// 149).
///
/// About #AFD75F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_341_FG],
/// [RGB_341_BG].
const String RGB_341 = '5;149';

/// Palette parameters for colour-cube red 3, green 4, blue 2 (colour index
/// 150).
///
/// About #AFD787. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_342_FG],
/// [RGB_342_BG].
const String RGB_342 = '5;150';

/// Palette parameters for colour-cube red 3, green 4, blue 3 (colour index
/// 151).
///
/// About #AFD7AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_343_FG],
/// [RGB_343_BG].
const String RGB_343 = '5;151';

/// Palette parameters for colour-cube red 3, green 4, blue 4 (colour index
/// 152).
///
/// About #AFD7D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_344_FG],
/// [RGB_344_BG].
const String RGB_344 = '5;152';

/// Palette parameters for colour-cube red 3, green 4, blue 5 (colour index
/// 153).
///
/// About #AFD7FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_345_FG],
/// [RGB_345_BG].
const String RGB_345 = '5;153';

/// Palette parameters for colour-cube red 3, green 5, blue 0 (colour index
/// 154).
///
/// About #AFFF00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_350_FG],
/// [RGB_350_BG].
const String RGB_350 = '5;154';

/// Palette parameters for colour-cube red 3, green 5, blue 1 (colour index
/// 155).
///
/// About #AFFF5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_351_FG],
/// [RGB_351_BG].
const String RGB_351 = '5;155';

/// Palette parameters for colour-cube red 3, green 5, blue 2 (colour index
/// 156).
///
/// About #AFFF87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_352_FG],
/// [RGB_352_BG].
const String RGB_352 = '5;156';

/// Palette parameters for colour-cube red 3, green 5, blue 3 (colour index
/// 157).
///
/// About #AFFFAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_353_FG],
/// [RGB_353_BG].
const String RGB_353 = '5;157';

/// Palette parameters for colour-cube red 3, green 5, blue 4 (colour index
/// 158).
///
/// About #AFFFD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_354_FG],
/// [RGB_354_BG].
const String RGB_354 = '5;158';

/// Palette parameters for colour-cube red 3, green 5, blue 5 (colour index
/// 159).
///
/// About #AFFFFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_355_FG],
/// [RGB_355_BG].
const String RGB_355 = '5;159';

/// Palette parameters for colour-cube red 4, green 0, blue 0 (colour index
/// 160).
///
/// About #D70000. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_400_FG],
/// [RGB_400_BG].
const String RGB_400 = '5;160';

/// Palette parameters for colour-cube red 4, green 0, blue 1 (colour index
/// 161).
///
/// About #D7005F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_401_FG],
/// [RGB_401_BG].
const String RGB_401 = '5;161';

/// Palette parameters for colour-cube red 4, green 0, blue 2 (colour index
/// 162).
///
/// About #D70087. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_402_FG],
/// [RGB_402_BG].
const String RGB_402 = '5;162';

/// Palette parameters for colour-cube red 4, green 0, blue 3 (colour index
/// 163).
///
/// About #D700AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_403_FG],
/// [RGB_403_BG].
const String RGB_403 = '5;163';

/// Palette parameters for colour-cube red 4, green 0, blue 4 (colour index
/// 164).
///
/// About #D700D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_404_FG],
/// [RGB_404_BG].
const String RGB_404 = '5;164';

/// Palette parameters for colour-cube red 4, green 0, blue 5 (colour index
/// 165).
///
/// About #D700FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_405_FG],
/// [RGB_405_BG].
const String RGB_405 = '5;165';

/// Palette parameters for colour-cube red 4, green 1, blue 0 (colour index
/// 166).
///
/// About #D75F00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_410_FG],
/// [RGB_410_BG].
const String RGB_410 = '5;166';

/// Palette parameters for colour-cube red 4, green 1, blue 1 (colour index
/// 167).
///
/// About #D75F5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_411_FG],
/// [RGB_411_BG].
const String RGB_411 = '5;167';

/// Palette parameters for colour-cube red 4, green 1, blue 2 (colour index
/// 168).
///
/// About #D75F87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_412_FG],
/// [RGB_412_BG].
const String RGB_412 = '5;168';

/// Palette parameters for colour-cube red 4, green 1, blue 3 (colour index
/// 169).
///
/// About #D75FAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_413_FG],
/// [RGB_413_BG].
const String RGB_413 = '5;169';

/// Palette parameters for colour-cube red 4, green 1, blue 4 (colour index
/// 170).
///
/// About #D75FD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_414_FG],
/// [RGB_414_BG].
const String RGB_414 = '5;170';

/// Palette parameters for colour-cube red 4, green 1, blue 5 (colour index
/// 171).
///
/// About #D75FFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_415_FG],
/// [RGB_415_BG].
const String RGB_415 = '5;171';

/// Palette parameters for colour-cube red 4, green 2, blue 0 (colour index
/// 172).
///
/// About #D78700. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_420_FG],
/// [RGB_420_BG].
const String RGB_420 = '5;172';

/// Palette parameters for colour-cube red 4, green 2, blue 1 (colour index
/// 173).
///
/// About #D7875F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_421_FG],
/// [RGB_421_BG].
const String RGB_421 = '5;173';

/// Palette parameters for colour-cube red 4, green 2, blue 2 (colour index
/// 174).
///
/// About #D78787. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_422_FG],
/// [RGB_422_BG].
const String RGB_422 = '5;174';

/// Palette parameters for colour-cube red 4, green 2, blue 3 (colour index
/// 175).
///
/// About #D787AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_423_FG],
/// [RGB_423_BG].
const String RGB_423 = '5;175';

/// Palette parameters for colour-cube red 4, green 2, blue 4 (colour index
/// 176).
///
/// About #D787D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_424_FG],
/// [RGB_424_BG].
const String RGB_424 = '5;176';

/// Palette parameters for colour-cube red 4, green 2, blue 5 (colour index
/// 177).
///
/// About #D787FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_425_FG],
/// [RGB_425_BG].
const String RGB_425 = '5;177';

/// Palette parameters for colour-cube red 4, green 3, blue 0 (colour index
/// 178).
///
/// About #D7AF00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_430_FG],
/// [RGB_430_BG].
const String RGB_430 = '5;178';

/// Palette parameters for colour-cube red 4, green 3, blue 1 (colour index
/// 179).
///
/// About #D7AF5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_431_FG],
/// [RGB_431_BG].
const String RGB_431 = '5;179';

/// Palette parameters for colour-cube red 4, green 3, blue 2 (colour index
/// 180).
///
/// About #D7AF87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_432_FG],
/// [RGB_432_BG].
const String RGB_432 = '5;180';

/// Palette parameters for colour-cube red 4, green 3, blue 3 (colour index
/// 181).
///
/// About #D7AFAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_433_FG],
/// [RGB_433_BG].
const String RGB_433 = '5;181';

/// Palette parameters for colour-cube red 4, green 3, blue 4 (colour index
/// 182).
///
/// About #D7AFD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_434_FG],
/// [RGB_434_BG].
const String RGB_434 = '5;182';

/// Palette parameters for colour-cube red 4, green 3, blue 5 (colour index
/// 183).
///
/// About #D7AFFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_435_FG],
/// [RGB_435_BG].
const String RGB_435 = '5;183';

/// Palette parameters for colour-cube red 4, green 4, blue 0 (colour index
/// 184).
///
/// About #D7D700. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_440_FG],
/// [RGB_440_BG].
const String RGB_440 = '5;184';

/// Palette parameters for colour-cube red 4, green 4, blue 1 (colour index
/// 185).
///
/// About #D7D75F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_441_FG],
/// [RGB_441_BG].
const String RGB_441 = '5;185';

/// Palette parameters for colour-cube red 4, green 4, blue 2 (colour index
/// 186).
///
/// About #D7D787. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_442_FG],
/// [RGB_442_BG].
const String RGB_442 = '5;186';

/// Palette parameters for colour-cube red 4, green 4, blue 3 (colour index
/// 187).
///
/// About #D7D7AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_443_FG],
/// [RGB_443_BG].
const String RGB_443 = '5;187';

/// Palette parameters for colour-cube red 4, green 4, blue 4 (colour index
/// 188).
///
/// About #D7D7D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_444_FG],
/// [RGB_444_BG].
const String RGB_444 = '5;188';

/// Palette parameters for colour-cube red 4, green 4, blue 5 (colour index
/// 189).
///
/// About #D7D7FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_445_FG],
/// [RGB_445_BG].
const String RGB_445 = '5;189';

/// Palette parameters for colour-cube red 4, green 5, blue 0 (colour index
/// 190).
///
/// About #D7FF00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_450_FG],
/// [RGB_450_BG].
const String RGB_450 = '5;190';

/// Palette parameters for colour-cube red 4, green 5, blue 1 (colour index
/// 191).
///
/// About #D7FF5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_451_FG],
/// [RGB_451_BG].
const String RGB_451 = '5;191';

/// Palette parameters for colour-cube red 4, green 5, blue 2 (colour index
/// 192).
///
/// About #D7FF87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_452_FG],
/// [RGB_452_BG].
const String RGB_452 = '5;192';

/// Palette parameters for colour-cube red 4, green 5, blue 3 (colour index
/// 193).
///
/// About #D7FFAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_453_FG],
/// [RGB_453_BG].
const String RGB_453 = '5;193';

/// Palette parameters for colour-cube red 4, green 5, blue 4 (colour index
/// 194).
///
/// About #D7FFD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_454_FG],
/// [RGB_454_BG].
const String RGB_454 = '5;194';

/// Palette parameters for colour-cube red 4, green 5, blue 5 (colour index
/// 195).
///
/// About #D7FFFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_455_FG],
/// [RGB_455_BG].
const String RGB_455 = '5;195';

/// Palette parameters for colour-cube red 5, green 0, blue 0 (colour index
/// 196).
///
/// About #FF0000. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_500_FG],
/// [RGB_500_BG].
const String RGB_500 = '5;196';

/// Palette parameters for colour-cube red 5, green 0, blue 1 (colour index
/// 197).
///
/// About #FF005F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_501_FG],
/// [RGB_501_BG].
const String RGB_501 = '5;197';

/// Palette parameters for colour-cube red 5, green 0, blue 2 (colour index
/// 198).
///
/// About #FF0087. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_502_FG],
/// [RGB_502_BG].
const String RGB_502 = '5;198';

/// Palette parameters for colour-cube red 5, green 0, blue 3 (colour index
/// 199).
///
/// About #FF00AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_503_FG],
/// [RGB_503_BG].
const String RGB_503 = '5;199';

/// Palette parameters for colour-cube red 5, green 0, blue 4 (colour index
/// 200).
///
/// About #FF00D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_504_FG],
/// [RGB_504_BG].
const String RGB_504 = '5;200';

/// Palette parameters for colour-cube red 5, green 0, blue 5 (colour index
/// 201).
///
/// About #FF00FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_505_FG],
/// [RGB_505_BG].
const String RGB_505 = '5;201';

/// Palette parameters for colour-cube red 5, green 1, blue 0 (colour index
/// 202).
///
/// About #FF5F00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_510_FG],
/// [RGB_510_BG].
const String RGB_510 = '5;202';

/// Palette parameters for colour-cube red 5, green 1, blue 1 (colour index
/// 203).
///
/// About #FF5F5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_511_FG],
/// [RGB_511_BG].
const String RGB_511 = '5;203';

/// Palette parameters for colour-cube red 5, green 1, blue 2 (colour index
/// 204).
///
/// About #FF5F87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_512_FG],
/// [RGB_512_BG].
const String RGB_512 = '5;204';

/// Palette parameters for colour-cube red 5, green 1, blue 3 (colour index
/// 205).
///
/// About #FF5FAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_513_FG],
/// [RGB_513_BG].
const String RGB_513 = '5;205';

/// Palette parameters for colour-cube red 5, green 1, blue 4 (colour index
/// 206).
///
/// About #FF5FD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_514_FG],
/// [RGB_514_BG].
const String RGB_514 = '5;206';

/// Palette parameters for colour-cube red 5, green 1, blue 5 (colour index
/// 207).
///
/// About #FF5FFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_515_FG],
/// [RGB_515_BG].
const String RGB_515 = '5;207';

/// Palette parameters for colour-cube red 5, green 2, blue 0 (colour index
/// 208).
///
/// About #FF8700. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_520_FG],
/// [RGB_520_BG].
const String RGB_520 = '5;208';

/// Palette parameters for colour-cube red 5, green 2, blue 1 (colour index
/// 209).
///
/// About #FF875F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_521_FG],
/// [RGB_521_BG].
const String RGB_521 = '5;209';

/// Palette parameters for colour-cube red 5, green 2, blue 2 (colour index
/// 210).
///
/// About #FF8787. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_522_FG],
/// [RGB_522_BG].
const String RGB_522 = '5;210';

/// Palette parameters for colour-cube red 5, green 2, blue 3 (colour index
/// 211).
///
/// About #FF87AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_523_FG],
/// [RGB_523_BG].
const String RGB_523 = '5;211';

/// Palette parameters for colour-cube red 5, green 2, blue 4 (colour index
/// 212).
///
/// About #FF87D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_524_FG],
/// [RGB_524_BG].
const String RGB_524 = '5;212';

/// Palette parameters for colour-cube red 5, green 2, blue 5 (colour index
/// 213).
///
/// About #FF87FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_525_FG],
/// [RGB_525_BG].
const String RGB_525 = '5;213';

/// Palette parameters for colour-cube red 5, green 3, blue 0 (colour index
/// 214).
///
/// About #FFAF00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_530_FG],
/// [RGB_530_BG].
const String RGB_530 = '5;214';

/// Palette parameters for colour-cube red 5, green 3, blue 1 (colour index
/// 215).
///
/// About #FFAF5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_531_FG],
/// [RGB_531_BG].
const String RGB_531 = '5;215';

/// Palette parameters for colour-cube red 5, green 3, blue 2 (colour index
/// 216).
///
/// About #FFAF87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_532_FG],
/// [RGB_532_BG].
const String RGB_532 = '5;216';

/// Palette parameters for colour-cube red 5, green 3, blue 3 (colour index
/// 217).
///
/// About #FFAFAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_533_FG],
/// [RGB_533_BG].
const String RGB_533 = '5;217';

/// Palette parameters for colour-cube red 5, green 3, blue 4 (colour index
/// 218).
///
/// About #FFAFD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_534_FG],
/// [RGB_534_BG].
const String RGB_534 = '5;218';

/// Palette parameters for colour-cube red 5, green 3, blue 5 (colour index
/// 219).
///
/// About #FFAFFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_535_FG],
/// [RGB_535_BG].
const String RGB_535 = '5;219';

/// Palette parameters for colour-cube red 5, green 4, blue 0 (colour index
/// 220).
///
/// About #FFD700. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_540_FG],
/// [RGB_540_BG].
const String RGB_540 = '5;220';

/// Palette parameters for colour-cube red 5, green 4, blue 1 (colour index
/// 221).
///
/// About #FFD75F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_541_FG],
/// [RGB_541_BG].
const String RGB_541 = '5;221';

/// Palette parameters for colour-cube red 5, green 4, blue 2 (colour index
/// 222).
///
/// About #FFD787. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_542_FG],
/// [RGB_542_BG].
const String RGB_542 = '5;222';

/// Palette parameters for colour-cube red 5, green 4, blue 3 (colour index
/// 223).
///
/// About #FFD7AF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_543_FG],
/// [RGB_543_BG].
const String RGB_543 = '5;223';

/// Palette parameters for colour-cube red 5, green 4, blue 4 (colour index
/// 224).
///
/// About #FFD7D7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_544_FG],
/// [RGB_544_BG].
const String RGB_544 = '5;224';

/// Palette parameters for colour-cube red 5, green 4, blue 5 (colour index
/// 225).
///
/// About #FFD7FF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_545_FG],
/// [RGB_545_BG].
const String RGB_545 = '5;225';

/// Palette parameters for colour-cube red 5, green 5, blue 0 (colour index
/// 226).
///
/// About #FFFF00. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_550_FG],
/// [RGB_550_BG].
const String RGB_550 = '5;226';

/// Palette parameters for colour-cube red 5, green 5, blue 1 (colour index
/// 227).
///
/// About #FFFF5F. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_551_FG],
/// [RGB_551_BG].
const String RGB_551 = '5;227';

/// Palette parameters for colour-cube red 5, green 5, blue 2 (colour index
/// 228).
///
/// About #FFFF87. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_552_FG],
/// [RGB_552_BG].
const String RGB_552 = '5;228';

/// Palette parameters for colour-cube red 5, green 5, blue 3 (colour index
/// 229).
///
/// About #FFFFAF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_553_FG],
/// [RGB_553_BG].
const String RGB_553 = '5;229';

/// Palette parameters for colour-cube red 5, green 5, blue 4 (colour index
/// 230).
///
/// About #FFFFD7. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_554_FG],
/// [RGB_554_BG].
const String RGB_554 = '5;230';

/// Palette parameters for colour-cube red 5, green 5, blue 5 (colour index
/// 231).
///
/// About #FFFFFF. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [RGB_555_FG],
/// [RGB_555_BG].
const String RGB_555 = '5;231';

/// Palette parameters for grey step 0 of 23 (colour index 232).
///
/// About #080808. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_0_FG], [GREY_0_BG].
const String GREY_0 = '5;232';

/// Palette parameters for grey step 1 of 23 (colour index 233).
///
/// About #121212. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_1_FG], [GREY_1_BG].
const String GREY_1 = '5;233';

/// Palette parameters for grey step 2 of 23 (colour index 234).
///
/// About #1C1C1C. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_2_FG], [GREY_2_BG].
const String GREY_2 = '5;234';

/// Palette parameters for grey step 3 of 23 (colour index 235).
///
/// About #262626. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_3_FG], [GREY_3_BG].
const String GREY_3 = '5;235';

/// Palette parameters for grey step 4 of 23 (colour index 236).
///
/// About #303030. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_4_FG], [GREY_4_BG].
const String GREY_4 = '5;236';

/// Palette parameters for grey step 5 of 23 (colour index 237).
///
/// About #3A3A3A. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_5_FG], [GREY_5_BG].
const String GREY_5 = '5;237';

/// Palette parameters for grey step 6 of 23 (colour index 238).
///
/// About #444444. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_6_FG], [GREY_6_BG].
const String GREY_6 = '5;238';

/// Palette parameters for grey step 7 of 23 (colour index 239).
///
/// About #4E4E4E. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_7_FG], [GREY_7_BG].
const String GREY_7 = '5;239';

/// Palette parameters for grey step 8 of 23 (colour index 240).
///
/// About #585858. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_8_FG], [GREY_8_BG].
const String GREY_8 = '5;240';

/// Palette parameters for grey step 9 of 23 (colour index 241).
///
/// About #626262. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_9_FG], [GREY_9_BG].
const String GREY_9 = '5;241';

/// Palette parameters for grey step 10 of 23 (colour index 242).
///
/// About #6C6C6C. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_10_FG],
/// [GREY_10_BG].
const String GREY_10 = '5;242';

/// Palette parameters for grey step 11 of 23 (colour index 243).
///
/// About #767676. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_11_FG],
/// [GREY_11_BG].
const String GREY_11 = '5;243';

/// Palette parameters for grey step 12 of 23 (colour index 244).
///
/// About #808080. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_12_FG],
/// [GREY_12_BG].
const String GREY_12 = '5;244';

/// Palette parameters for grey step 13 of 23 (colour index 245).
///
/// About #8A8A8A. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_13_FG],
/// [GREY_13_BG].
const String GREY_13 = '5;245';

/// Palette parameters for grey step 14 of 23 (colour index 246).
///
/// About #949494. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_14_FG],
/// [GREY_14_BG].
const String GREY_14 = '5;246';

/// Palette parameters for grey step 15 of 23 (colour index 247).
///
/// About #9E9E9E. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_15_FG],
/// [GREY_15_BG].
const String GREY_15 = '5;247';

/// Palette parameters for grey step 16 of 23 (colour index 248).
///
/// About #A8A8A8. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_16_FG],
/// [GREY_16_BG].
const String GREY_16 = '5;248';

/// Palette parameters for grey step 17 of 23 (colour index 249).
///
/// About #B2B2B2. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_17_FG],
/// [GREY_17_BG].
const String GREY_17 = '5;249';

/// Palette parameters for grey step 18 of 23 (colour index 250).
///
/// About #BCBCBC. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_18_FG],
/// [GREY_18_BG].
const String GREY_18 = '5;250';

/// Palette parameters for grey step 19 of 23 (colour index 251).
///
/// About #C6C6C6. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_19_FG],
/// [GREY_19_BG].
const String GREY_19 = '5;251';

/// Palette parameters for grey step 20 of 23 (colour index 252).
///
/// About #D0D0D0. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_20_FG],
/// [GREY_20_BG].
const String GREY_20 = '5;252';

/// Palette parameters for grey step 21 of 23 (colour index 253).
///
/// About #DADADA. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_21_FG],
/// [GREY_21_BG].
const String GREY_21 = '5;253';

/// Palette parameters for grey step 22 of 23 (colour index 254).
///
/// About #E4E4E4. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_22_FG],
/// [GREY_22_BG].
const String GREY_22 = '5;254';

/// Palette parameters for grey step 23 of 23 (colour index 255).
///
/// About #EEEEEE. Goes after `38;` (text), `48;` (background) or `58;`
/// (underline) in an SGR sequence. Ready-made codes: [GREY_23_FG],
/// [GREY_23_BG].
const String GREY_23 = '5;255';

/// Sets the text colour to standard black.
///
/// Colour index 0 from [BLACK]. Usually about #000000, but the terminal theme
/// decides. Undo it with [RESET_FG] or [RESET].
const String BLACK_FG = '${CSI}38;$BLACK$SGR';

/// Sets the text colour to standard red.
///
/// Colour index 1 from [RED]. Usually about #CD0000, but the terminal theme
/// decides. Undo it with [RESET_FG] or [RESET].
const String RED_FG = '${CSI}38;$RED$SGR';

/// Sets the text colour to standard green.
///
/// Colour index 2 from [GREEN]. Usually about #00CD00, but the terminal theme
/// decides. Undo it with [RESET_FG] or [RESET].
const String GREEN_FG = '${CSI}38;$GREEN$SGR';

/// Sets the text colour to standard yellow.
///
/// Colour index 3 from [YELLOW]. Usually about #CDCD00, but the terminal theme
/// decides. Undo it with [RESET_FG] or [RESET].
const String YELLOW_FG = '${CSI}38;$YELLOW$SGR';

/// Sets the text colour to standard blue.
///
/// Colour index 4 from [BLUE]. Usually about #0000EE, but the terminal theme
/// decides. Undo it with [RESET_FG] or [RESET].
const String BLUE_FG = '${CSI}38;$BLUE$SGR';

/// Sets the text colour to standard magenta.
///
/// Colour index 5 from [MAGENTA]. Usually about #CD00CD, but the terminal theme
/// decides. Undo it with [RESET_FG] or [RESET].
const String MAGENTA_FG = '${CSI}38;$MAGENTA$SGR';

/// Sets the text colour to standard cyan.
///
/// Colour index 6 from [CYAN]. Usually about #00CDCD, but the terminal theme
/// decides. Undo it with [RESET_FG] or [RESET].
const String CYAN_FG = '${CSI}38;$CYAN$SGR';

/// Sets the text colour to standard white.
///
/// Colour index 7 from [WHITE]. Usually about #E5E5E5, but the terminal theme
/// decides. Undo it with [RESET_FG] or [RESET].
const String WHITE_FG = '${CSI}38;$WHITE$SGR';

/// Sets the text colour to bright black.
///
/// Colour index 8 from [HIGH_BLACK]. Usually about #7F7F7F, but the terminal
/// theme decides. Undo it with [RESET_FG] or [RESET].
const String HIGH_BLACK_FG = '${CSI}38;$HIGH_BLACK$SGR';

/// Sets the text colour to bright red.
///
/// Colour index 9 from [HIGH_RED]. Usually about #FF0000, but the terminal
/// theme decides. Undo it with [RESET_FG] or [RESET].
const String HIGH_RED_FG = '${CSI}38;$HIGH_RED$SGR';

/// Sets the text colour to bright green.
///
/// Colour index 10 from [HIGH_GREEN]. Usually about #00FF00, but the terminal
/// theme decides. Undo it with [RESET_FG] or [RESET].
const String HIGH_GREEN_FG = '${CSI}38;$HIGH_GREEN$SGR';

/// Sets the text colour to bright yellow.
///
/// Colour index 11 from [HIGH_YELLOW]. Usually about #FFFF00, but the terminal
/// theme decides. Undo it with [RESET_FG] or [RESET].
const String HIGH_YELLOW_FG = '${CSI}38;$HIGH_YELLOW$SGR';

/// Sets the text colour to bright blue.
///
/// Colour index 12 from [HIGH_BLUE]. Usually about #5C5CFF, but the terminal
/// theme decides. Undo it with [RESET_FG] or [RESET].
const String HIGH_BLUE_FG = '${CSI}38;$HIGH_BLUE$SGR';

/// Sets the text colour to bright magenta.
///
/// Colour index 13 from [HIGH_MAGENTA]. Usually about #FF00FF, but the terminal
/// theme decides. Undo it with [RESET_FG] or [RESET].
const String HIGH_MAGENTA_FG = '${CSI}38;$HIGH_MAGENTA$SGR';

/// Sets the text colour to bright cyan.
///
/// Colour index 14 from [HIGH_CYAN]. Usually about #00FFFF, but the terminal
/// theme decides. Undo it with [RESET_FG] or [RESET].
const String HIGH_CYAN_FG = '${CSI}38;$HIGH_CYAN$SGR';

/// Sets the text colour to bright white.
///
/// Colour index 15 from [HIGH_WHITE]. Usually about #FFFFFF, but the terminal
/// theme decides. Undo it with [RESET_FG] or [RESET].
const String HIGH_WHITE_FG = '${CSI}38;$HIGH_WHITE$SGR';

/// Sets the text colour to colour-cube red 0, green 0, blue 0.
///
/// Colour index 16 from [RGB_000]. About #000000. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_000_FG = '${CSI}38;$RGB_000$SGR';

/// Sets the text colour to colour-cube red 0, green 0, blue 1.
///
/// Colour index 17 from [RGB_001]. About #00005F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_001_FG = '${CSI}38;$RGB_001$SGR';

/// Sets the text colour to colour-cube red 0, green 0, blue 2.
///
/// Colour index 18 from [RGB_002]. About #000087. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_002_FG = '${CSI}38;$RGB_002$SGR';

/// Sets the text colour to colour-cube red 0, green 0, blue 3.
///
/// Colour index 19 from [RGB_003]. About #0000AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_003_FG = '${CSI}38;$RGB_003$SGR';

/// Sets the text colour to colour-cube red 0, green 0, blue 4.
///
/// Colour index 20 from [RGB_004]. About #0000D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_004_FG = '${CSI}38;$RGB_004$SGR';

/// Sets the text colour to colour-cube red 0, green 0, blue 5.
///
/// Colour index 21 from [RGB_005]. About #0000FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_005_FG = '${CSI}38;$RGB_005$SGR';

/// Sets the text colour to colour-cube red 0, green 1, blue 0.
///
/// Colour index 22 from [RGB_010]. About #005F00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_010_FG = '${CSI}38;$RGB_010$SGR';

/// Sets the text colour to colour-cube red 0, green 1, blue 1.
///
/// Colour index 23 from [RGB_011]. About #005F5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_011_FG = '${CSI}38;$RGB_011$SGR';

/// Sets the text colour to colour-cube red 0, green 1, blue 2.
///
/// Colour index 24 from [RGB_012]. About #005F87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_012_FG = '${CSI}38;$RGB_012$SGR';

/// Sets the text colour to colour-cube red 0, green 1, blue 3.
///
/// Colour index 25 from [RGB_013]. About #005FAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_013_FG = '${CSI}38;$RGB_013$SGR';

/// Sets the text colour to colour-cube red 0, green 1, blue 4.
///
/// Colour index 26 from [RGB_014]. About #005FD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_014_FG = '${CSI}38;$RGB_014$SGR';

/// Sets the text colour to colour-cube red 0, green 1, blue 5.
///
/// Colour index 27 from [RGB_015]. About #005FFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_015_FG = '${CSI}38;$RGB_015$SGR';

/// Sets the text colour to colour-cube red 0, green 2, blue 0.
///
/// Colour index 28 from [RGB_020]. About #008700. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_020_FG = '${CSI}38;$RGB_020$SGR';

/// Sets the text colour to colour-cube red 0, green 2, blue 1.
///
/// Colour index 29 from [RGB_021]. About #00875F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_021_FG = '${CSI}38;$RGB_021$SGR';

/// Sets the text colour to colour-cube red 0, green 2, blue 2.
///
/// Colour index 30 from [RGB_022]. About #008787. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_022_FG = '${CSI}38;$RGB_022$SGR';

/// Sets the text colour to colour-cube red 0, green 2, blue 3.
///
/// Colour index 31 from [RGB_023]. About #0087AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_023_FG = '${CSI}38;$RGB_023$SGR';

/// Sets the text colour to colour-cube red 0, green 2, blue 4.
///
/// Colour index 32 from [RGB_024]. About #0087D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_024_FG = '${CSI}38;$RGB_024$SGR';

/// Sets the text colour to colour-cube red 0, green 2, blue 5.
///
/// Colour index 33 from [RGB_025]. About #0087FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_025_FG = '${CSI}38;$RGB_025$SGR';

/// Sets the text colour to colour-cube red 0, green 3, blue 0.
///
/// Colour index 34 from [RGB_030]. About #00AF00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_030_FG = '${CSI}38;$RGB_030$SGR';

/// Sets the text colour to colour-cube red 0, green 3, blue 1.
///
/// Colour index 35 from [RGB_031]. About #00AF5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_031_FG = '${CSI}38;$RGB_031$SGR';

/// Sets the text colour to colour-cube red 0, green 3, blue 2.
///
/// Colour index 36 from [RGB_032]. About #00AF87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_032_FG = '${CSI}38;$RGB_032$SGR';

/// Sets the text colour to colour-cube red 0, green 3, blue 3.
///
/// Colour index 37 from [RGB_033]. About #00AFAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_033_FG = '${CSI}38;$RGB_033$SGR';

/// Sets the text colour to colour-cube red 0, green 3, blue 4.
///
/// Colour index 38 from [RGB_034]. About #00AFD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_034_FG = '${CSI}38;$RGB_034$SGR';

/// Sets the text colour to colour-cube red 0, green 3, blue 5.
///
/// Colour index 39 from [RGB_035]. About #00AFFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_035_FG = '${CSI}38;$RGB_035$SGR';

/// Sets the text colour to colour-cube red 0, green 4, blue 0.
///
/// Colour index 40 from [RGB_040]. About #00D700. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_040_FG = '${CSI}38;$RGB_040$SGR';

/// Sets the text colour to colour-cube red 0, green 4, blue 1.
///
/// Colour index 41 from [RGB_041]. About #00D75F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_041_FG = '${CSI}38;$RGB_041$SGR';

/// Sets the text colour to colour-cube red 0, green 4, blue 2.
///
/// Colour index 42 from [RGB_042]. About #00D787. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_042_FG = '${CSI}38;$RGB_042$SGR';

/// Sets the text colour to colour-cube red 0, green 4, blue 3.
///
/// Colour index 43 from [RGB_043]. About #00D7AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_043_FG = '${CSI}38;$RGB_043$SGR';

/// Sets the text colour to colour-cube red 0, green 4, blue 4.
///
/// Colour index 44 from [RGB_044]. About #00D7D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_044_FG = '${CSI}38;$RGB_044$SGR';

/// Sets the text colour to colour-cube red 0, green 4, blue 5.
///
/// Colour index 45 from [RGB_045]. About #00D7FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_045_FG = '${CSI}38;$RGB_045$SGR';

/// Sets the text colour to colour-cube red 0, green 5, blue 0.
///
/// Colour index 46 from [RGB_050]. About #00FF00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_050_FG = '${CSI}38;$RGB_050$SGR';

/// Sets the text colour to colour-cube red 0, green 5, blue 1.
///
/// Colour index 47 from [RGB_051]. About #00FF5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_051_FG = '${CSI}38;$RGB_051$SGR';

/// Sets the text colour to colour-cube red 0, green 5, blue 2.
///
/// Colour index 48 from [RGB_052]. About #00FF87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_052_FG = '${CSI}38;$RGB_052$SGR';

/// Sets the text colour to colour-cube red 0, green 5, blue 3.
///
/// Colour index 49 from [RGB_053]. About #00FFAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_053_FG = '${CSI}38;$RGB_053$SGR';

/// Sets the text colour to colour-cube red 0, green 5, blue 4.
///
/// Colour index 50 from [RGB_054]. About #00FFD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_054_FG = '${CSI}38;$RGB_054$SGR';

/// Sets the text colour to colour-cube red 0, green 5, blue 5.
///
/// Colour index 51 from [RGB_055]. About #00FFFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_055_FG = '${CSI}38;$RGB_055$SGR';

/// Sets the text colour to colour-cube red 1, green 0, blue 0.
///
/// Colour index 52 from [RGB_100]. About #5F0000. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_100_FG = '${CSI}38;$RGB_100$SGR';

/// Sets the text colour to colour-cube red 1, green 0, blue 1.
///
/// Colour index 53 from [RGB_101]. About #5F005F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_101_FG = '${CSI}38;$RGB_101$SGR';

/// Sets the text colour to colour-cube red 1, green 0, blue 2.
///
/// Colour index 54 from [RGB_102]. About #5F0087. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_102_FG = '${CSI}38;$RGB_102$SGR';

/// Sets the text colour to colour-cube red 1, green 0, blue 3.
///
/// Colour index 55 from [RGB_103]. About #5F00AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_103_FG = '${CSI}38;$RGB_103$SGR';

/// Sets the text colour to colour-cube red 1, green 0, blue 4.
///
/// Colour index 56 from [RGB_104]. About #5F00D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_104_FG = '${CSI}38;$RGB_104$SGR';

/// Sets the text colour to colour-cube red 1, green 0, blue 5.
///
/// Colour index 57 from [RGB_105]. About #5F00FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_105_FG = '${CSI}38;$RGB_105$SGR';

/// Sets the text colour to colour-cube red 1, green 1, blue 0.
///
/// Colour index 58 from [RGB_110]. About #5F5F00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_110_FG = '${CSI}38;$RGB_110$SGR';

/// Sets the text colour to colour-cube red 1, green 1, blue 1.
///
/// Colour index 59 from [RGB_111]. About #5F5F5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_111_FG = '${CSI}38;$RGB_111$SGR';

/// Sets the text colour to colour-cube red 1, green 1, blue 2.
///
/// Colour index 60 from [RGB_112]. About #5F5F87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_112_FG = '${CSI}38;$RGB_112$SGR';

/// Sets the text colour to colour-cube red 1, green 1, blue 3.
///
/// Colour index 61 from [RGB_113]. About #5F5FAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_113_FG = '${CSI}38;$RGB_113$SGR';

/// Sets the text colour to colour-cube red 1, green 1, blue 4.
///
/// Colour index 62 from [RGB_114]. About #5F5FD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_114_FG = '${CSI}38;$RGB_114$SGR';

/// Sets the text colour to colour-cube red 1, green 1, blue 5.
///
/// Colour index 63 from [RGB_115]. About #5F5FFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_115_FG = '${CSI}38;$RGB_115$SGR';

/// Sets the text colour to colour-cube red 1, green 2, blue 0.
///
/// Colour index 64 from [RGB_120]. About #5F8700. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_120_FG = '${CSI}38;$RGB_120$SGR';

/// Sets the text colour to colour-cube red 1, green 2, blue 1.
///
/// Colour index 65 from [RGB_121]. About #5F875F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_121_FG = '${CSI}38;$RGB_121$SGR';

/// Sets the text colour to colour-cube red 1, green 2, blue 2.
///
/// Colour index 66 from [RGB_122]. About #5F8787. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_122_FG = '${CSI}38;$RGB_122$SGR';

/// Sets the text colour to colour-cube red 1, green 2, blue 3.
///
/// Colour index 67 from [RGB_123]. About #5F87AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_123_FG = '${CSI}38;$RGB_123$SGR';

/// Sets the text colour to colour-cube red 1, green 2, blue 4.
///
/// Colour index 68 from [RGB_124]. About #5F87D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_124_FG = '${CSI}38;$RGB_124$SGR';

/// Sets the text colour to colour-cube red 1, green 2, blue 5.
///
/// Colour index 69 from [RGB_125]. About #5F87FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_125_FG = '${CSI}38;$RGB_125$SGR';

/// Sets the text colour to colour-cube red 1, green 3, blue 0.
///
/// Colour index 70 from [RGB_130]. About #5FAF00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_130_FG = '${CSI}38;$RGB_130$SGR';

/// Sets the text colour to colour-cube red 1, green 3, blue 1.
///
/// Colour index 71 from [RGB_131]. About #5FAF5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_131_FG = '${CSI}38;$RGB_131$SGR';

/// Sets the text colour to colour-cube red 1, green 3, blue 2.
///
/// Colour index 72 from [RGB_132]. About #5FAF87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_132_FG = '${CSI}38;$RGB_132$SGR';

/// Sets the text colour to colour-cube red 1, green 3, blue 3.
///
/// Colour index 73 from [RGB_133]. About #5FAFAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_133_FG = '${CSI}38;$RGB_133$SGR';

/// Sets the text colour to colour-cube red 1, green 3, blue 4.
///
/// Colour index 74 from [RGB_134]. About #5FAFD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_134_FG = '${CSI}38;$RGB_134$SGR';

/// Sets the text colour to colour-cube red 1, green 3, blue 5.
///
/// Colour index 75 from [RGB_135]. About #5FAFFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_135_FG = '${CSI}38;$RGB_135$SGR';

/// Sets the text colour to colour-cube red 1, green 4, blue 0.
///
/// Colour index 76 from [RGB_140]. About #5FD700. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_140_FG = '${CSI}38;$RGB_140$SGR';

/// Sets the text colour to colour-cube red 1, green 4, blue 1.
///
/// Colour index 77 from [RGB_141]. About #5FD75F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_141_FG = '${CSI}38;$RGB_141$SGR';

/// Sets the text colour to colour-cube red 1, green 4, blue 2.
///
/// Colour index 78 from [RGB_142]. About #5FD787. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_142_FG = '${CSI}38;$RGB_142$SGR';

/// Sets the text colour to colour-cube red 1, green 4, blue 3.
///
/// Colour index 79 from [RGB_143]. About #5FD7AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_143_FG = '${CSI}38;$RGB_143$SGR';

/// Sets the text colour to colour-cube red 1, green 4, blue 4.
///
/// Colour index 80 from [RGB_144]. About #5FD7D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_144_FG = '${CSI}38;$RGB_144$SGR';

/// Sets the text colour to colour-cube red 1, green 4, blue 5.
///
/// Colour index 81 from [RGB_145]. About #5FD7FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_145_FG = '${CSI}38;$RGB_145$SGR';

/// Sets the text colour to colour-cube red 1, green 5, blue 0.
///
/// Colour index 82 from [RGB_150]. About #5FFF00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_150_FG = '${CSI}38;$RGB_150$SGR';

/// Sets the text colour to colour-cube red 1, green 5, blue 1.
///
/// Colour index 83 from [RGB_151]. About #5FFF5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_151_FG = '${CSI}38;$RGB_151$SGR';

/// Sets the text colour to colour-cube red 1, green 5, blue 2.
///
/// Colour index 84 from [RGB_152]. About #5FFF87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_152_FG = '${CSI}38;$RGB_152$SGR';

/// Sets the text colour to colour-cube red 1, green 5, blue 3.
///
/// Colour index 85 from [RGB_153]. About #5FFFAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_153_FG = '${CSI}38;$RGB_153$SGR';

/// Sets the text colour to colour-cube red 1, green 5, blue 4.
///
/// Colour index 86 from [RGB_154]. About #5FFFD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_154_FG = '${CSI}38;$RGB_154$SGR';

/// Sets the text colour to colour-cube red 1, green 5, blue 5.
///
/// Colour index 87 from [RGB_155]. About #5FFFFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_155_FG = '${CSI}38;$RGB_155$SGR';

/// Sets the text colour to colour-cube red 2, green 0, blue 0.
///
/// Colour index 88 from [RGB_200]. About #870000. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_200_FG = '${CSI}38;$RGB_200$SGR';

/// Sets the text colour to colour-cube red 2, green 0, blue 1.
///
/// Colour index 89 from [RGB_201]. About #87005F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_201_FG = '${CSI}38;$RGB_201$SGR';

/// Sets the text colour to colour-cube red 2, green 0, blue 2.
///
/// Colour index 90 from [RGB_202]. About #870087. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_202_FG = '${CSI}38;$RGB_202$SGR';

/// Sets the text colour to colour-cube red 2, green 0, blue 3.
///
/// Colour index 91 from [RGB_203]. About #8700AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_203_FG = '${CSI}38;$RGB_203$SGR';

/// Sets the text colour to colour-cube red 2, green 0, blue 4.
///
/// Colour index 92 from [RGB_204]. About #8700D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_204_FG = '${CSI}38;$RGB_204$SGR';

/// Sets the text colour to colour-cube red 2, green 0, blue 5.
///
/// Colour index 93 from [RGB_205]. About #8700FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_205_FG = '${CSI}38;$RGB_205$SGR';

/// Sets the text colour to colour-cube red 2, green 1, blue 0.
///
/// Colour index 94 from [RGB_210]. About #875F00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_210_FG = '${CSI}38;$RGB_210$SGR';

/// Sets the text colour to colour-cube red 2, green 1, blue 1.
///
/// Colour index 95 from [RGB_211]. About #875F5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_211_FG = '${CSI}38;$RGB_211$SGR';

/// Sets the text colour to colour-cube red 2, green 1, blue 2.
///
/// Colour index 96 from [RGB_212]. About #875F87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_212_FG = '${CSI}38;$RGB_212$SGR';

/// Sets the text colour to colour-cube red 2, green 1, blue 3.
///
/// Colour index 97 from [RGB_213]. About #875FAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_213_FG = '${CSI}38;$RGB_213$SGR';

/// Sets the text colour to colour-cube red 2, green 1, blue 4.
///
/// Colour index 98 from [RGB_214]. About #875FD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_214_FG = '${CSI}38;$RGB_214$SGR';

/// Sets the text colour to colour-cube red 2, green 1, blue 5.
///
/// Colour index 99 from [RGB_215]. About #875FFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_215_FG = '${CSI}38;$RGB_215$SGR';

/// Sets the text colour to colour-cube red 2, green 2, blue 0.
///
/// Colour index 100 from [RGB_220]. About #878700. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_220_FG = '${CSI}38;$RGB_220$SGR';

/// Sets the text colour to colour-cube red 2, green 2, blue 1.
///
/// Colour index 101 from [RGB_221]. About #87875F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_221_FG = '${CSI}38;$RGB_221$SGR';

/// Sets the text colour to colour-cube red 2, green 2, blue 2.
///
/// Colour index 102 from [RGB_222]. About #878787. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_222_FG = '${CSI}38;$RGB_222$SGR';

/// Sets the text colour to colour-cube red 2, green 2, blue 3.
///
/// Colour index 103 from [RGB_223]. About #8787AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_223_FG = '${CSI}38;$RGB_223$SGR';

/// Sets the text colour to colour-cube red 2, green 2, blue 4.
///
/// Colour index 104 from [RGB_224]. About #8787D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_224_FG = '${CSI}38;$RGB_224$SGR';

/// Sets the text colour to colour-cube red 2, green 2, blue 5.
///
/// Colour index 105 from [RGB_225]. About #8787FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_225_FG = '${CSI}38;$RGB_225$SGR';

/// Sets the text colour to colour-cube red 2, green 3, blue 0.
///
/// Colour index 106 from [RGB_230]. About #87AF00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_230_FG = '${CSI}38;$RGB_230$SGR';

/// Sets the text colour to colour-cube red 2, green 3, blue 1.
///
/// Colour index 107 from [RGB_231]. About #87AF5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_231_FG = '${CSI}38;$RGB_231$SGR';

/// Sets the text colour to colour-cube red 2, green 3, blue 2.
///
/// Colour index 108 from [RGB_232]. About #87AF87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_232_FG = '${CSI}38;$RGB_232$SGR';

/// Sets the text colour to colour-cube red 2, green 3, blue 3.
///
/// Colour index 109 from [RGB_233]. About #87AFAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_233_FG = '${CSI}38;$RGB_233$SGR';

/// Sets the text colour to colour-cube red 2, green 3, blue 4.
///
/// Colour index 110 from [RGB_234]. About #87AFD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_234_FG = '${CSI}38;$RGB_234$SGR';

/// Sets the text colour to colour-cube red 2, green 3, blue 5.
///
/// Colour index 111 from [RGB_235]. About #87AFFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_235_FG = '${CSI}38;$RGB_235$SGR';

/// Sets the text colour to colour-cube red 2, green 4, blue 0.
///
/// Colour index 112 from [RGB_240]. About #87D700. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_240_FG = '${CSI}38;$RGB_240$SGR';

/// Sets the text colour to colour-cube red 2, green 4, blue 1.
///
/// Colour index 113 from [RGB_241]. About #87D75F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_241_FG = '${CSI}38;$RGB_241$SGR';

/// Sets the text colour to colour-cube red 2, green 4, blue 2.
///
/// Colour index 114 from [RGB_242]. About #87D787. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_242_FG = '${CSI}38;$RGB_242$SGR';

/// Sets the text colour to colour-cube red 2, green 4, blue 3.
///
/// Colour index 115 from [RGB_243]. About #87D7AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_243_FG = '${CSI}38;$RGB_243$SGR';

/// Sets the text colour to colour-cube red 2, green 4, blue 4.
///
/// Colour index 116 from [RGB_244]. About #87D7D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_244_FG = '${CSI}38;$RGB_244$SGR';

/// Sets the text colour to colour-cube red 2, green 4, blue 5.
///
/// Colour index 117 from [RGB_245]. About #87D7FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_245_FG = '${CSI}38;$RGB_245$SGR';

/// Sets the text colour to colour-cube red 2, green 5, blue 0.
///
/// Colour index 118 from [RGB_250]. About #87FF00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_250_FG = '${CSI}38;$RGB_250$SGR';

/// Sets the text colour to colour-cube red 2, green 5, blue 1.
///
/// Colour index 119 from [RGB_251]. About #87FF5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_251_FG = '${CSI}38;$RGB_251$SGR';

/// Sets the text colour to colour-cube red 2, green 5, blue 2.
///
/// Colour index 120 from [RGB_252]. About #87FF87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_252_FG = '${CSI}38;$RGB_252$SGR';

/// Sets the text colour to colour-cube red 2, green 5, blue 3.
///
/// Colour index 121 from [RGB_253]. About #87FFAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_253_FG = '${CSI}38;$RGB_253$SGR';

/// Sets the text colour to colour-cube red 2, green 5, blue 4.
///
/// Colour index 122 from [RGB_254]. About #87FFD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_254_FG = '${CSI}38;$RGB_254$SGR';

/// Sets the text colour to colour-cube red 2, green 5, blue 5.
///
/// Colour index 123 from [RGB_255]. About #87FFFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_255_FG = '${CSI}38;$RGB_255$SGR';

/// Sets the text colour to colour-cube red 3, green 0, blue 0.
///
/// Colour index 124 from [RGB_300]. About #AF0000. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_300_FG = '${CSI}38;$RGB_300$SGR';

/// Sets the text colour to colour-cube red 3, green 0, blue 1.
///
/// Colour index 125 from [RGB_301]. About #AF005F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_301_FG = '${CSI}38;$RGB_301$SGR';

/// Sets the text colour to colour-cube red 3, green 0, blue 2.
///
/// Colour index 126 from [RGB_302]. About #AF0087. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_302_FG = '${CSI}38;$RGB_302$SGR';

/// Sets the text colour to colour-cube red 3, green 0, blue 3.
///
/// Colour index 127 from [RGB_303]. About #AF00AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_303_FG = '${CSI}38;$RGB_303$SGR';

/// Sets the text colour to colour-cube red 3, green 0, blue 4.
///
/// Colour index 128 from [RGB_304]. About #AF00D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_304_FG = '${CSI}38;$RGB_304$SGR';

/// Sets the text colour to colour-cube red 3, green 0, blue 5.
///
/// Colour index 129 from [RGB_305]. About #AF00FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_305_FG = '${CSI}38;$RGB_305$SGR';

/// Sets the text colour to colour-cube red 3, green 1, blue 0.
///
/// Colour index 130 from [RGB_310]. About #AF5F00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_310_FG = '${CSI}38;$RGB_310$SGR';

/// Sets the text colour to colour-cube red 3, green 1, blue 1.
///
/// Colour index 131 from [RGB_311]. About #AF5F5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_311_FG = '${CSI}38;$RGB_311$SGR';

/// Sets the text colour to colour-cube red 3, green 1, blue 2.
///
/// Colour index 132 from [RGB_312]. About #AF5F87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_312_FG = '${CSI}38;$RGB_312$SGR';

/// Sets the text colour to colour-cube red 3, green 1, blue 3.
///
/// Colour index 133 from [RGB_313]. About #AF5FAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_313_FG = '${CSI}38;$RGB_313$SGR';

/// Sets the text colour to colour-cube red 3, green 1, blue 4.
///
/// Colour index 134 from [RGB_314]. About #AF5FD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_314_FG = '${CSI}38;$RGB_314$SGR';

/// Sets the text colour to colour-cube red 3, green 1, blue 5.
///
/// Colour index 135 from [RGB_315]. About #AF5FFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_315_FG = '${CSI}38;$RGB_315$SGR';

/// Sets the text colour to colour-cube red 3, green 2, blue 0.
///
/// Colour index 136 from [RGB_320]. About #AF8700. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_320_FG = '${CSI}38;$RGB_320$SGR';

/// Sets the text colour to colour-cube red 3, green 2, blue 1.
///
/// Colour index 137 from [RGB_321]. About #AF875F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_321_FG = '${CSI}38;$RGB_321$SGR';

/// Sets the text colour to colour-cube red 3, green 2, blue 2.
///
/// Colour index 138 from [RGB_322]. About #AF8787. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_322_FG = '${CSI}38;$RGB_322$SGR';

/// Sets the text colour to colour-cube red 3, green 2, blue 3.
///
/// Colour index 139 from [RGB_323]. About #AF87AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_323_FG = '${CSI}38;$RGB_323$SGR';

/// Sets the text colour to colour-cube red 3, green 2, blue 4.
///
/// Colour index 140 from [RGB_324]. About #AF87D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_324_FG = '${CSI}38;$RGB_324$SGR';

/// Sets the text colour to colour-cube red 3, green 2, blue 5.
///
/// Colour index 141 from [RGB_325]. About #AF87FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_325_FG = '${CSI}38;$RGB_325$SGR';

/// Sets the text colour to colour-cube red 3, green 3, blue 0.
///
/// Colour index 142 from [RGB_330]. About #AFAF00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_330_FG = '${CSI}38;$RGB_330$SGR';

/// Sets the text colour to colour-cube red 3, green 3, blue 1.
///
/// Colour index 143 from [RGB_331]. About #AFAF5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_331_FG = '${CSI}38;$RGB_331$SGR';

/// Sets the text colour to colour-cube red 3, green 3, blue 2.
///
/// Colour index 144 from [RGB_332]. About #AFAF87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_332_FG = '${CSI}38;$RGB_332$SGR';

/// Sets the text colour to colour-cube red 3, green 3, blue 3.
///
/// Colour index 145 from [RGB_333]. About #AFAFAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_333_FG = '${CSI}38;$RGB_333$SGR';

/// Sets the text colour to colour-cube red 3, green 3, blue 4.
///
/// Colour index 146 from [RGB_334]. About #AFAFD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_334_FG = '${CSI}38;$RGB_334$SGR';

/// Sets the text colour to colour-cube red 3, green 3, blue 5.
///
/// Colour index 147 from [RGB_335]. About #AFAFFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_335_FG = '${CSI}38;$RGB_335$SGR';

/// Sets the text colour to colour-cube red 3, green 4, blue 0.
///
/// Colour index 148 from [RGB_340]. About #AFD700. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_340_FG = '${CSI}38;$RGB_340$SGR';

/// Sets the text colour to colour-cube red 3, green 4, blue 1.
///
/// Colour index 149 from [RGB_341]. About #AFD75F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_341_FG = '${CSI}38;$RGB_341$SGR';

/// Sets the text colour to colour-cube red 3, green 4, blue 2.
///
/// Colour index 150 from [RGB_342]. About #AFD787. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_342_FG = '${CSI}38;$RGB_342$SGR';

/// Sets the text colour to colour-cube red 3, green 4, blue 3.
///
/// Colour index 151 from [RGB_343]. About #AFD7AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_343_FG = '${CSI}38;$RGB_343$SGR';

/// Sets the text colour to colour-cube red 3, green 4, blue 4.
///
/// Colour index 152 from [RGB_344]. About #AFD7D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_344_FG = '${CSI}38;$RGB_344$SGR';

/// Sets the text colour to colour-cube red 3, green 4, blue 5.
///
/// Colour index 153 from [RGB_345]. About #AFD7FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_345_FG = '${CSI}38;$RGB_345$SGR';

/// Sets the text colour to colour-cube red 3, green 5, blue 0.
///
/// Colour index 154 from [RGB_350]. About #AFFF00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_350_FG = '${CSI}38;$RGB_350$SGR';

/// Sets the text colour to colour-cube red 3, green 5, blue 1.
///
/// Colour index 155 from [RGB_351]. About #AFFF5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_351_FG = '${CSI}38;$RGB_351$SGR';

/// Sets the text colour to colour-cube red 3, green 5, blue 2.
///
/// Colour index 156 from [RGB_352]. About #AFFF87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_352_FG = '${CSI}38;$RGB_352$SGR';

/// Sets the text colour to colour-cube red 3, green 5, blue 3.
///
/// Colour index 157 from [RGB_353]. About #AFFFAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_353_FG = '${CSI}38;$RGB_353$SGR';

/// Sets the text colour to colour-cube red 3, green 5, blue 4.
///
/// Colour index 158 from [RGB_354]. About #AFFFD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_354_FG = '${CSI}38;$RGB_354$SGR';

/// Sets the text colour to colour-cube red 3, green 5, blue 5.
///
/// Colour index 159 from [RGB_355]. About #AFFFFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_355_FG = '${CSI}38;$RGB_355$SGR';

/// Sets the text colour to colour-cube red 4, green 0, blue 0.
///
/// Colour index 160 from [RGB_400]. About #D70000. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_400_FG = '${CSI}38;$RGB_400$SGR';

/// Sets the text colour to colour-cube red 4, green 0, blue 1.
///
/// Colour index 161 from [RGB_401]. About #D7005F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_401_FG = '${CSI}38;$RGB_401$SGR';

/// Sets the text colour to colour-cube red 4, green 0, blue 2.
///
/// Colour index 162 from [RGB_402]. About #D70087. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_402_FG = '${CSI}38;$RGB_402$SGR';

/// Sets the text colour to colour-cube red 4, green 0, blue 3.
///
/// Colour index 163 from [RGB_403]. About #D700AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_403_FG = '${CSI}38;$RGB_403$SGR';

/// Sets the text colour to colour-cube red 4, green 0, blue 4.
///
/// Colour index 164 from [RGB_404]. About #D700D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_404_FG = '${CSI}38;$RGB_404$SGR';

/// Sets the text colour to colour-cube red 4, green 0, blue 5.
///
/// Colour index 165 from [RGB_405]. About #D700FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_405_FG = '${CSI}38;$RGB_405$SGR';

/// Sets the text colour to colour-cube red 4, green 1, blue 0.
///
/// Colour index 166 from [RGB_410]. About #D75F00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_410_FG = '${CSI}38;$RGB_410$SGR';

/// Sets the text colour to colour-cube red 4, green 1, blue 1.
///
/// Colour index 167 from [RGB_411]. About #D75F5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_411_FG = '${CSI}38;$RGB_411$SGR';

/// Sets the text colour to colour-cube red 4, green 1, blue 2.
///
/// Colour index 168 from [RGB_412]. About #D75F87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_412_FG = '${CSI}38;$RGB_412$SGR';

/// Sets the text colour to colour-cube red 4, green 1, blue 3.
///
/// Colour index 169 from [RGB_413]. About #D75FAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_413_FG = '${CSI}38;$RGB_413$SGR';

/// Sets the text colour to colour-cube red 4, green 1, blue 4.
///
/// Colour index 170 from [RGB_414]. About #D75FD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_414_FG = '${CSI}38;$RGB_414$SGR';

/// Sets the text colour to colour-cube red 4, green 1, blue 5.
///
/// Colour index 171 from [RGB_415]. About #D75FFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_415_FG = '${CSI}38;$RGB_415$SGR';

/// Sets the text colour to colour-cube red 4, green 2, blue 0.
///
/// Colour index 172 from [RGB_420]. About #D78700. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_420_FG = '${CSI}38;$RGB_420$SGR';

/// Sets the text colour to colour-cube red 4, green 2, blue 1.
///
/// Colour index 173 from [RGB_421]. About #D7875F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_421_FG = '${CSI}38;$RGB_421$SGR';

/// Sets the text colour to colour-cube red 4, green 2, blue 2.
///
/// Colour index 174 from [RGB_422]. About #D78787. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_422_FG = '${CSI}38;$RGB_422$SGR';

/// Sets the text colour to colour-cube red 4, green 2, blue 3.
///
/// Colour index 175 from [RGB_423]. About #D787AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_423_FG = '${CSI}38;$RGB_423$SGR';

/// Sets the text colour to colour-cube red 4, green 2, blue 4.
///
/// Colour index 176 from [RGB_424]. About #D787D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_424_FG = '${CSI}38;$RGB_424$SGR';

/// Sets the text colour to colour-cube red 4, green 2, blue 5.
///
/// Colour index 177 from [RGB_425]. About #D787FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_425_FG = '${CSI}38;$RGB_425$SGR';

/// Sets the text colour to colour-cube red 4, green 3, blue 0.
///
/// Colour index 178 from [RGB_430]. About #D7AF00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_430_FG = '${CSI}38;$RGB_430$SGR';

/// Sets the text colour to colour-cube red 4, green 3, blue 1.
///
/// Colour index 179 from [RGB_431]. About #D7AF5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_431_FG = '${CSI}38;$RGB_431$SGR';

/// Sets the text colour to colour-cube red 4, green 3, blue 2.
///
/// Colour index 180 from [RGB_432]. About #D7AF87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_432_FG = '${CSI}38;$RGB_432$SGR';

/// Sets the text colour to colour-cube red 4, green 3, blue 3.
///
/// Colour index 181 from [RGB_433]. About #D7AFAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_433_FG = '${CSI}38;$RGB_433$SGR';

/// Sets the text colour to colour-cube red 4, green 3, blue 4.
///
/// Colour index 182 from [RGB_434]. About #D7AFD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_434_FG = '${CSI}38;$RGB_434$SGR';

/// Sets the text colour to colour-cube red 4, green 3, blue 5.
///
/// Colour index 183 from [RGB_435]. About #D7AFFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_435_FG = '${CSI}38;$RGB_435$SGR';

/// Sets the text colour to colour-cube red 4, green 4, blue 0.
///
/// Colour index 184 from [RGB_440]. About #D7D700. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_440_FG = '${CSI}38;$RGB_440$SGR';

/// Sets the text colour to colour-cube red 4, green 4, blue 1.
///
/// Colour index 185 from [RGB_441]. About #D7D75F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_441_FG = '${CSI}38;$RGB_441$SGR';

/// Sets the text colour to colour-cube red 4, green 4, blue 2.
///
/// Colour index 186 from [RGB_442]. About #D7D787. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_442_FG = '${CSI}38;$RGB_442$SGR';

/// Sets the text colour to colour-cube red 4, green 4, blue 3.
///
/// Colour index 187 from [RGB_443]. About #D7D7AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_443_FG = '${CSI}38;$RGB_443$SGR';

/// Sets the text colour to colour-cube red 4, green 4, blue 4.
///
/// Colour index 188 from [RGB_444]. About #D7D7D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_444_FG = '${CSI}38;$RGB_444$SGR';

/// Sets the text colour to colour-cube red 4, green 4, blue 5.
///
/// Colour index 189 from [RGB_445]. About #D7D7FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_445_FG = '${CSI}38;$RGB_445$SGR';

/// Sets the text colour to colour-cube red 4, green 5, blue 0.
///
/// Colour index 190 from [RGB_450]. About #D7FF00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_450_FG = '${CSI}38;$RGB_450$SGR';

/// Sets the text colour to colour-cube red 4, green 5, blue 1.
///
/// Colour index 191 from [RGB_451]. About #D7FF5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_451_FG = '${CSI}38;$RGB_451$SGR';

/// Sets the text colour to colour-cube red 4, green 5, blue 2.
///
/// Colour index 192 from [RGB_452]. About #D7FF87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_452_FG = '${CSI}38;$RGB_452$SGR';

/// Sets the text colour to colour-cube red 4, green 5, blue 3.
///
/// Colour index 193 from [RGB_453]. About #D7FFAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_453_FG = '${CSI}38;$RGB_453$SGR';

/// Sets the text colour to colour-cube red 4, green 5, blue 4.
///
/// Colour index 194 from [RGB_454]. About #D7FFD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_454_FG = '${CSI}38;$RGB_454$SGR';

/// Sets the text colour to colour-cube red 4, green 5, blue 5.
///
/// Colour index 195 from [RGB_455]. About #D7FFFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_455_FG = '${CSI}38;$RGB_455$SGR';

/// Sets the text colour to colour-cube red 5, green 0, blue 0.
///
/// Colour index 196 from [RGB_500]. About #FF0000. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_500_FG = '${CSI}38;$RGB_500$SGR';

/// Sets the text colour to colour-cube red 5, green 0, blue 1.
///
/// Colour index 197 from [RGB_501]. About #FF005F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_501_FG = '${CSI}38;$RGB_501$SGR';

/// Sets the text colour to colour-cube red 5, green 0, blue 2.
///
/// Colour index 198 from [RGB_502]. About #FF0087. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_502_FG = '${CSI}38;$RGB_502$SGR';

/// Sets the text colour to colour-cube red 5, green 0, blue 3.
///
/// Colour index 199 from [RGB_503]. About #FF00AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_503_FG = '${CSI}38;$RGB_503$SGR';

/// Sets the text colour to colour-cube red 5, green 0, blue 4.
///
/// Colour index 200 from [RGB_504]. About #FF00D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_504_FG = '${CSI}38;$RGB_504$SGR';

/// Sets the text colour to colour-cube red 5, green 0, blue 5.
///
/// Colour index 201 from [RGB_505]. About #FF00FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_505_FG = '${CSI}38;$RGB_505$SGR';

/// Sets the text colour to colour-cube red 5, green 1, blue 0.
///
/// Colour index 202 from [RGB_510]. About #FF5F00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_510_FG = '${CSI}38;$RGB_510$SGR';

/// Sets the text colour to colour-cube red 5, green 1, blue 1.
///
/// Colour index 203 from [RGB_511]. About #FF5F5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_511_FG = '${CSI}38;$RGB_511$SGR';

/// Sets the text colour to colour-cube red 5, green 1, blue 2.
///
/// Colour index 204 from [RGB_512]. About #FF5F87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_512_FG = '${CSI}38;$RGB_512$SGR';

/// Sets the text colour to colour-cube red 5, green 1, blue 3.
///
/// Colour index 205 from [RGB_513]. About #FF5FAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_513_FG = '${CSI}38;$RGB_513$SGR';

/// Sets the text colour to colour-cube red 5, green 1, blue 4.
///
/// Colour index 206 from [RGB_514]. About #FF5FD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_514_FG = '${CSI}38;$RGB_514$SGR';

/// Sets the text colour to colour-cube red 5, green 1, blue 5.
///
/// Colour index 207 from [RGB_515]. About #FF5FFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_515_FG = '${CSI}38;$RGB_515$SGR';

/// Sets the text colour to colour-cube red 5, green 2, blue 0.
///
/// Colour index 208 from [RGB_520]. About #FF8700. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_520_FG = '${CSI}38;$RGB_520$SGR';

/// Sets the text colour to colour-cube red 5, green 2, blue 1.
///
/// Colour index 209 from [RGB_521]. About #FF875F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_521_FG = '${CSI}38;$RGB_521$SGR';

/// Sets the text colour to colour-cube red 5, green 2, blue 2.
///
/// Colour index 210 from [RGB_522]. About #FF8787. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_522_FG = '${CSI}38;$RGB_522$SGR';

/// Sets the text colour to colour-cube red 5, green 2, blue 3.
///
/// Colour index 211 from [RGB_523]. About #FF87AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_523_FG = '${CSI}38;$RGB_523$SGR';

/// Sets the text colour to colour-cube red 5, green 2, blue 4.
///
/// Colour index 212 from [RGB_524]. About #FF87D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_524_FG = '${CSI}38;$RGB_524$SGR';

/// Sets the text colour to colour-cube red 5, green 2, blue 5.
///
/// Colour index 213 from [RGB_525]. About #FF87FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_525_FG = '${CSI}38;$RGB_525$SGR';

/// Sets the text colour to colour-cube red 5, green 3, blue 0.
///
/// Colour index 214 from [RGB_530]. About #FFAF00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_530_FG = '${CSI}38;$RGB_530$SGR';

/// Sets the text colour to colour-cube red 5, green 3, blue 1.
///
/// Colour index 215 from [RGB_531]. About #FFAF5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_531_FG = '${CSI}38;$RGB_531$SGR';

/// Sets the text colour to colour-cube red 5, green 3, blue 2.
///
/// Colour index 216 from [RGB_532]. About #FFAF87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_532_FG = '${CSI}38;$RGB_532$SGR';

/// Sets the text colour to colour-cube red 5, green 3, blue 3.
///
/// Colour index 217 from [RGB_533]. About #FFAFAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_533_FG = '${CSI}38;$RGB_533$SGR';

/// Sets the text colour to colour-cube red 5, green 3, blue 4.
///
/// Colour index 218 from [RGB_534]. About #FFAFD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_534_FG = '${CSI}38;$RGB_534$SGR';

/// Sets the text colour to colour-cube red 5, green 3, blue 5.
///
/// Colour index 219 from [RGB_535]. About #FFAFFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_535_FG = '${CSI}38;$RGB_535$SGR';

/// Sets the text colour to colour-cube red 5, green 4, blue 0.
///
/// Colour index 220 from [RGB_540]. About #FFD700. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_540_FG = '${CSI}38;$RGB_540$SGR';

/// Sets the text colour to colour-cube red 5, green 4, blue 1.
///
/// Colour index 221 from [RGB_541]. About #FFD75F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_541_FG = '${CSI}38;$RGB_541$SGR';

/// Sets the text colour to colour-cube red 5, green 4, blue 2.
///
/// Colour index 222 from [RGB_542]. About #FFD787. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_542_FG = '${CSI}38;$RGB_542$SGR';

/// Sets the text colour to colour-cube red 5, green 4, blue 3.
///
/// Colour index 223 from [RGB_543]. About #FFD7AF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_543_FG = '${CSI}38;$RGB_543$SGR';

/// Sets the text colour to colour-cube red 5, green 4, blue 4.
///
/// Colour index 224 from [RGB_544]. About #FFD7D7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_544_FG = '${CSI}38;$RGB_544$SGR';

/// Sets the text colour to colour-cube red 5, green 4, blue 5.
///
/// Colour index 225 from [RGB_545]. About #FFD7FF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_545_FG = '${CSI}38;$RGB_545$SGR';

/// Sets the text colour to colour-cube red 5, green 5, blue 0.
///
/// Colour index 226 from [RGB_550]. About #FFFF00. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_550_FG = '${CSI}38;$RGB_550$SGR';

/// Sets the text colour to colour-cube red 5, green 5, blue 1.
///
/// Colour index 227 from [RGB_551]. About #FFFF5F. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_551_FG = '${CSI}38;$RGB_551$SGR';

/// Sets the text colour to colour-cube red 5, green 5, blue 2.
///
/// Colour index 228 from [RGB_552]. About #FFFF87. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_552_FG = '${CSI}38;$RGB_552$SGR';

/// Sets the text colour to colour-cube red 5, green 5, blue 3.
///
/// Colour index 229 from [RGB_553]. About #FFFFAF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_553_FG = '${CSI}38;$RGB_553$SGR';

/// Sets the text colour to colour-cube red 5, green 5, blue 4.
///
/// Colour index 230 from [RGB_554]. About #FFFFD7. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_554_FG = '${CSI}38;$RGB_554$SGR';

/// Sets the text colour to colour-cube red 5, green 5, blue 5.
///
/// Colour index 231 from [RGB_555]. About #FFFFFF. Undo it with [RESET_FG] or
/// [RESET].
const String RGB_555_FG = '${CSI}38;$RGB_555$SGR';

/// Sets the text colour to grey step 0 of 23.
///
/// Colour index 232 from [GREY_0]. About #080808. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_0_FG = '${CSI}38;$GREY_0$SGR';

/// Sets the text colour to grey step 1 of 23.
///
/// Colour index 233 from [GREY_1]. About #121212. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_1_FG = '${CSI}38;$GREY_1$SGR';

/// Sets the text colour to grey step 2 of 23.
///
/// Colour index 234 from [GREY_2]. About #1C1C1C. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_2_FG = '${CSI}38;$GREY_2$SGR';

/// Sets the text colour to grey step 3 of 23.
///
/// Colour index 235 from [GREY_3]. About #262626. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_3_FG = '${CSI}38;$GREY_3$SGR';

/// Sets the text colour to grey step 4 of 23.
///
/// Colour index 236 from [GREY_4]. About #303030. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_4_FG = '${CSI}38;$GREY_4$SGR';

/// Sets the text colour to grey step 5 of 23.
///
/// Colour index 237 from [GREY_5]. About #3A3A3A. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_5_FG = '${CSI}38;$GREY_5$SGR';

/// Sets the text colour to grey step 6 of 23.
///
/// Colour index 238 from [GREY_6]. About #444444. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_6_FG = '${CSI}38;$GREY_6$SGR';

/// Sets the text colour to grey step 7 of 23.
///
/// Colour index 239 from [GREY_7]. About #4E4E4E. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_7_FG = '${CSI}38;$GREY_7$SGR';

/// Sets the text colour to grey step 8 of 23.
///
/// Colour index 240 from [GREY_8]. About #585858. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_8_FG = '${CSI}38;$GREY_8$SGR';

/// Sets the text colour to grey step 9 of 23.
///
/// Colour index 241 from [GREY_9]. About #626262. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_9_FG = '${CSI}38;$GREY_9$SGR';

/// Sets the text colour to grey step 10 of 23.
///
/// Colour index 242 from [GREY_10]. About #6C6C6C. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_10_FG = '${CSI}38;$GREY_10$SGR';

/// Sets the text colour to grey step 11 of 23.
///
/// Colour index 243 from [GREY_11]. About #767676. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_11_FG = '${CSI}38;$GREY_11$SGR';

/// Sets the text colour to grey step 12 of 23.
///
/// Colour index 244 from [GREY_12]. About #808080. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_12_FG = '${CSI}38;$GREY_12$SGR';

/// Sets the text colour to grey step 13 of 23.
///
/// Colour index 245 from [GREY_13]. About #8A8A8A. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_13_FG = '${CSI}38;$GREY_13$SGR';

/// Sets the text colour to grey step 14 of 23.
///
/// Colour index 246 from [GREY_14]. About #949494. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_14_FG = '${CSI}38;$GREY_14$SGR';

/// Sets the text colour to grey step 15 of 23.
///
/// Colour index 247 from [GREY_15]. About #9E9E9E. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_15_FG = '${CSI}38;$GREY_15$SGR';

/// Sets the text colour to grey step 16 of 23.
///
/// Colour index 248 from [GREY_16]. About #A8A8A8. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_16_FG = '${CSI}38;$GREY_16$SGR';

/// Sets the text colour to grey step 17 of 23.
///
/// Colour index 249 from [GREY_17]. About #B2B2B2. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_17_FG = '${CSI}38;$GREY_17$SGR';

/// Sets the text colour to grey step 18 of 23.
///
/// Colour index 250 from [GREY_18]. About #BCBCBC. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_18_FG = '${CSI}38;$GREY_18$SGR';

/// Sets the text colour to grey step 19 of 23.
///
/// Colour index 251 from [GREY_19]. About #C6C6C6. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_19_FG = '${CSI}38;$GREY_19$SGR';

/// Sets the text colour to grey step 20 of 23.
///
/// Colour index 252 from [GREY_20]. About #D0D0D0. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_20_FG = '${CSI}38;$GREY_20$SGR';

/// Sets the text colour to grey step 21 of 23.
///
/// Colour index 253 from [GREY_21]. About #DADADA. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_21_FG = '${CSI}38;$GREY_21$SGR';

/// Sets the text colour to grey step 22 of 23.
///
/// Colour index 254 from [GREY_22]. About #E4E4E4. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_22_FG = '${CSI}38;$GREY_22$SGR';

/// Sets the text colour to grey step 23 of 23.
///
/// Colour index 255 from [GREY_23]. About #EEEEEE. Undo it with [RESET_FG] or
/// [RESET].
const String GREY_23_FG = '${CSI}38;$GREY_23$SGR';

/// Sets the background colour to standard black.
///
/// Colour index 0 from [BLACK]. Usually about #000000, but the terminal theme
/// decides. Undo it with [RESET_BG] or [RESET].
const String BLACK_BG = '${CSI}48;$BLACK$SGR';

/// Sets the background colour to standard red.
///
/// Colour index 1 from [RED]. Usually about #CD0000, but the terminal theme
/// decides. Undo it with [RESET_BG] or [RESET].
const String RED_BG = '${CSI}48;$RED$SGR';

/// Sets the background colour to standard green.
///
/// Colour index 2 from [GREEN]. Usually about #00CD00, but the terminal theme
/// decides. Undo it with [RESET_BG] or [RESET].
const String GREEN_BG = '${CSI}48;$GREEN$SGR';

/// Sets the background colour to standard yellow.
///
/// Colour index 3 from [YELLOW]. Usually about #CDCD00, but the terminal theme
/// decides. Undo it with [RESET_BG] or [RESET].
const String YELLOW_BG = '${CSI}48;$YELLOW$SGR';

/// Sets the background colour to standard blue.
///
/// Colour index 4 from [BLUE]. Usually about #0000EE, but the terminal theme
/// decides. Undo it with [RESET_BG] or [RESET].
const String BLUE_BG = '${CSI}48;$BLUE$SGR';

/// Sets the background colour to standard magenta.
///
/// Colour index 5 from [MAGENTA]. Usually about #CD00CD, but the terminal theme
/// decides. Undo it with [RESET_BG] or [RESET].
const String MAGENTA_BG = '${CSI}48;$MAGENTA$SGR';

/// Sets the background colour to standard cyan.
///
/// Colour index 6 from [CYAN]. Usually about #00CDCD, but the terminal theme
/// decides. Undo it with [RESET_BG] or [RESET].
const String CYAN_BG = '${CSI}48;$CYAN$SGR';

/// Sets the background colour to standard white.
///
/// Colour index 7 from [WHITE]. Usually about #E5E5E5, but the terminal theme
/// decides. Undo it with [RESET_BG] or [RESET].
const String WHITE_BG = '${CSI}48;$WHITE$SGR';

/// Sets the background colour to bright black.
///
/// Colour index 8 from [HIGH_BLACK]. Usually about #7F7F7F, but the terminal
/// theme decides. Undo it with [RESET_BG] or [RESET].
const String HIGH_BLACK_BG = '${CSI}48;$HIGH_BLACK$SGR';

/// Sets the background colour to bright red.
///
/// Colour index 9 from [HIGH_RED]. Usually about #FF0000, but the terminal
/// theme decides. Undo it with [RESET_BG] or [RESET].
const String HIGH_RED_BG = '${CSI}48;$HIGH_RED$SGR';

/// Sets the background colour to bright green.
///
/// Colour index 10 from [HIGH_GREEN]. Usually about #00FF00, but the terminal
/// theme decides. Undo it with [RESET_BG] or [RESET].
const String HIGH_GREEN_BG = '${CSI}48;$HIGH_GREEN$SGR';

/// Sets the background colour to bright yellow.
///
/// Colour index 11 from [HIGH_YELLOW]. Usually about #FFFF00, but the terminal
/// theme decides. Undo it with [RESET_BG] or [RESET].
const String HIGH_YELLOW_BG = '${CSI}48;$HIGH_YELLOW$SGR';

/// Sets the background colour to bright blue.
///
/// Colour index 12 from [HIGH_BLUE]. Usually about #5C5CFF, but the terminal
/// theme decides. Undo it with [RESET_BG] or [RESET].
const String HIGH_BLUE_BG = '${CSI}48;$HIGH_BLUE$SGR';

/// Sets the background colour to bright magenta.
///
/// Colour index 13 from [HIGH_MAGENTA]. Usually about #FF00FF, but the terminal
/// theme decides. Undo it with [RESET_BG] or [RESET].
const String HIGH_MAGENTA_BG = '${CSI}48;$HIGH_MAGENTA$SGR';

/// Sets the background colour to bright cyan.
///
/// Colour index 14 from [HIGH_CYAN]. Usually about #00FFFF, but the terminal
/// theme decides. Undo it with [RESET_BG] or [RESET].
const String HIGH_CYAN_BG = '${CSI}48;$HIGH_CYAN$SGR';

/// Sets the background colour to bright white.
///
/// Colour index 15 from [HIGH_WHITE]. Usually about #FFFFFF, but the terminal
/// theme decides. Undo it with [RESET_BG] or [RESET].
const String HIGH_WHITE_BG = '${CSI}48;$HIGH_WHITE$SGR';

/// Sets the background colour to colour-cube red 0, green 0, blue 0.
///
/// Colour index 16 from [RGB_000]. About #000000. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_000_BG = '${CSI}48;$RGB_000$SGR';

/// Sets the background colour to colour-cube red 0, green 0, blue 1.
///
/// Colour index 17 from [RGB_001]. About #00005F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_001_BG = '${CSI}48;$RGB_001$SGR';

/// Sets the background colour to colour-cube red 0, green 0, blue 2.
///
/// Colour index 18 from [RGB_002]. About #000087. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_002_BG = '${CSI}48;$RGB_002$SGR';

/// Sets the background colour to colour-cube red 0, green 0, blue 3.
///
/// Colour index 19 from [RGB_003]. About #0000AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_003_BG = '${CSI}48;$RGB_003$SGR';

/// Sets the background colour to colour-cube red 0, green 0, blue 4.
///
/// Colour index 20 from [RGB_004]. About #0000D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_004_BG = '${CSI}48;$RGB_004$SGR';

/// Sets the background colour to colour-cube red 0, green 0, blue 5.
///
/// Colour index 21 from [RGB_005]. About #0000FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_005_BG = '${CSI}48;$RGB_005$SGR';

/// Sets the background colour to colour-cube red 0, green 1, blue 0.
///
/// Colour index 22 from [RGB_010]. About #005F00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_010_BG = '${CSI}48;$RGB_010$SGR';

/// Sets the background colour to colour-cube red 0, green 1, blue 1.
///
/// Colour index 23 from [RGB_011]. About #005F5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_011_BG = '${CSI}48;$RGB_011$SGR';

/// Sets the background colour to colour-cube red 0, green 1, blue 2.
///
/// Colour index 24 from [RGB_012]. About #005F87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_012_BG = '${CSI}48;$RGB_012$SGR';

/// Sets the background colour to colour-cube red 0, green 1, blue 3.
///
/// Colour index 25 from [RGB_013]. About #005FAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_013_BG = '${CSI}48;$RGB_013$SGR';

/// Sets the background colour to colour-cube red 0, green 1, blue 4.
///
/// Colour index 26 from [RGB_014]. About #005FD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_014_BG = '${CSI}48;$RGB_014$SGR';

/// Sets the background colour to colour-cube red 0, green 1, blue 5.
///
/// Colour index 27 from [RGB_015]. About #005FFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_015_BG = '${CSI}48;$RGB_015$SGR';

/// Sets the background colour to colour-cube red 0, green 2, blue 0.
///
/// Colour index 28 from [RGB_020]. About #008700. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_020_BG = '${CSI}48;$RGB_020$SGR';

/// Sets the background colour to colour-cube red 0, green 2, blue 1.
///
/// Colour index 29 from [RGB_021]. About #00875F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_021_BG = '${CSI}48;$RGB_021$SGR';

/// Sets the background colour to colour-cube red 0, green 2, blue 2.
///
/// Colour index 30 from [RGB_022]. About #008787. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_022_BG = '${CSI}48;$RGB_022$SGR';

/// Sets the background colour to colour-cube red 0, green 2, blue 3.
///
/// Colour index 31 from [RGB_023]. About #0087AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_023_BG = '${CSI}48;$RGB_023$SGR';

/// Sets the background colour to colour-cube red 0, green 2, blue 4.
///
/// Colour index 32 from [RGB_024]. About #0087D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_024_BG = '${CSI}48;$RGB_024$SGR';

/// Sets the background colour to colour-cube red 0, green 2, blue 5.
///
/// Colour index 33 from [RGB_025]. About #0087FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_025_BG = '${CSI}48;$RGB_025$SGR';

/// Sets the background colour to colour-cube red 0, green 3, blue 0.
///
/// Colour index 34 from [RGB_030]. About #00AF00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_030_BG = '${CSI}48;$RGB_030$SGR';

/// Sets the background colour to colour-cube red 0, green 3, blue 1.
///
/// Colour index 35 from [RGB_031]. About #00AF5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_031_BG = '${CSI}48;$RGB_031$SGR';

/// Sets the background colour to colour-cube red 0, green 3, blue 2.
///
/// Colour index 36 from [RGB_032]. About #00AF87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_032_BG = '${CSI}48;$RGB_032$SGR';

/// Sets the background colour to colour-cube red 0, green 3, blue 3.
///
/// Colour index 37 from [RGB_033]. About #00AFAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_033_BG = '${CSI}48;$RGB_033$SGR';

/// Sets the background colour to colour-cube red 0, green 3, blue 4.
///
/// Colour index 38 from [RGB_034]. About #00AFD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_034_BG = '${CSI}48;$RGB_034$SGR';

/// Sets the background colour to colour-cube red 0, green 3, blue 5.
///
/// Colour index 39 from [RGB_035]. About #00AFFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_035_BG = '${CSI}48;$RGB_035$SGR';

/// Sets the background colour to colour-cube red 0, green 4, blue 0.
///
/// Colour index 40 from [RGB_040]. About #00D700. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_040_BG = '${CSI}48;$RGB_040$SGR';

/// Sets the background colour to colour-cube red 0, green 4, blue 1.
///
/// Colour index 41 from [RGB_041]. About #00D75F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_041_BG = '${CSI}48;$RGB_041$SGR';

/// Sets the background colour to colour-cube red 0, green 4, blue 2.
///
/// Colour index 42 from [RGB_042]. About #00D787. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_042_BG = '${CSI}48;$RGB_042$SGR';

/// Sets the background colour to colour-cube red 0, green 4, blue 3.
///
/// Colour index 43 from [RGB_043]. About #00D7AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_043_BG = '${CSI}48;$RGB_043$SGR';

/// Sets the background colour to colour-cube red 0, green 4, blue 4.
///
/// Colour index 44 from [RGB_044]. About #00D7D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_044_BG = '${CSI}48;$RGB_044$SGR';

/// Sets the background colour to colour-cube red 0, green 4, blue 5.
///
/// Colour index 45 from [RGB_045]. About #00D7FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_045_BG = '${CSI}48;$RGB_045$SGR';

/// Sets the background colour to colour-cube red 0, green 5, blue 0.
///
/// Colour index 46 from [RGB_050]. About #00FF00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_050_BG = '${CSI}48;$RGB_050$SGR';

/// Sets the background colour to colour-cube red 0, green 5, blue 1.
///
/// Colour index 47 from [RGB_051]. About #00FF5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_051_BG = '${CSI}48;$RGB_051$SGR';

/// Sets the background colour to colour-cube red 0, green 5, blue 2.
///
/// Colour index 48 from [RGB_052]. About #00FF87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_052_BG = '${CSI}48;$RGB_052$SGR';

/// Sets the background colour to colour-cube red 0, green 5, blue 3.
///
/// Colour index 49 from [RGB_053]. About #00FFAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_053_BG = '${CSI}48;$RGB_053$SGR';

/// Sets the background colour to colour-cube red 0, green 5, blue 4.
///
/// Colour index 50 from [RGB_054]. About #00FFD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_054_BG = '${CSI}48;$RGB_054$SGR';

/// Sets the background colour to colour-cube red 0, green 5, blue 5.
///
/// Colour index 51 from [RGB_055]. About #00FFFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_055_BG = '${CSI}48;$RGB_055$SGR';

/// Sets the background colour to colour-cube red 1, green 0, blue 0.
///
/// Colour index 52 from [RGB_100]. About #5F0000. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_100_BG = '${CSI}48;$RGB_100$SGR';

/// Sets the background colour to colour-cube red 1, green 0, blue 1.
///
/// Colour index 53 from [RGB_101]. About #5F005F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_101_BG = '${CSI}48;$RGB_101$SGR';

/// Sets the background colour to colour-cube red 1, green 0, blue 2.
///
/// Colour index 54 from [RGB_102]. About #5F0087. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_102_BG = '${CSI}48;$RGB_102$SGR';

/// Sets the background colour to colour-cube red 1, green 0, blue 3.
///
/// Colour index 55 from [RGB_103]. About #5F00AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_103_BG = '${CSI}48;$RGB_103$SGR';

/// Sets the background colour to colour-cube red 1, green 0, blue 4.
///
/// Colour index 56 from [RGB_104]. About #5F00D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_104_BG = '${CSI}48;$RGB_104$SGR';

/// Sets the background colour to colour-cube red 1, green 0, blue 5.
///
/// Colour index 57 from [RGB_105]. About #5F00FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_105_BG = '${CSI}48;$RGB_105$SGR';

/// Sets the background colour to colour-cube red 1, green 1, blue 0.
///
/// Colour index 58 from [RGB_110]. About #5F5F00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_110_BG = '${CSI}48;$RGB_110$SGR';

/// Sets the background colour to colour-cube red 1, green 1, blue 1.
///
/// Colour index 59 from [RGB_111]. About #5F5F5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_111_BG = '${CSI}48;$RGB_111$SGR';

/// Sets the background colour to colour-cube red 1, green 1, blue 2.
///
/// Colour index 60 from [RGB_112]. About #5F5F87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_112_BG = '${CSI}48;$RGB_112$SGR';

/// Sets the background colour to colour-cube red 1, green 1, blue 3.
///
/// Colour index 61 from [RGB_113]. About #5F5FAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_113_BG = '${CSI}48;$RGB_113$SGR';

/// Sets the background colour to colour-cube red 1, green 1, blue 4.
///
/// Colour index 62 from [RGB_114]. About #5F5FD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_114_BG = '${CSI}48;$RGB_114$SGR';

/// Sets the background colour to colour-cube red 1, green 1, blue 5.
///
/// Colour index 63 from [RGB_115]. About #5F5FFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_115_BG = '${CSI}48;$RGB_115$SGR';

/// Sets the background colour to colour-cube red 1, green 2, blue 0.
///
/// Colour index 64 from [RGB_120]. About #5F8700. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_120_BG = '${CSI}48;$RGB_120$SGR';

/// Sets the background colour to colour-cube red 1, green 2, blue 1.
///
/// Colour index 65 from [RGB_121]. About #5F875F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_121_BG = '${CSI}48;$RGB_121$SGR';

/// Sets the background colour to colour-cube red 1, green 2, blue 2.
///
/// Colour index 66 from [RGB_122]. About #5F8787. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_122_BG = '${CSI}48;$RGB_122$SGR';

/// Sets the background colour to colour-cube red 1, green 2, blue 3.
///
/// Colour index 67 from [RGB_123]. About #5F87AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_123_BG = '${CSI}48;$RGB_123$SGR';

/// Sets the background colour to colour-cube red 1, green 2, blue 4.
///
/// Colour index 68 from [RGB_124]. About #5F87D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_124_BG = '${CSI}48;$RGB_124$SGR';

/// Sets the background colour to colour-cube red 1, green 2, blue 5.
///
/// Colour index 69 from [RGB_125]. About #5F87FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_125_BG = '${CSI}48;$RGB_125$SGR';

/// Sets the background colour to colour-cube red 1, green 3, blue 0.
///
/// Colour index 70 from [RGB_130]. About #5FAF00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_130_BG = '${CSI}48;$RGB_130$SGR';

/// Sets the background colour to colour-cube red 1, green 3, blue 1.
///
/// Colour index 71 from [RGB_131]. About #5FAF5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_131_BG = '${CSI}48;$RGB_131$SGR';

/// Sets the background colour to colour-cube red 1, green 3, blue 2.
///
/// Colour index 72 from [RGB_132]. About #5FAF87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_132_BG = '${CSI}48;$RGB_132$SGR';

/// Sets the background colour to colour-cube red 1, green 3, blue 3.
///
/// Colour index 73 from [RGB_133]. About #5FAFAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_133_BG = '${CSI}48;$RGB_133$SGR';

/// Sets the background colour to colour-cube red 1, green 3, blue 4.
///
/// Colour index 74 from [RGB_134]. About #5FAFD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_134_BG = '${CSI}48;$RGB_134$SGR';

/// Sets the background colour to colour-cube red 1, green 3, blue 5.
///
/// Colour index 75 from [RGB_135]. About #5FAFFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_135_BG = '${CSI}48;$RGB_135$SGR';

/// Sets the background colour to colour-cube red 1, green 4, blue 0.
///
/// Colour index 76 from [RGB_140]. About #5FD700. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_140_BG = '${CSI}48;$RGB_140$SGR';

/// Sets the background colour to colour-cube red 1, green 4, blue 1.
///
/// Colour index 77 from [RGB_141]. About #5FD75F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_141_BG = '${CSI}48;$RGB_141$SGR';

/// Sets the background colour to colour-cube red 1, green 4, blue 2.
///
/// Colour index 78 from [RGB_142]. About #5FD787. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_142_BG = '${CSI}48;$RGB_142$SGR';

/// Sets the background colour to colour-cube red 1, green 4, blue 3.
///
/// Colour index 79 from [RGB_143]. About #5FD7AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_143_BG = '${CSI}48;$RGB_143$SGR';

/// Sets the background colour to colour-cube red 1, green 4, blue 4.
///
/// Colour index 80 from [RGB_144]. About #5FD7D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_144_BG = '${CSI}48;$RGB_144$SGR';

/// Sets the background colour to colour-cube red 1, green 4, blue 5.
///
/// Colour index 81 from [RGB_145]. About #5FD7FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_145_BG = '${CSI}48;$RGB_145$SGR';

/// Sets the background colour to colour-cube red 1, green 5, blue 0.
///
/// Colour index 82 from [RGB_150]. About #5FFF00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_150_BG = '${CSI}48;$RGB_150$SGR';

/// Sets the background colour to colour-cube red 1, green 5, blue 1.
///
/// Colour index 83 from [RGB_151]. About #5FFF5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_151_BG = '${CSI}48;$RGB_151$SGR';

/// Sets the background colour to colour-cube red 1, green 5, blue 2.
///
/// Colour index 84 from [RGB_152]. About #5FFF87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_152_BG = '${CSI}48;$RGB_152$SGR';

/// Sets the background colour to colour-cube red 1, green 5, blue 3.
///
/// Colour index 85 from [RGB_153]. About #5FFFAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_153_BG = '${CSI}48;$RGB_153$SGR';

/// Sets the background colour to colour-cube red 1, green 5, blue 4.
///
/// Colour index 86 from [RGB_154]. About #5FFFD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_154_BG = '${CSI}48;$RGB_154$SGR';

/// Sets the background colour to colour-cube red 1, green 5, blue 5.
///
/// Colour index 87 from [RGB_155]. About #5FFFFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_155_BG = '${CSI}48;$RGB_155$SGR';

/// Sets the background colour to colour-cube red 2, green 0, blue 0.
///
/// Colour index 88 from [RGB_200]. About #870000. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_200_BG = '${CSI}48;$RGB_200$SGR';

/// Sets the background colour to colour-cube red 2, green 0, blue 1.
///
/// Colour index 89 from [RGB_201]. About #87005F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_201_BG = '${CSI}48;$RGB_201$SGR';

/// Sets the background colour to colour-cube red 2, green 0, blue 2.
///
/// Colour index 90 from [RGB_202]. About #870087. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_202_BG = '${CSI}48;$RGB_202$SGR';

/// Sets the background colour to colour-cube red 2, green 0, blue 3.
///
/// Colour index 91 from [RGB_203]. About #8700AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_203_BG = '${CSI}48;$RGB_203$SGR';

/// Sets the background colour to colour-cube red 2, green 0, blue 4.
///
/// Colour index 92 from [RGB_204]. About #8700D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_204_BG = '${CSI}48;$RGB_204$SGR';

/// Sets the background colour to colour-cube red 2, green 0, blue 5.
///
/// Colour index 93 from [RGB_205]. About #8700FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_205_BG = '${CSI}48;$RGB_205$SGR';

/// Sets the background colour to colour-cube red 2, green 1, blue 0.
///
/// Colour index 94 from [RGB_210]. About #875F00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_210_BG = '${CSI}48;$RGB_210$SGR';

/// Sets the background colour to colour-cube red 2, green 1, blue 1.
///
/// Colour index 95 from [RGB_211]. About #875F5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_211_BG = '${CSI}48;$RGB_211$SGR';

/// Sets the background colour to colour-cube red 2, green 1, blue 2.
///
/// Colour index 96 from [RGB_212]. About #875F87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_212_BG = '${CSI}48;$RGB_212$SGR';

/// Sets the background colour to colour-cube red 2, green 1, blue 3.
///
/// Colour index 97 from [RGB_213]. About #875FAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_213_BG = '${CSI}48;$RGB_213$SGR';

/// Sets the background colour to colour-cube red 2, green 1, blue 4.
///
/// Colour index 98 from [RGB_214]. About #875FD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_214_BG = '${CSI}48;$RGB_214$SGR';

/// Sets the background colour to colour-cube red 2, green 1, blue 5.
///
/// Colour index 99 from [RGB_215]. About #875FFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_215_BG = '${CSI}48;$RGB_215$SGR';

/// Sets the background colour to colour-cube red 2, green 2, blue 0.
///
/// Colour index 100 from [RGB_220]. About #878700. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_220_BG = '${CSI}48;$RGB_220$SGR';

/// Sets the background colour to colour-cube red 2, green 2, blue 1.
///
/// Colour index 101 from [RGB_221]. About #87875F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_221_BG = '${CSI}48;$RGB_221$SGR';

/// Sets the background colour to colour-cube red 2, green 2, blue 2.
///
/// Colour index 102 from [RGB_222]. About #878787. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_222_BG = '${CSI}48;$RGB_222$SGR';

/// Sets the background colour to colour-cube red 2, green 2, blue 3.
///
/// Colour index 103 from [RGB_223]. About #8787AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_223_BG = '${CSI}48;$RGB_223$SGR';

/// Sets the background colour to colour-cube red 2, green 2, blue 4.
///
/// Colour index 104 from [RGB_224]. About #8787D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_224_BG = '${CSI}48;$RGB_224$SGR';

/// Sets the background colour to colour-cube red 2, green 2, blue 5.
///
/// Colour index 105 from [RGB_225]. About #8787FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_225_BG = '${CSI}48;$RGB_225$SGR';

/// Sets the background colour to colour-cube red 2, green 3, blue 0.
///
/// Colour index 106 from [RGB_230]. About #87AF00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_230_BG = '${CSI}48;$RGB_230$SGR';

/// Sets the background colour to colour-cube red 2, green 3, blue 1.
///
/// Colour index 107 from [RGB_231]. About #87AF5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_231_BG = '${CSI}48;$RGB_231$SGR';

/// Sets the background colour to colour-cube red 2, green 3, blue 2.
///
/// Colour index 108 from [RGB_232]. About #87AF87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_232_BG = '${CSI}48;$RGB_232$SGR';

/// Sets the background colour to colour-cube red 2, green 3, blue 3.
///
/// Colour index 109 from [RGB_233]. About #87AFAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_233_BG = '${CSI}48;$RGB_233$SGR';

/// Sets the background colour to colour-cube red 2, green 3, blue 4.
///
/// Colour index 110 from [RGB_234]. About #87AFD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_234_BG = '${CSI}48;$RGB_234$SGR';

/// Sets the background colour to colour-cube red 2, green 3, blue 5.
///
/// Colour index 111 from [RGB_235]. About #87AFFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_235_BG = '${CSI}48;$RGB_235$SGR';

/// Sets the background colour to colour-cube red 2, green 4, blue 0.
///
/// Colour index 112 from [RGB_240]. About #87D700. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_240_BG = '${CSI}48;$RGB_240$SGR';

/// Sets the background colour to colour-cube red 2, green 4, blue 1.
///
/// Colour index 113 from [RGB_241]. About #87D75F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_241_BG = '${CSI}48;$RGB_241$SGR';

/// Sets the background colour to colour-cube red 2, green 4, blue 2.
///
/// Colour index 114 from [RGB_242]. About #87D787. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_242_BG = '${CSI}48;$RGB_242$SGR';

/// Sets the background colour to colour-cube red 2, green 4, blue 3.
///
/// Colour index 115 from [RGB_243]. About #87D7AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_243_BG = '${CSI}48;$RGB_243$SGR';

/// Sets the background colour to colour-cube red 2, green 4, blue 4.
///
/// Colour index 116 from [RGB_244]. About #87D7D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_244_BG = '${CSI}48;$RGB_244$SGR';

/// Sets the background colour to colour-cube red 2, green 4, blue 5.
///
/// Colour index 117 from [RGB_245]. About #87D7FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_245_BG = '${CSI}48;$RGB_245$SGR';

/// Sets the background colour to colour-cube red 2, green 5, blue 0.
///
/// Colour index 118 from [RGB_250]. About #87FF00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_250_BG = '${CSI}48;$RGB_250$SGR';

/// Sets the background colour to colour-cube red 2, green 5, blue 1.
///
/// Colour index 119 from [RGB_251]. About #87FF5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_251_BG = '${CSI}48;$RGB_251$SGR';

/// Sets the background colour to colour-cube red 2, green 5, blue 2.
///
/// Colour index 120 from [RGB_252]. About #87FF87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_252_BG = '${CSI}48;$RGB_252$SGR';

/// Sets the background colour to colour-cube red 2, green 5, blue 3.
///
/// Colour index 121 from [RGB_253]. About #87FFAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_253_BG = '${CSI}48;$RGB_253$SGR';

/// Sets the background colour to colour-cube red 2, green 5, blue 4.
///
/// Colour index 122 from [RGB_254]. About #87FFD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_254_BG = '${CSI}48;$RGB_254$SGR';

/// Sets the background colour to colour-cube red 2, green 5, blue 5.
///
/// Colour index 123 from [RGB_255]. About #87FFFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_255_BG = '${CSI}48;$RGB_255$SGR';

/// Sets the background colour to colour-cube red 3, green 0, blue 0.
///
/// Colour index 124 from [RGB_300]. About #AF0000. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_300_BG = '${CSI}48;$RGB_300$SGR';

/// Sets the background colour to colour-cube red 3, green 0, blue 1.
///
/// Colour index 125 from [RGB_301]. About #AF005F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_301_BG = '${CSI}48;$RGB_301$SGR';

/// Sets the background colour to colour-cube red 3, green 0, blue 2.
///
/// Colour index 126 from [RGB_302]. About #AF0087. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_302_BG = '${CSI}48;$RGB_302$SGR';

/// Sets the background colour to colour-cube red 3, green 0, blue 3.
///
/// Colour index 127 from [RGB_303]. About #AF00AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_303_BG = '${CSI}48;$RGB_303$SGR';

/// Sets the background colour to colour-cube red 3, green 0, blue 4.
///
/// Colour index 128 from [RGB_304]. About #AF00D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_304_BG = '${CSI}48;$RGB_304$SGR';

/// Sets the background colour to colour-cube red 3, green 0, blue 5.
///
/// Colour index 129 from [RGB_305]. About #AF00FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_305_BG = '${CSI}48;$RGB_305$SGR';

/// Sets the background colour to colour-cube red 3, green 1, blue 0.
///
/// Colour index 130 from [RGB_310]. About #AF5F00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_310_BG = '${CSI}48;$RGB_310$SGR';

/// Sets the background colour to colour-cube red 3, green 1, blue 1.
///
/// Colour index 131 from [RGB_311]. About #AF5F5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_311_BG = '${CSI}48;$RGB_311$SGR';

/// Sets the background colour to colour-cube red 3, green 1, blue 2.
///
/// Colour index 132 from [RGB_312]. About #AF5F87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_312_BG = '${CSI}48;$RGB_312$SGR';

/// Sets the background colour to colour-cube red 3, green 1, blue 3.
///
/// Colour index 133 from [RGB_313]. About #AF5FAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_313_BG = '${CSI}48;$RGB_313$SGR';

/// Sets the background colour to colour-cube red 3, green 1, blue 4.
///
/// Colour index 134 from [RGB_314]. About #AF5FD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_314_BG = '${CSI}48;$RGB_314$SGR';

/// Sets the background colour to colour-cube red 3, green 1, blue 5.
///
/// Colour index 135 from [RGB_315]. About #AF5FFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_315_BG = '${CSI}48;$RGB_315$SGR';

/// Sets the background colour to colour-cube red 3, green 2, blue 0.
///
/// Colour index 136 from [RGB_320]. About #AF8700. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_320_BG = '${CSI}48;$RGB_320$SGR';

/// Sets the background colour to colour-cube red 3, green 2, blue 1.
///
/// Colour index 137 from [RGB_321]. About #AF875F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_321_BG = '${CSI}48;$RGB_321$SGR';

/// Sets the background colour to colour-cube red 3, green 2, blue 2.
///
/// Colour index 138 from [RGB_322]. About #AF8787. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_322_BG = '${CSI}48;$RGB_322$SGR';

/// Sets the background colour to colour-cube red 3, green 2, blue 3.
///
/// Colour index 139 from [RGB_323]. About #AF87AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_323_BG = '${CSI}48;$RGB_323$SGR';

/// Sets the background colour to colour-cube red 3, green 2, blue 4.
///
/// Colour index 140 from [RGB_324]. About #AF87D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_324_BG = '${CSI}48;$RGB_324$SGR';

/// Sets the background colour to colour-cube red 3, green 2, blue 5.
///
/// Colour index 141 from [RGB_325]. About #AF87FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_325_BG = '${CSI}48;$RGB_325$SGR';

/// Sets the background colour to colour-cube red 3, green 3, blue 0.
///
/// Colour index 142 from [RGB_330]. About #AFAF00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_330_BG = '${CSI}48;$RGB_330$SGR';

/// Sets the background colour to colour-cube red 3, green 3, blue 1.
///
/// Colour index 143 from [RGB_331]. About #AFAF5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_331_BG = '${CSI}48;$RGB_331$SGR';

/// Sets the background colour to colour-cube red 3, green 3, blue 2.
///
/// Colour index 144 from [RGB_332]. About #AFAF87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_332_BG = '${CSI}48;$RGB_332$SGR';

/// Sets the background colour to colour-cube red 3, green 3, blue 3.
///
/// Colour index 145 from [RGB_333]. About #AFAFAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_333_BG = '${CSI}48;$RGB_333$SGR';

/// Sets the background colour to colour-cube red 3, green 3, blue 4.
///
/// Colour index 146 from [RGB_334]. About #AFAFD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_334_BG = '${CSI}48;$RGB_334$SGR';

/// Sets the background colour to colour-cube red 3, green 3, blue 5.
///
/// Colour index 147 from [RGB_335]. About #AFAFFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_335_BG = '${CSI}48;$RGB_335$SGR';

/// Sets the background colour to colour-cube red 3, green 4, blue 0.
///
/// Colour index 148 from [RGB_340]. About #AFD700. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_340_BG = '${CSI}48;$RGB_340$SGR';

/// Sets the background colour to colour-cube red 3, green 4, blue 1.
///
/// Colour index 149 from [RGB_341]. About #AFD75F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_341_BG = '${CSI}48;$RGB_341$SGR';

/// Sets the background colour to colour-cube red 3, green 4, blue 2.
///
/// Colour index 150 from [RGB_342]. About #AFD787. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_342_BG = '${CSI}48;$RGB_342$SGR';

/// Sets the background colour to colour-cube red 3, green 4, blue 3.
///
/// Colour index 151 from [RGB_343]. About #AFD7AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_343_BG = '${CSI}48;$RGB_343$SGR';

/// Sets the background colour to colour-cube red 3, green 4, blue 4.
///
/// Colour index 152 from [RGB_344]. About #AFD7D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_344_BG = '${CSI}48;$RGB_344$SGR';

/// Sets the background colour to colour-cube red 3, green 4, blue 5.
///
/// Colour index 153 from [RGB_345]. About #AFD7FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_345_BG = '${CSI}48;$RGB_345$SGR';

/// Sets the background colour to colour-cube red 3, green 5, blue 0.
///
/// Colour index 154 from [RGB_350]. About #AFFF00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_350_BG = '${CSI}48;$RGB_350$SGR';

/// Sets the background colour to colour-cube red 3, green 5, blue 1.
///
/// Colour index 155 from [RGB_351]. About #AFFF5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_351_BG = '${CSI}48;$RGB_351$SGR';

/// Sets the background colour to colour-cube red 3, green 5, blue 2.
///
/// Colour index 156 from [RGB_352]. About #AFFF87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_352_BG = '${CSI}48;$RGB_352$SGR';

/// Sets the background colour to colour-cube red 3, green 5, blue 3.
///
/// Colour index 157 from [RGB_353]. About #AFFFAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_353_BG = '${CSI}48;$RGB_353$SGR';

/// Sets the background colour to colour-cube red 3, green 5, blue 4.
///
/// Colour index 158 from [RGB_354]. About #AFFFD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_354_BG = '${CSI}48;$RGB_354$SGR';

/// Sets the background colour to colour-cube red 3, green 5, blue 5.
///
/// Colour index 159 from [RGB_355]. About #AFFFFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_355_BG = '${CSI}48;$RGB_355$SGR';

/// Sets the background colour to colour-cube red 4, green 0, blue 0.
///
/// Colour index 160 from [RGB_400]. About #D70000. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_400_BG = '${CSI}48;$RGB_400$SGR';

/// Sets the background colour to colour-cube red 4, green 0, blue 1.
///
/// Colour index 161 from [RGB_401]. About #D7005F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_401_BG = '${CSI}48;$RGB_401$SGR';

/// Sets the background colour to colour-cube red 4, green 0, blue 2.
///
/// Colour index 162 from [RGB_402]. About #D70087. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_402_BG = '${CSI}48;$RGB_402$SGR';

/// Sets the background colour to colour-cube red 4, green 0, blue 3.
///
/// Colour index 163 from [RGB_403]. About #D700AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_403_BG = '${CSI}48;$RGB_403$SGR';

/// Sets the background colour to colour-cube red 4, green 0, blue 4.
///
/// Colour index 164 from [RGB_404]. About #D700D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_404_BG = '${CSI}48;$RGB_404$SGR';

/// Sets the background colour to colour-cube red 4, green 0, blue 5.
///
/// Colour index 165 from [RGB_405]. About #D700FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_405_BG = '${CSI}48;$RGB_405$SGR';

/// Sets the background colour to colour-cube red 4, green 1, blue 0.
///
/// Colour index 166 from [RGB_410]. About #D75F00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_410_BG = '${CSI}48;$RGB_410$SGR';

/// Sets the background colour to colour-cube red 4, green 1, blue 1.
///
/// Colour index 167 from [RGB_411]. About #D75F5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_411_BG = '${CSI}48;$RGB_411$SGR';

/// Sets the background colour to colour-cube red 4, green 1, blue 2.
///
/// Colour index 168 from [RGB_412]. About #D75F87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_412_BG = '${CSI}48;$RGB_412$SGR';

/// Sets the background colour to colour-cube red 4, green 1, blue 3.
///
/// Colour index 169 from [RGB_413]. About #D75FAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_413_BG = '${CSI}48;$RGB_413$SGR';

/// Sets the background colour to colour-cube red 4, green 1, blue 4.
///
/// Colour index 170 from [RGB_414]. About #D75FD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_414_BG = '${CSI}48;$RGB_414$SGR';

/// Sets the background colour to colour-cube red 4, green 1, blue 5.
///
/// Colour index 171 from [RGB_415]. About #D75FFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_415_BG = '${CSI}48;$RGB_415$SGR';

/// Sets the background colour to colour-cube red 4, green 2, blue 0.
///
/// Colour index 172 from [RGB_420]. About #D78700. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_420_BG = '${CSI}48;$RGB_420$SGR';

/// Sets the background colour to colour-cube red 4, green 2, blue 1.
///
/// Colour index 173 from [RGB_421]. About #D7875F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_421_BG = '${CSI}48;$RGB_421$SGR';

/// Sets the background colour to colour-cube red 4, green 2, blue 2.
///
/// Colour index 174 from [RGB_422]. About #D78787. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_422_BG = '${CSI}48;$RGB_422$SGR';

/// Sets the background colour to colour-cube red 4, green 2, blue 3.
///
/// Colour index 175 from [RGB_423]. About #D787AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_423_BG = '${CSI}48;$RGB_423$SGR';

/// Sets the background colour to colour-cube red 4, green 2, blue 4.
///
/// Colour index 176 from [RGB_424]. About #D787D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_424_BG = '${CSI}48;$RGB_424$SGR';

/// Sets the background colour to colour-cube red 4, green 2, blue 5.
///
/// Colour index 177 from [RGB_425]. About #D787FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_425_BG = '${CSI}48;$RGB_425$SGR';

/// Sets the background colour to colour-cube red 4, green 3, blue 0.
///
/// Colour index 178 from [RGB_430]. About #D7AF00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_430_BG = '${CSI}48;$RGB_430$SGR';

/// Sets the background colour to colour-cube red 4, green 3, blue 1.
///
/// Colour index 179 from [RGB_431]. About #D7AF5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_431_BG = '${CSI}48;$RGB_431$SGR';

/// Sets the background colour to colour-cube red 4, green 3, blue 2.
///
/// Colour index 180 from [RGB_432]. About #D7AF87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_432_BG = '${CSI}48;$RGB_432$SGR';

/// Sets the background colour to colour-cube red 4, green 3, blue 3.
///
/// Colour index 181 from [RGB_433]. About #D7AFAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_433_BG = '${CSI}48;$RGB_433$SGR';

/// Sets the background colour to colour-cube red 4, green 3, blue 4.
///
/// Colour index 182 from [RGB_434]. About #D7AFD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_434_BG = '${CSI}48;$RGB_434$SGR';

/// Sets the background colour to colour-cube red 4, green 3, blue 5.
///
/// Colour index 183 from [RGB_435]. About #D7AFFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_435_BG = '${CSI}48;$RGB_435$SGR';

/// Sets the background colour to colour-cube red 4, green 4, blue 0.
///
/// Colour index 184 from [RGB_440]. About #D7D700. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_440_BG = '${CSI}48;$RGB_440$SGR';

/// Sets the background colour to colour-cube red 4, green 4, blue 1.
///
/// Colour index 185 from [RGB_441]. About #D7D75F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_441_BG = '${CSI}48;$RGB_441$SGR';

/// Sets the background colour to colour-cube red 4, green 4, blue 2.
///
/// Colour index 186 from [RGB_442]. About #D7D787. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_442_BG = '${CSI}48;$RGB_442$SGR';

/// Sets the background colour to colour-cube red 4, green 4, blue 3.
///
/// Colour index 187 from [RGB_443]. About #D7D7AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_443_BG = '${CSI}48;$RGB_443$SGR';

/// Sets the background colour to colour-cube red 4, green 4, blue 4.
///
/// Colour index 188 from [RGB_444]. About #D7D7D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_444_BG = '${CSI}48;$RGB_444$SGR';

/// Sets the background colour to colour-cube red 4, green 4, blue 5.
///
/// Colour index 189 from [RGB_445]. About #D7D7FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_445_BG = '${CSI}48;$RGB_445$SGR';

/// Sets the background colour to colour-cube red 4, green 5, blue 0.
///
/// Colour index 190 from [RGB_450]. About #D7FF00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_450_BG = '${CSI}48;$RGB_450$SGR';

/// Sets the background colour to colour-cube red 4, green 5, blue 1.
///
/// Colour index 191 from [RGB_451]. About #D7FF5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_451_BG = '${CSI}48;$RGB_451$SGR';

/// Sets the background colour to colour-cube red 4, green 5, blue 2.
///
/// Colour index 192 from [RGB_452]. About #D7FF87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_452_BG = '${CSI}48;$RGB_452$SGR';

/// Sets the background colour to colour-cube red 4, green 5, blue 3.
///
/// Colour index 193 from [RGB_453]. About #D7FFAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_453_BG = '${CSI}48;$RGB_453$SGR';

/// Sets the background colour to colour-cube red 4, green 5, blue 4.
///
/// Colour index 194 from [RGB_454]. About #D7FFD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_454_BG = '${CSI}48;$RGB_454$SGR';

/// Sets the background colour to colour-cube red 4, green 5, blue 5.
///
/// Colour index 195 from [RGB_455]. About #D7FFFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_455_BG = '${CSI}48;$RGB_455$SGR';

/// Sets the background colour to colour-cube red 5, green 0, blue 0.
///
/// Colour index 196 from [RGB_500]. About #FF0000. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_500_BG = '${CSI}48;$RGB_500$SGR';

/// Sets the background colour to colour-cube red 5, green 0, blue 1.
///
/// Colour index 197 from [RGB_501]. About #FF005F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_501_BG = '${CSI}48;$RGB_501$SGR';

/// Sets the background colour to colour-cube red 5, green 0, blue 2.
///
/// Colour index 198 from [RGB_502]. About #FF0087. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_502_BG = '${CSI}48;$RGB_502$SGR';

/// Sets the background colour to colour-cube red 5, green 0, blue 3.
///
/// Colour index 199 from [RGB_503]. About #FF00AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_503_BG = '${CSI}48;$RGB_503$SGR';

/// Sets the background colour to colour-cube red 5, green 0, blue 4.
///
/// Colour index 200 from [RGB_504]. About #FF00D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_504_BG = '${CSI}48;$RGB_504$SGR';

/// Sets the background colour to colour-cube red 5, green 0, blue 5.
///
/// Colour index 201 from [RGB_505]. About #FF00FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_505_BG = '${CSI}48;$RGB_505$SGR';

/// Sets the background colour to colour-cube red 5, green 1, blue 0.
///
/// Colour index 202 from [RGB_510]. About #FF5F00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_510_BG = '${CSI}48;$RGB_510$SGR';

/// Sets the background colour to colour-cube red 5, green 1, blue 1.
///
/// Colour index 203 from [RGB_511]. About #FF5F5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_511_BG = '${CSI}48;$RGB_511$SGR';

/// Sets the background colour to colour-cube red 5, green 1, blue 2.
///
/// Colour index 204 from [RGB_512]. About #FF5F87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_512_BG = '${CSI}48;$RGB_512$SGR';

/// Sets the background colour to colour-cube red 5, green 1, blue 3.
///
/// Colour index 205 from [RGB_513]. About #FF5FAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_513_BG = '${CSI}48;$RGB_513$SGR';

/// Sets the background colour to colour-cube red 5, green 1, blue 4.
///
/// Colour index 206 from [RGB_514]. About #FF5FD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_514_BG = '${CSI}48;$RGB_514$SGR';

/// Sets the background colour to colour-cube red 5, green 1, blue 5.
///
/// Colour index 207 from [RGB_515]. About #FF5FFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_515_BG = '${CSI}48;$RGB_515$SGR';

/// Sets the background colour to colour-cube red 5, green 2, blue 0.
///
/// Colour index 208 from [RGB_520]. About #FF8700. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_520_BG = '${CSI}48;$RGB_520$SGR';

/// Sets the background colour to colour-cube red 5, green 2, blue 1.
///
/// Colour index 209 from [RGB_521]. About #FF875F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_521_BG = '${CSI}48;$RGB_521$SGR';

/// Sets the background colour to colour-cube red 5, green 2, blue 2.
///
/// Colour index 210 from [RGB_522]. About #FF8787. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_522_BG = '${CSI}48;$RGB_522$SGR';

/// Sets the background colour to colour-cube red 5, green 2, blue 3.
///
/// Colour index 211 from [RGB_523]. About #FF87AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_523_BG = '${CSI}48;$RGB_523$SGR';

/// Sets the background colour to colour-cube red 5, green 2, blue 4.
///
/// Colour index 212 from [RGB_524]. About #FF87D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_524_BG = '${CSI}48;$RGB_524$SGR';

/// Sets the background colour to colour-cube red 5, green 2, blue 5.
///
/// Colour index 213 from [RGB_525]. About #FF87FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_525_BG = '${CSI}48;$RGB_525$SGR';

/// Sets the background colour to colour-cube red 5, green 3, blue 0.
///
/// Colour index 214 from [RGB_530]. About #FFAF00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_530_BG = '${CSI}48;$RGB_530$SGR';

/// Sets the background colour to colour-cube red 5, green 3, blue 1.
///
/// Colour index 215 from [RGB_531]. About #FFAF5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_531_BG = '${CSI}48;$RGB_531$SGR';

/// Sets the background colour to colour-cube red 5, green 3, blue 2.
///
/// Colour index 216 from [RGB_532]. About #FFAF87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_532_BG = '${CSI}48;$RGB_532$SGR';

/// Sets the background colour to colour-cube red 5, green 3, blue 3.
///
/// Colour index 217 from [RGB_533]. About #FFAFAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_533_BG = '${CSI}48;$RGB_533$SGR';

/// Sets the background colour to colour-cube red 5, green 3, blue 4.
///
/// Colour index 218 from [RGB_534]. About #FFAFD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_534_BG = '${CSI}48;$RGB_534$SGR';

/// Sets the background colour to colour-cube red 5, green 3, blue 5.
///
/// Colour index 219 from [RGB_535]. About #FFAFFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_535_BG = '${CSI}48;$RGB_535$SGR';

/// Sets the background colour to colour-cube red 5, green 4, blue 0.
///
/// Colour index 220 from [RGB_540]. About #FFD700. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_540_BG = '${CSI}48;$RGB_540$SGR';

/// Sets the background colour to colour-cube red 5, green 4, blue 1.
///
/// Colour index 221 from [RGB_541]. About #FFD75F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_541_BG = '${CSI}48;$RGB_541$SGR';

/// Sets the background colour to colour-cube red 5, green 4, blue 2.
///
/// Colour index 222 from [RGB_542]. About #FFD787. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_542_BG = '${CSI}48;$RGB_542$SGR';

/// Sets the background colour to colour-cube red 5, green 4, blue 3.
///
/// Colour index 223 from [RGB_543]. About #FFD7AF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_543_BG = '${CSI}48;$RGB_543$SGR';

/// Sets the background colour to colour-cube red 5, green 4, blue 4.
///
/// Colour index 224 from [RGB_544]. About #FFD7D7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_544_BG = '${CSI}48;$RGB_544$SGR';

/// Sets the background colour to colour-cube red 5, green 4, blue 5.
///
/// Colour index 225 from [RGB_545]. About #FFD7FF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_545_BG = '${CSI}48;$RGB_545$SGR';

/// Sets the background colour to colour-cube red 5, green 5, blue 0.
///
/// Colour index 226 from [RGB_550]. About #FFFF00. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_550_BG = '${CSI}48;$RGB_550$SGR';

/// Sets the background colour to colour-cube red 5, green 5, blue 1.
///
/// Colour index 227 from [RGB_551]. About #FFFF5F. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_551_BG = '${CSI}48;$RGB_551$SGR';

/// Sets the background colour to colour-cube red 5, green 5, blue 2.
///
/// Colour index 228 from [RGB_552]. About #FFFF87. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_552_BG = '${CSI}48;$RGB_552$SGR';

/// Sets the background colour to colour-cube red 5, green 5, blue 3.
///
/// Colour index 229 from [RGB_553]. About #FFFFAF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_553_BG = '${CSI}48;$RGB_553$SGR';

/// Sets the background colour to colour-cube red 5, green 5, blue 4.
///
/// Colour index 230 from [RGB_554]. About #FFFFD7. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_554_BG = '${CSI}48;$RGB_554$SGR';

/// Sets the background colour to colour-cube red 5, green 5, blue 5.
///
/// Colour index 231 from [RGB_555]. About #FFFFFF. Undo it with [RESET_BG] or
/// [RESET].
const String RGB_555_BG = '${CSI}48;$RGB_555$SGR';

/// Sets the background colour to grey step 0 of 23.
///
/// Colour index 232 from [GREY_0]. About #080808. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_0_BG = '${CSI}48;$GREY_0$SGR';

/// Sets the background colour to grey step 1 of 23.
///
/// Colour index 233 from [GREY_1]. About #121212. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_1_BG = '${CSI}48;$GREY_1$SGR';

/// Sets the background colour to grey step 2 of 23.
///
/// Colour index 234 from [GREY_2]. About #1C1C1C. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_2_BG = '${CSI}48;$GREY_2$SGR';

/// Sets the background colour to grey step 3 of 23.
///
/// Colour index 235 from [GREY_3]. About #262626. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_3_BG = '${CSI}48;$GREY_3$SGR';

/// Sets the background colour to grey step 4 of 23.
///
/// Colour index 236 from [GREY_4]. About #303030. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_4_BG = '${CSI}48;$GREY_4$SGR';

/// Sets the background colour to grey step 5 of 23.
///
/// Colour index 237 from [GREY_5]. About #3A3A3A. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_5_BG = '${CSI}48;$GREY_5$SGR';

/// Sets the background colour to grey step 6 of 23.
///
/// Colour index 238 from [GREY_6]. About #444444. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_6_BG = '${CSI}48;$GREY_6$SGR';

/// Sets the background colour to grey step 7 of 23.
///
/// Colour index 239 from [GREY_7]. About #4E4E4E. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_7_BG = '${CSI}48;$GREY_7$SGR';

/// Sets the background colour to grey step 8 of 23.
///
/// Colour index 240 from [GREY_8]. About #585858. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_8_BG = '${CSI}48;$GREY_8$SGR';

/// Sets the background colour to grey step 9 of 23.
///
/// Colour index 241 from [GREY_9]. About #626262. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_9_BG = '${CSI}48;$GREY_9$SGR';

/// Sets the background colour to grey step 10 of 23.
///
/// Colour index 242 from [GREY_10]. About #6C6C6C. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_10_BG = '${CSI}48;$GREY_10$SGR';

/// Sets the background colour to grey step 11 of 23.
///
/// Colour index 243 from [GREY_11]. About #767676. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_11_BG = '${CSI}48;$GREY_11$SGR';

/// Sets the background colour to grey step 12 of 23.
///
/// Colour index 244 from [GREY_12]. About #808080. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_12_BG = '${CSI}48;$GREY_12$SGR';

/// Sets the background colour to grey step 13 of 23.
///
/// Colour index 245 from [GREY_13]. About #8A8A8A. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_13_BG = '${CSI}48;$GREY_13$SGR';

/// Sets the background colour to grey step 14 of 23.
///
/// Colour index 246 from [GREY_14]. About #949494. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_14_BG = '${CSI}48;$GREY_14$SGR';

/// Sets the background colour to grey step 15 of 23.
///
/// Colour index 247 from [GREY_15]. About #9E9E9E. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_15_BG = '${CSI}48;$GREY_15$SGR';

/// Sets the background colour to grey step 16 of 23.
///
/// Colour index 248 from [GREY_16]. About #A8A8A8. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_16_BG = '${CSI}48;$GREY_16$SGR';

/// Sets the background colour to grey step 17 of 23.
///
/// Colour index 249 from [GREY_17]. About #B2B2B2. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_17_BG = '${CSI}48;$GREY_17$SGR';

/// Sets the background colour to grey step 18 of 23.
///
/// Colour index 250 from [GREY_18]. About #BCBCBC. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_18_BG = '${CSI}48;$GREY_18$SGR';

/// Sets the background colour to grey step 19 of 23.
///
/// Colour index 251 from [GREY_19]. About #C6C6C6. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_19_BG = '${CSI}48;$GREY_19$SGR';

/// Sets the background colour to grey step 20 of 23.
///
/// Colour index 252 from [GREY_20]. About #D0D0D0. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_20_BG = '${CSI}48;$GREY_20$SGR';

/// Sets the background colour to grey step 21 of 23.
///
/// Colour index 253 from [GREY_21]. About #DADADA. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_21_BG = '${CSI}48;$GREY_21$SGR';

/// Sets the background colour to grey step 22 of 23.
///
/// Colour index 254 from [GREY_22]. About #E4E4E4. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_22_BG = '${CSI}48;$GREY_22$SGR';

/// Sets the background colour to grey step 23 of 23.
///
/// Colour index 255 from [GREY_23]. About #EEEEEE. Undo it with [RESET_BG] or
/// [RESET].
const String GREY_23_BG = '${CSI}48;$GREY_23$SGR';

/// Standard black as an [AsciiInk] (colour index 0).
///
/// Usually about #000000, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiBlack = AsciiColour(0);

/// Standard red as an [AsciiInk] (colour index 1).
///
/// Usually about #CD0000, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRed = AsciiColour(1);

/// Standard green as an [AsciiInk] (colour index 2).
///
/// Usually about #00CD00, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour ascii_green = AsciiColour(2);

/// Standard yellow as an [AsciiInk] (colour index 3).
///
/// Usually about #CDCD00, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiYellow = AsciiColour(3);

/// Standard blue as an [AsciiInk] (colour index 4).
///
/// Usually about #0000EE, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiBlue = AsciiColour(4);

/// Standard magenta as an [AsciiInk] (colour index 5).
///
/// Usually about #CD00CD, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiMagenta = AsciiColour(5);

/// Standard cyan as an [AsciiInk] (colour index 6).
///
/// Usually about #00CDCD, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiCyan = AsciiColour(6);

/// Standard white as an [AsciiInk] (colour index 7).
///
/// Usually about #E5E5E5, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiWhite = AsciiColour(7);

/// Bright black as an [AsciiInk] (colour index 8).
///
/// Usually about #7F7F7F, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiHighBlack = AsciiColour(8);

/// Bright red as an [AsciiInk] (colour index 9).
///
/// Usually about #FF0000, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiHighRed = AsciiColour(9);

/// Bright green as an [AsciiInk] (colour index 10).
///
/// Usually about #00FF00, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiHighGreen = AsciiColour(10);

/// Bright yellow as an [AsciiInk] (colour index 11).
///
/// Usually about #FFFF00, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiHighYellow = AsciiColour(11);

/// Bright blue as an [AsciiInk] (colour index 12).
///
/// Usually about #5C5CFF, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiHighBlue = AsciiColour(12);

/// Bright magenta as an [AsciiInk] (colour index 13).
///
/// Usually about #FF00FF, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiHighMagenta = AsciiColour(13);

/// Bright cyan as an [AsciiInk] (colour index 14).
///
/// Usually about #00FFFF, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiHighCyan = AsciiColour(14);

/// Bright white as an [AsciiInk] (colour index 15).
///
/// Usually about #FFFFFF, but the terminal theme decides. Use `.fg`, `.bg` or
/// `.underline` for the escape code, or pass it to
/// [AsciiStyledString.foreground] and friends.
const AsciiColour asciiHighWhite = AsciiColour(15);

/// Colour-cube red 0, green 0, blue 0 as an [AsciiInk] (colour index 16).
///
/// About #000000. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb000 = AsciiColour(16);

/// Colour-cube red 0, green 0, blue 1 as an [AsciiInk] (colour index 17).
///
/// About #00005F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb001 = AsciiColour(17);

/// Colour-cube red 0, green 0, blue 2 as an [AsciiInk] (colour index 18).
///
/// About #000087. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb002 = AsciiColour(18);

/// Colour-cube red 0, green 0, blue 3 as an [AsciiInk] (colour index 19).
///
/// About #0000AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb003 = AsciiColour(19);

/// Colour-cube red 0, green 0, blue 4 as an [AsciiInk] (colour index 20).
///
/// About #0000D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb004 = AsciiColour(20);

/// Colour-cube red 0, green 0, blue 5 as an [AsciiInk] (colour index 21).
///
/// About #0000FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb005 = AsciiColour(21);

/// Colour-cube red 0, green 1, blue 0 as an [AsciiInk] (colour index 22).
///
/// About #005F00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb010 = AsciiColour(22);

/// Colour-cube red 0, green 1, blue 1 as an [AsciiInk] (colour index 23).
///
/// About #005F5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb011 = AsciiColour(23);

/// Colour-cube red 0, green 1, blue 2 as an [AsciiInk] (colour index 24).
///
/// About #005F87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb012 = AsciiColour(24);

/// Colour-cube red 0, green 1, blue 3 as an [AsciiInk] (colour index 25).
///
/// About #005FAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb013 = AsciiColour(25);

/// Colour-cube red 0, green 1, blue 4 as an [AsciiInk] (colour index 26).
///
/// About #005FD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb014 = AsciiColour(26);

/// Colour-cube red 0, green 1, blue 5 as an [AsciiInk] (colour index 27).
///
/// About #005FFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb015 = AsciiColour(27);

/// Colour-cube red 0, green 2, blue 0 as an [AsciiInk] (colour index 28).
///
/// About #008700. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb020 = AsciiColour(28);

/// Colour-cube red 0, green 2, blue 1 as an [AsciiInk] (colour index 29).
///
/// About #00875F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb021 = AsciiColour(29);

/// Colour-cube red 0, green 2, blue 2 as an [AsciiInk] (colour index 30).
///
/// About #008787. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb022 = AsciiColour(30);

/// Colour-cube red 0, green 2, blue 3 as an [AsciiInk] (colour index 31).
///
/// About #0087AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb023 = AsciiColour(31);

/// Colour-cube red 0, green 2, blue 4 as an [AsciiInk] (colour index 32).
///
/// About #0087D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb024 = AsciiColour(32);

/// Colour-cube red 0, green 2, blue 5 as an [AsciiInk] (colour index 33).
///
/// About #0087FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb025 = AsciiColour(33);

/// Colour-cube red 0, green 3, blue 0 as an [AsciiInk] (colour index 34).
///
/// About #00AF00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb030 = AsciiColour(34);

/// Colour-cube red 0, green 3, blue 1 as an [AsciiInk] (colour index 35).
///
/// About #00AF5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb031 = AsciiColour(35);

/// Colour-cube red 0, green 3, blue 2 as an [AsciiInk] (colour index 36).
///
/// About #00AF87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb032 = AsciiColour(36);

/// Colour-cube red 0, green 3, blue 3 as an [AsciiInk] (colour index 37).
///
/// About #00AFAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb033 = AsciiColour(37);

/// Colour-cube red 0, green 3, blue 4 as an [AsciiInk] (colour index 38).
///
/// About #00AFD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb034 = AsciiColour(38);

/// Colour-cube red 0, green 3, blue 5 as an [AsciiInk] (colour index 39).
///
/// About #00AFFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb035 = AsciiColour(39);

/// Colour-cube red 0, green 4, blue 0 as an [AsciiInk] (colour index 40).
///
/// About #00D700. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb040 = AsciiColour(40);

/// Colour-cube red 0, green 4, blue 1 as an [AsciiInk] (colour index 41).
///
/// About #00D75F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb041 = AsciiColour(41);

/// Colour-cube red 0, green 4, blue 2 as an [AsciiInk] (colour index 42).
///
/// About #00D787. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb042 = AsciiColour(42);

/// Colour-cube red 0, green 4, blue 3 as an [AsciiInk] (colour index 43).
///
/// About #00D7AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb043 = AsciiColour(43);

/// Colour-cube red 0, green 4, blue 4 as an [AsciiInk] (colour index 44).
///
/// About #00D7D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb044 = AsciiColour(44);

/// Colour-cube red 0, green 4, blue 5 as an [AsciiInk] (colour index 45).
///
/// About #00D7FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb045 = AsciiColour(45);

/// Colour-cube red 0, green 5, blue 0 as an [AsciiInk] (colour index 46).
///
/// About #00FF00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb050 = AsciiColour(46);

/// Colour-cube red 0, green 5, blue 1 as an [AsciiInk] (colour index 47).
///
/// About #00FF5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb051 = AsciiColour(47);

/// Colour-cube red 0, green 5, blue 2 as an [AsciiInk] (colour index 48).
///
/// About #00FF87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb052 = AsciiColour(48);

/// Colour-cube red 0, green 5, blue 3 as an [AsciiInk] (colour index 49).
///
/// About #00FFAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb053 = AsciiColour(49);

/// Colour-cube red 0, green 5, blue 4 as an [AsciiInk] (colour index 50).
///
/// About #00FFD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb054 = AsciiColour(50);

/// Colour-cube red 0, green 5, blue 5 as an [AsciiInk] (colour index 51).
///
/// About #00FFFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb055 = AsciiColour(51);

/// Colour-cube red 1, green 0, blue 0 as an [AsciiInk] (colour index 52).
///
/// About #5F0000. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb100 = AsciiColour(52);

/// Colour-cube red 1, green 0, blue 1 as an [AsciiInk] (colour index 53).
///
/// About #5F005F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb101 = AsciiColour(53);

/// Colour-cube red 1, green 0, blue 2 as an [AsciiInk] (colour index 54).
///
/// About #5F0087. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb102 = AsciiColour(54);

/// Colour-cube red 1, green 0, blue 3 as an [AsciiInk] (colour index 55).
///
/// About #5F00AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb103 = AsciiColour(55);

/// Colour-cube red 1, green 0, blue 4 as an [AsciiInk] (colour index 56).
///
/// About #5F00D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb104 = AsciiColour(56);

/// Colour-cube red 1, green 0, blue 5 as an [AsciiInk] (colour index 57).
///
/// About #5F00FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb105 = AsciiColour(57);

/// Colour-cube red 1, green 1, blue 0 as an [AsciiInk] (colour index 58).
///
/// About #5F5F00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb110 = AsciiColour(58);

/// Colour-cube red 1, green 1, blue 1 as an [AsciiInk] (colour index 59).
///
/// About #5F5F5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb111 = AsciiColour(59);

/// Colour-cube red 1, green 1, blue 2 as an [AsciiInk] (colour index 60).
///
/// About #5F5F87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb112 = AsciiColour(60);

/// Colour-cube red 1, green 1, blue 3 as an [AsciiInk] (colour index 61).
///
/// About #5F5FAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb113 = AsciiColour(61);

/// Colour-cube red 1, green 1, blue 4 as an [AsciiInk] (colour index 62).
///
/// About #5F5FD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb114 = AsciiColour(62);

/// Colour-cube red 1, green 1, blue 5 as an [AsciiInk] (colour index 63).
///
/// About #5F5FFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb115 = AsciiColour(63);

/// Colour-cube red 1, green 2, blue 0 as an [AsciiInk] (colour index 64).
///
/// About #5F8700. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb120 = AsciiColour(64);

/// Colour-cube red 1, green 2, blue 1 as an [AsciiInk] (colour index 65).
///
/// About #5F875F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb121 = AsciiColour(65);

/// Colour-cube red 1, green 2, blue 2 as an [AsciiInk] (colour index 66).
///
/// About #5F8787. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb122 = AsciiColour(66);

/// Colour-cube red 1, green 2, blue 3 as an [AsciiInk] (colour index 67).
///
/// About #5F87AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb123 = AsciiColour(67);

/// Colour-cube red 1, green 2, blue 4 as an [AsciiInk] (colour index 68).
///
/// About #5F87D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb124 = AsciiColour(68);

/// Colour-cube red 1, green 2, blue 5 as an [AsciiInk] (colour index 69).
///
/// About #5F87FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb125 = AsciiColour(69);

/// Colour-cube red 1, green 3, blue 0 as an [AsciiInk] (colour index 70).
///
/// About #5FAF00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb130 = AsciiColour(70);

/// Colour-cube red 1, green 3, blue 1 as an [AsciiInk] (colour index 71).
///
/// About #5FAF5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb131 = AsciiColour(71);

/// Colour-cube red 1, green 3, blue 2 as an [AsciiInk] (colour index 72).
///
/// About #5FAF87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb132 = AsciiColour(72);

/// Colour-cube red 1, green 3, blue 3 as an [AsciiInk] (colour index 73).
///
/// About #5FAFAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb133 = AsciiColour(73);

/// Colour-cube red 1, green 3, blue 4 as an [AsciiInk] (colour index 74).
///
/// About #5FAFD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb134 = AsciiColour(74);

/// Colour-cube red 1, green 3, blue 5 as an [AsciiInk] (colour index 75).
///
/// About #5FAFFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb135 = AsciiColour(75);

/// Colour-cube red 1, green 4, blue 0 as an [AsciiInk] (colour index 76).
///
/// About #5FD700. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb140 = AsciiColour(76);

/// Colour-cube red 1, green 4, blue 1 as an [AsciiInk] (colour index 77).
///
/// About #5FD75F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb141 = AsciiColour(77);

/// Colour-cube red 1, green 4, blue 2 as an [AsciiInk] (colour index 78).
///
/// About #5FD787. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb142 = AsciiColour(78);

/// Colour-cube red 1, green 4, blue 3 as an [AsciiInk] (colour index 79).
///
/// About #5FD7AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb143 = AsciiColour(79);

/// Colour-cube red 1, green 4, blue 4 as an [AsciiInk] (colour index 80).
///
/// About #5FD7D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb144 = AsciiColour(80);

/// Colour-cube red 1, green 4, blue 5 as an [AsciiInk] (colour index 81).
///
/// About #5FD7FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb145 = AsciiColour(81);

/// Colour-cube red 1, green 5, blue 0 as an [AsciiInk] (colour index 82).
///
/// About #5FFF00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb150 = AsciiColour(82);

/// Colour-cube red 1, green 5, blue 1 as an [AsciiInk] (colour index 83).
///
/// About #5FFF5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb151 = AsciiColour(83);

/// Colour-cube red 1, green 5, blue 2 as an [AsciiInk] (colour index 84).
///
/// About #5FFF87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb152 = AsciiColour(84);

/// Colour-cube red 1, green 5, blue 3 as an [AsciiInk] (colour index 85).
///
/// About #5FFFAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb153 = AsciiColour(85);

/// Colour-cube red 1, green 5, blue 4 as an [AsciiInk] (colour index 86).
///
/// About #5FFFD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb154 = AsciiColour(86);

/// Colour-cube red 1, green 5, blue 5 as an [AsciiInk] (colour index 87).
///
/// About #5FFFFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb155 = AsciiColour(87);

/// Colour-cube red 2, green 0, blue 0 as an [AsciiInk] (colour index 88).
///
/// About #870000. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb200 = AsciiColour(88);

/// Colour-cube red 2, green 0, blue 1 as an [AsciiInk] (colour index 89).
///
/// About #87005F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb201 = AsciiColour(89);

/// Colour-cube red 2, green 0, blue 2 as an [AsciiInk] (colour index 90).
///
/// About #870087. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb202 = AsciiColour(90);

/// Colour-cube red 2, green 0, blue 3 as an [AsciiInk] (colour index 91).
///
/// About #8700AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb203 = AsciiColour(91);

/// Colour-cube red 2, green 0, blue 4 as an [AsciiInk] (colour index 92).
///
/// About #8700D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb204 = AsciiColour(92);

/// Colour-cube red 2, green 0, blue 5 as an [AsciiInk] (colour index 93).
///
/// About #8700FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb205 = AsciiColour(93);

/// Colour-cube red 2, green 1, blue 0 as an [AsciiInk] (colour index 94).
///
/// About #875F00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb210 = AsciiColour(94);

/// Colour-cube red 2, green 1, blue 1 as an [AsciiInk] (colour index 95).
///
/// About #875F5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb211 = AsciiColour(95);

/// Colour-cube red 2, green 1, blue 2 as an [AsciiInk] (colour index 96).
///
/// About #875F87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb212 = AsciiColour(96);

/// Colour-cube red 2, green 1, blue 3 as an [AsciiInk] (colour index 97).
///
/// About #875FAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb213 = AsciiColour(97);

/// Colour-cube red 2, green 1, blue 4 as an [AsciiInk] (colour index 98).
///
/// About #875FD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb214 = AsciiColour(98);

/// Colour-cube red 2, green 1, blue 5 as an [AsciiInk] (colour index 99).
///
/// About #875FFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb215 = AsciiColour(99);

/// Colour-cube red 2, green 2, blue 0 as an [AsciiInk] (colour index 100).
///
/// About #878700. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb220 = AsciiColour(100);

/// Colour-cube red 2, green 2, blue 1 as an [AsciiInk] (colour index 101).
///
/// About #87875F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb221 = AsciiColour(101);

/// Colour-cube red 2, green 2, blue 2 as an [AsciiInk] (colour index 102).
///
/// About #878787. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb222 = AsciiColour(102);

/// Colour-cube red 2, green 2, blue 3 as an [AsciiInk] (colour index 103).
///
/// About #8787AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb223 = AsciiColour(103);

/// Colour-cube red 2, green 2, blue 4 as an [AsciiInk] (colour index 104).
///
/// About #8787D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb224 = AsciiColour(104);

/// Colour-cube red 2, green 2, blue 5 as an [AsciiInk] (colour index 105).
///
/// About #8787FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb225 = AsciiColour(105);

/// Colour-cube red 2, green 3, blue 0 as an [AsciiInk] (colour index 106).
///
/// About #87AF00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb230 = AsciiColour(106);

/// Colour-cube red 2, green 3, blue 1 as an [AsciiInk] (colour index 107).
///
/// About #87AF5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb231 = AsciiColour(107);

/// Colour-cube red 2, green 3, blue 2 as an [AsciiInk] (colour index 108).
///
/// About #87AF87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb232 = AsciiColour(108);

/// Colour-cube red 2, green 3, blue 3 as an [AsciiInk] (colour index 109).
///
/// About #87AFAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb233 = AsciiColour(109);

/// Colour-cube red 2, green 3, blue 4 as an [AsciiInk] (colour index 110).
///
/// About #87AFD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb234 = AsciiColour(110);

/// Colour-cube red 2, green 3, blue 5 as an [AsciiInk] (colour index 111).
///
/// About #87AFFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb235 = AsciiColour(111);

/// Colour-cube red 2, green 4, blue 0 as an [AsciiInk] (colour index 112).
///
/// About #87D700. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb240 = AsciiColour(112);

/// Colour-cube red 2, green 4, blue 1 as an [AsciiInk] (colour index 113).
///
/// About #87D75F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb241 = AsciiColour(113);

/// Colour-cube red 2, green 4, blue 2 as an [AsciiInk] (colour index 114).
///
/// About #87D787. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb242 = AsciiColour(114);

/// Colour-cube red 2, green 4, blue 3 as an [AsciiInk] (colour index 115).
///
/// About #87D7AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb243 = AsciiColour(115);

/// Colour-cube red 2, green 4, blue 4 as an [AsciiInk] (colour index 116).
///
/// About #87D7D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb244 = AsciiColour(116);

/// Colour-cube red 2, green 4, blue 5 as an [AsciiInk] (colour index 117).
///
/// About #87D7FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb245 = AsciiColour(117);

/// Colour-cube red 2, green 5, blue 0 as an [AsciiInk] (colour index 118).
///
/// About #87FF00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb250 = AsciiColour(118);

/// Colour-cube red 2, green 5, blue 1 as an [AsciiInk] (colour index 119).
///
/// About #87FF5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb251 = AsciiColour(119);

/// Colour-cube red 2, green 5, blue 2 as an [AsciiInk] (colour index 120).
///
/// About #87FF87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb252 = AsciiColour(120);

/// Colour-cube red 2, green 5, blue 3 as an [AsciiInk] (colour index 121).
///
/// About #87FFAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb253 = AsciiColour(121);

/// Colour-cube red 2, green 5, blue 4 as an [AsciiInk] (colour index 122).
///
/// About #87FFD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb254 = AsciiColour(122);

/// Colour-cube red 2, green 5, blue 5 as an [AsciiInk] (colour index 123).
///
/// About #87FFFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb255 = AsciiColour(123);

/// Colour-cube red 3, green 0, blue 0 as an [AsciiInk] (colour index 124).
///
/// About #AF0000. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb300 = AsciiColour(124);

/// Colour-cube red 3, green 0, blue 1 as an [AsciiInk] (colour index 125).
///
/// About #AF005F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb301 = AsciiColour(125);

/// Colour-cube red 3, green 0, blue 2 as an [AsciiInk] (colour index 126).
///
/// About #AF0087. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb302 = AsciiColour(126);

/// Colour-cube red 3, green 0, blue 3 as an [AsciiInk] (colour index 127).
///
/// About #AF00AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb303 = AsciiColour(127);

/// Colour-cube red 3, green 0, blue 4 as an [AsciiInk] (colour index 128).
///
/// About #AF00D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb304 = AsciiColour(128);

/// Colour-cube red 3, green 0, blue 5 as an [AsciiInk] (colour index 129).
///
/// About #AF00FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb305 = AsciiColour(129);

/// Colour-cube red 3, green 1, blue 0 as an [AsciiInk] (colour index 130).
///
/// About #AF5F00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb310 = AsciiColour(130);

/// Colour-cube red 3, green 1, blue 1 as an [AsciiInk] (colour index 131).
///
/// About #AF5F5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb311 = AsciiColour(131);

/// Colour-cube red 3, green 1, blue 2 as an [AsciiInk] (colour index 132).
///
/// About #AF5F87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb312 = AsciiColour(132);

/// Colour-cube red 3, green 1, blue 3 as an [AsciiInk] (colour index 133).
///
/// About #AF5FAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb313 = AsciiColour(133);

/// Colour-cube red 3, green 1, blue 4 as an [AsciiInk] (colour index 134).
///
/// About #AF5FD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb314 = AsciiColour(134);

/// Colour-cube red 3, green 1, blue 5 as an [AsciiInk] (colour index 135).
///
/// About #AF5FFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb315 = AsciiColour(135);

/// Colour-cube red 3, green 2, blue 0 as an [AsciiInk] (colour index 136).
///
/// About #AF8700. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb320 = AsciiColour(136);

/// Colour-cube red 3, green 2, blue 1 as an [AsciiInk] (colour index 137).
///
/// About #AF875F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb321 = AsciiColour(137);

/// Colour-cube red 3, green 2, blue 2 as an [AsciiInk] (colour index 138).
///
/// About #AF8787. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb322 = AsciiColour(138);

/// Colour-cube red 3, green 2, blue 3 as an [AsciiInk] (colour index 139).
///
/// About #AF87AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb323 = AsciiColour(139);

/// Colour-cube red 3, green 2, blue 4 as an [AsciiInk] (colour index 140).
///
/// About #AF87D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb324 = AsciiColour(140);

/// Colour-cube red 3, green 2, blue 5 as an [AsciiInk] (colour index 141).
///
/// About #AF87FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb325 = AsciiColour(141);

/// Colour-cube red 3, green 3, blue 0 as an [AsciiInk] (colour index 142).
///
/// About #AFAF00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb330 = AsciiColour(142);

/// Colour-cube red 3, green 3, blue 1 as an [AsciiInk] (colour index 143).
///
/// About #AFAF5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb331 = AsciiColour(143);

/// Colour-cube red 3, green 3, blue 2 as an [AsciiInk] (colour index 144).
///
/// About #AFAF87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb332 = AsciiColour(144);

/// Colour-cube red 3, green 3, blue 3 as an [AsciiInk] (colour index 145).
///
/// About #AFAFAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb333 = AsciiColour(145);

/// Colour-cube red 3, green 3, blue 4 as an [AsciiInk] (colour index 146).
///
/// About #AFAFD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb334 = AsciiColour(146);

/// Colour-cube red 3, green 3, blue 5 as an [AsciiInk] (colour index 147).
///
/// About #AFAFFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb335 = AsciiColour(147);

/// Colour-cube red 3, green 4, blue 0 as an [AsciiInk] (colour index 148).
///
/// About #AFD700. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb340 = AsciiColour(148);

/// Colour-cube red 3, green 4, blue 1 as an [AsciiInk] (colour index 149).
///
/// About #AFD75F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb341 = AsciiColour(149);

/// Colour-cube red 3, green 4, blue 2 as an [AsciiInk] (colour index 150).
///
/// About #AFD787. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb342 = AsciiColour(150);

/// Colour-cube red 3, green 4, blue 3 as an [AsciiInk] (colour index 151).
///
/// About #AFD7AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb343 = AsciiColour(151);

/// Colour-cube red 3, green 4, blue 4 as an [AsciiInk] (colour index 152).
///
/// About #AFD7D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb344 = AsciiColour(152);

/// Colour-cube red 3, green 4, blue 5 as an [AsciiInk] (colour index 153).
///
/// About #AFD7FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb345 = AsciiColour(153);

/// Colour-cube red 3, green 5, blue 0 as an [AsciiInk] (colour index 154).
///
/// About #AFFF00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb350 = AsciiColour(154);

/// Colour-cube red 3, green 5, blue 1 as an [AsciiInk] (colour index 155).
///
/// About #AFFF5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb351 = AsciiColour(155);

/// Colour-cube red 3, green 5, blue 2 as an [AsciiInk] (colour index 156).
///
/// About #AFFF87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb352 = AsciiColour(156);

/// Colour-cube red 3, green 5, blue 3 as an [AsciiInk] (colour index 157).
///
/// About #AFFFAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb353 = AsciiColour(157);

/// Colour-cube red 3, green 5, blue 4 as an [AsciiInk] (colour index 158).
///
/// About #AFFFD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb354 = AsciiColour(158);

/// Colour-cube red 3, green 5, blue 5 as an [AsciiInk] (colour index 159).
///
/// About #AFFFFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb355 = AsciiColour(159);

/// Colour-cube red 4, green 0, blue 0 as an [AsciiInk] (colour index 160).
///
/// About #D70000. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb400 = AsciiColour(160);

/// Colour-cube red 4, green 0, blue 1 as an [AsciiInk] (colour index 161).
///
/// About #D7005F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb401 = AsciiColour(161);

/// Colour-cube red 4, green 0, blue 2 as an [AsciiInk] (colour index 162).
///
/// About #D70087. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb402 = AsciiColour(162);

/// Colour-cube red 4, green 0, blue 3 as an [AsciiInk] (colour index 163).
///
/// About #D700AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb403 = AsciiColour(163);

/// Colour-cube red 4, green 0, blue 4 as an [AsciiInk] (colour index 164).
///
/// About #D700D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb404 = AsciiColour(164);

/// Colour-cube red 4, green 0, blue 5 as an [AsciiInk] (colour index 165).
///
/// About #D700FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb405 = AsciiColour(165);

/// Colour-cube red 4, green 1, blue 0 as an [AsciiInk] (colour index 166).
///
/// About #D75F00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb410 = AsciiColour(166);

/// Colour-cube red 4, green 1, blue 1 as an [AsciiInk] (colour index 167).
///
/// About #D75F5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb411 = AsciiColour(167);

/// Colour-cube red 4, green 1, blue 2 as an [AsciiInk] (colour index 168).
///
/// About #D75F87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb412 = AsciiColour(168);

/// Colour-cube red 4, green 1, blue 3 as an [AsciiInk] (colour index 169).
///
/// About #D75FAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb413 = AsciiColour(169);

/// Colour-cube red 4, green 1, blue 4 as an [AsciiInk] (colour index 170).
///
/// About #D75FD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb414 = AsciiColour(170);

/// Colour-cube red 4, green 1, blue 5 as an [AsciiInk] (colour index 171).
///
/// About #D75FFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb415 = AsciiColour(171);

/// Colour-cube red 4, green 2, blue 0 as an [AsciiInk] (colour index 172).
///
/// About #D78700. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb420 = AsciiColour(172);

/// Colour-cube red 4, green 2, blue 1 as an [AsciiInk] (colour index 173).
///
/// About #D7875F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb421 = AsciiColour(173);

/// Colour-cube red 4, green 2, blue 2 as an [AsciiInk] (colour index 174).
///
/// About #D78787. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb422 = AsciiColour(174);

/// Colour-cube red 4, green 2, blue 3 as an [AsciiInk] (colour index 175).
///
/// About #D787AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb423 = AsciiColour(175);

/// Colour-cube red 4, green 2, blue 4 as an [AsciiInk] (colour index 176).
///
/// About #D787D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb424 = AsciiColour(176);

/// Colour-cube red 4, green 2, blue 5 as an [AsciiInk] (colour index 177).
///
/// About #D787FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb425 = AsciiColour(177);

/// Colour-cube red 4, green 3, blue 0 as an [AsciiInk] (colour index 178).
///
/// About #D7AF00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb430 = AsciiColour(178);

/// Colour-cube red 4, green 3, blue 1 as an [AsciiInk] (colour index 179).
///
/// About #D7AF5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb431 = AsciiColour(179);

/// Colour-cube red 4, green 3, blue 2 as an [AsciiInk] (colour index 180).
///
/// About #D7AF87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb432 = AsciiColour(180);

/// Colour-cube red 4, green 3, blue 3 as an [AsciiInk] (colour index 181).
///
/// About #D7AFAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb433 = AsciiColour(181);

/// Colour-cube red 4, green 3, blue 4 as an [AsciiInk] (colour index 182).
///
/// About #D7AFD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb434 = AsciiColour(182);

/// Colour-cube red 4, green 3, blue 5 as an [AsciiInk] (colour index 183).
///
/// About #D7AFFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb435 = AsciiColour(183);

/// Colour-cube red 4, green 4, blue 0 as an [AsciiInk] (colour index 184).
///
/// About #D7D700. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb440 = AsciiColour(184);

/// Colour-cube red 4, green 4, blue 1 as an [AsciiInk] (colour index 185).
///
/// About #D7D75F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb441 = AsciiColour(185);

/// Colour-cube red 4, green 4, blue 2 as an [AsciiInk] (colour index 186).
///
/// About #D7D787. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb442 = AsciiColour(186);

/// Colour-cube red 4, green 4, blue 3 as an [AsciiInk] (colour index 187).
///
/// About #D7D7AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb443 = AsciiColour(187);

/// Colour-cube red 4, green 4, blue 4 as an [AsciiInk] (colour index 188).
///
/// About #D7D7D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb444 = AsciiColour(188);

/// Colour-cube red 4, green 4, blue 5 as an [AsciiInk] (colour index 189).
///
/// About #D7D7FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb445 = AsciiColour(189);

/// Colour-cube red 4, green 5, blue 0 as an [AsciiInk] (colour index 190).
///
/// About #D7FF00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb450 = AsciiColour(190);

/// Colour-cube red 4, green 5, blue 1 as an [AsciiInk] (colour index 191).
///
/// About #D7FF5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb451 = AsciiColour(191);

/// Colour-cube red 4, green 5, blue 2 as an [AsciiInk] (colour index 192).
///
/// About #D7FF87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb452 = AsciiColour(192);

/// Colour-cube red 4, green 5, blue 3 as an [AsciiInk] (colour index 193).
///
/// About #D7FFAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb453 = AsciiColour(193);

/// Colour-cube red 4, green 5, blue 4 as an [AsciiInk] (colour index 194).
///
/// About #D7FFD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb454 = AsciiColour(194);

/// Colour-cube red 4, green 5, blue 5 as an [AsciiInk] (colour index 195).
///
/// About #D7FFFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb455 = AsciiColour(195);

/// Colour-cube red 5, green 0, blue 0 as an [AsciiInk] (colour index 196).
///
/// About #FF0000. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb500 = AsciiColour(196);

/// Colour-cube red 5, green 0, blue 1 as an [AsciiInk] (colour index 197).
///
/// About #FF005F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb501 = AsciiColour(197);

/// Colour-cube red 5, green 0, blue 2 as an [AsciiInk] (colour index 198).
///
/// About #FF0087. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb502 = AsciiColour(198);

/// Colour-cube red 5, green 0, blue 3 as an [AsciiInk] (colour index 199).
///
/// About #FF00AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb503 = AsciiColour(199);

/// Colour-cube red 5, green 0, blue 4 as an [AsciiInk] (colour index 200).
///
/// About #FF00D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb504 = AsciiColour(200);

/// Colour-cube red 5, green 0, blue 5 as an [AsciiInk] (colour index 201).
///
/// About #FF00FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb505 = AsciiColour(201);

/// Colour-cube red 5, green 1, blue 0 as an [AsciiInk] (colour index 202).
///
/// About #FF5F00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb510 = AsciiColour(202);

/// Colour-cube red 5, green 1, blue 1 as an [AsciiInk] (colour index 203).
///
/// About #FF5F5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb511 = AsciiColour(203);

/// Colour-cube red 5, green 1, blue 2 as an [AsciiInk] (colour index 204).
///
/// About #FF5F87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb512 = AsciiColour(204);

/// Colour-cube red 5, green 1, blue 3 as an [AsciiInk] (colour index 205).
///
/// About #FF5FAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb513 = AsciiColour(205);

/// Colour-cube red 5, green 1, blue 4 as an [AsciiInk] (colour index 206).
///
/// About #FF5FD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb514 = AsciiColour(206);

/// Colour-cube red 5, green 1, blue 5 as an [AsciiInk] (colour index 207).
///
/// About #FF5FFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb515 = AsciiColour(207);

/// Colour-cube red 5, green 2, blue 0 as an [AsciiInk] (colour index 208).
///
/// About #FF8700. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb520 = AsciiColour(208);

/// Colour-cube red 5, green 2, blue 1 as an [AsciiInk] (colour index 209).
///
/// About #FF875F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb521 = AsciiColour(209);

/// Colour-cube red 5, green 2, blue 2 as an [AsciiInk] (colour index 210).
///
/// About #FF8787. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb522 = AsciiColour(210);

/// Colour-cube red 5, green 2, blue 3 as an [AsciiInk] (colour index 211).
///
/// About #FF87AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb523 = AsciiColour(211);

/// Colour-cube red 5, green 2, blue 4 as an [AsciiInk] (colour index 212).
///
/// About #FF87D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb524 = AsciiColour(212);

/// Colour-cube red 5, green 2, blue 5 as an [AsciiInk] (colour index 213).
///
/// About #FF87FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb525 = AsciiColour(213);

/// Colour-cube red 5, green 3, blue 0 as an [AsciiInk] (colour index 214).
///
/// About #FFAF00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb530 = AsciiColour(214);

/// Colour-cube red 5, green 3, blue 1 as an [AsciiInk] (colour index 215).
///
/// About #FFAF5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb531 = AsciiColour(215);

/// Colour-cube red 5, green 3, blue 2 as an [AsciiInk] (colour index 216).
///
/// About #FFAF87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb532 = AsciiColour(216);

/// Colour-cube red 5, green 3, blue 3 as an [AsciiInk] (colour index 217).
///
/// About #FFAFAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb533 = AsciiColour(217);

/// Colour-cube red 5, green 3, blue 4 as an [AsciiInk] (colour index 218).
///
/// About #FFAFD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb534 = AsciiColour(218);

/// Colour-cube red 5, green 3, blue 5 as an [AsciiInk] (colour index 219).
///
/// About #FFAFFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb535 = AsciiColour(219);

/// Colour-cube red 5, green 4, blue 0 as an [AsciiInk] (colour index 220).
///
/// About #FFD700. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb540 = AsciiColour(220);

/// Colour-cube red 5, green 4, blue 1 as an [AsciiInk] (colour index 221).
///
/// About #FFD75F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb541 = AsciiColour(221);

/// Colour-cube red 5, green 4, blue 2 as an [AsciiInk] (colour index 222).
///
/// About #FFD787. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb542 = AsciiColour(222);

/// Colour-cube red 5, green 4, blue 3 as an [AsciiInk] (colour index 223).
///
/// About #FFD7AF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb543 = AsciiColour(223);

/// Colour-cube red 5, green 4, blue 4 as an [AsciiInk] (colour index 224).
///
/// About #FFD7D7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb544 = AsciiColour(224);

/// Colour-cube red 5, green 4, blue 5 as an [AsciiInk] (colour index 225).
///
/// About #FFD7FF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb545 = AsciiColour(225);

/// Colour-cube red 5, green 5, blue 0 as an [AsciiInk] (colour index 226).
///
/// About #FFFF00. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb550 = AsciiColour(226);

/// Colour-cube red 5, green 5, blue 1 as an [AsciiInk] (colour index 227).
///
/// About #FFFF5F. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb551 = AsciiColour(227);

/// Colour-cube red 5, green 5, blue 2 as an [AsciiInk] (colour index 228).
///
/// About #FFFF87. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb552 = AsciiColour(228);

/// Colour-cube red 5, green 5, blue 3 as an [AsciiInk] (colour index 229).
///
/// About #FFFFAF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb553 = AsciiColour(229);

/// Colour-cube red 5, green 5, blue 4 as an [AsciiInk] (colour index 230).
///
/// About #FFFFD7. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb554 = AsciiColour(230);

/// Colour-cube red 5, green 5, blue 5 as an [AsciiInk] (colour index 231).
///
/// About #FFFFFF. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiRgb555 = AsciiColour(231);

/// Grey step 0 of 23 as an [AsciiInk] (colour index 232).
///
/// About #080808. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey0 = AsciiColour(232);

/// Grey step 1 of 23 as an [AsciiInk] (colour index 233).
///
/// About #121212. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey1 = AsciiColour(233);

/// Grey step 2 of 23 as an [AsciiInk] (colour index 234).
///
/// About #1C1C1C. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey2 = AsciiColour(234);

/// Grey step 3 of 23 as an [AsciiInk] (colour index 235).
///
/// About #262626. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey3 = AsciiColour(235);

/// Grey step 4 of 23 as an [AsciiInk] (colour index 236).
///
/// About #303030. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey4 = AsciiColour(236);

/// Grey step 5 of 23 as an [AsciiInk] (colour index 237).
///
/// About #3A3A3A. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey5 = AsciiColour(237);

/// Grey step 6 of 23 as an [AsciiInk] (colour index 238).
///
/// About #444444. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey6 = AsciiColour(238);

/// Grey step 7 of 23 as an [AsciiInk] (colour index 239).
///
/// About #4E4E4E. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey7 = AsciiColour(239);

/// Grey step 8 of 23 as an [AsciiInk] (colour index 240).
///
/// About #585858. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey8 = AsciiColour(240);

/// Grey step 9 of 23 as an [AsciiInk] (colour index 241).
///
/// About #626262. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey9 = AsciiColour(241);

/// Grey step 10 of 23 as an [AsciiInk] (colour index 242).
///
/// About #6C6C6C. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey10 = AsciiColour(242);

/// Grey step 11 of 23 as an [AsciiInk] (colour index 243).
///
/// About #767676. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey11 = AsciiColour(243);

/// Grey step 12 of 23 as an [AsciiInk] (colour index 244).
///
/// About #808080. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey12 = AsciiColour(244);

/// Grey step 13 of 23 as an [AsciiInk] (colour index 245).
///
/// About #8A8A8A. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey13 = AsciiColour(245);

/// Grey step 14 of 23 as an [AsciiInk] (colour index 246).
///
/// About #949494. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey14 = AsciiColour(246);

/// Grey step 15 of 23 as an [AsciiInk] (colour index 247).
///
/// About #9E9E9E. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey15 = AsciiColour(247);

/// Grey step 16 of 23 as an [AsciiInk] (colour index 248).
///
/// About #A8A8A8. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey16 = AsciiColour(248);

/// Grey step 17 of 23 as an [AsciiInk] (colour index 249).
///
/// About #B2B2B2. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey17 = AsciiColour(249);

/// Grey step 18 of 23 as an [AsciiInk] (colour index 250).
///
/// About #BCBCBC. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey18 = AsciiColour(250);

/// Grey step 19 of 23 as an [AsciiInk] (colour index 251).
///
/// About #C6C6C6. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey19 = AsciiColour(251);

/// Grey step 20 of 23 as an [AsciiInk] (colour index 252).
///
/// About #D0D0D0. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey20 = AsciiColour(252);

/// Grey step 21 of 23 as an [AsciiInk] (colour index 253).
///
/// About #DADADA. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey21 = AsciiColour(253);

/// Grey step 22 of 23 as an [AsciiInk] (colour index 254).
///
/// About #E4E4E4. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey22 = AsciiColour(254);

/// Grey step 23 of 23 as an [AsciiInk] (colour index 255).
///
/// About #EEEEEE. Use `.fg`, `.bg` or `.underline` for the escape code, or pass
/// it to [AsciiStyledString.foreground] and friends.
const AsciiColour asciiGrey23 = AsciiColour(255);
