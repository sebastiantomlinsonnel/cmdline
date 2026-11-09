import 'dart:ffi';
import 'dart:io';

/// `HANDLE GetStdHandle(DWORD nStdHandle)`
typedef _GetStdHandleC = IntPtr Function(Int32 which);
typedef _GetStdHandleDart = int Function(int which);

/// `BOOL GetConsoleMode(HANDLE, LPDWORD)`
typedef _GetConsoleModeC = Int32 Function(IntPtr handle, Pointer<Uint32> mode);
typedef _GetConsoleModeDart = int Function(int handle, Pointer<Uint32> mode);

/// `BOOL SetConsoleMode(HANDLE, DWORD)`
typedef _SetConsoleModeC = Int32 Function(IntPtr handle, Uint32 mode);
typedef _SetConsoleModeDart = int Function(int handle, int mode);

/// `HLOCAL LocalAlloc(UINT, SIZE_T)` and `HLOCAL LocalFree(HLOCAL)`
typedef _LocalAllocC = Pointer<Uint32> Function(Uint32 flags, IntPtr bytes);
typedef _LocalAllocDart = Pointer<Uint32> Function(int flags, int bytes);
typedef _LocalFreeC = IntPtr Function(Pointer<Uint32> memory);
typedef _LocalFreeDart = int Function(Pointer<Uint32> memory);

/// Turns on the Windows console setting that sends arrow keys to programs.
///
/// Without `ENABLE_VIRTUAL_TERMINAL_INPUT`, a Windows console in raw mode
/// passes typed characters through but drops arrows, Home/End, Page Up/Down
/// and Delete entirely. With it on, they arrive as the same escape
/// sequences other terminals send (`ESC [ A` for up), which [KeyReader]
/// understands.
///
/// Does nothing on other platforms, or when input isn't a console.
abstract final class WindowsConsole {
  static const int _stdInput = -10;
  static const int _virtualTerminalInput = 0x0200;
  static const int _zeroMemory = 0x0040;
  static const int _modeBytes = 4;

  /// The console mode from before [enableKeys], to put back later.
  static int? _saved;

  static DynamicLibrary? _kernel;

  static DynamicLibrary? get _kernel32 {
    if (!Platform.isWindows) return null;
    try {
      return _kernel ??= DynamicLibrary.open('kernel32.dll');
    } catch (_) {
      return null;
    }
  }

  /// Reads the input console's mode, or null if there isn't one.
  static int? _mode(DynamicLibrary kernel, int handle) {
    final alloc = kernel.lookupFunction<_LocalAllocC, _LocalAllocDart>('LocalAlloc');
    final free = kernel.lookupFunction<_LocalFreeC, _LocalFreeDart>('LocalFree');
    final get = kernel.lookupFunction<_GetConsoleModeC, _GetConsoleModeDart>('GetConsoleMode');
    final memory = alloc(_zeroMemory, _modeBytes);
    if (memory.address == 0) return null;
    try {
      return get(handle, memory) == 0 ? null : memory.value;
    } finally {
      free(memory);
    }
  }

  static int _inputHandle(DynamicLibrary kernel) =>
      kernel.lookupFunction<_GetStdHandleC, _GetStdHandleDart>('GetStdHandle')(_stdInput);

  static bool _setMode(DynamicLibrary kernel, int handle, int mode) =>
      kernel.lookupFunction<_SetConsoleModeC, _SetConsoleModeDart>('SetConsoleMode')(handle, mode) != 0;

  /// Turns on arrow-key input. Call after turning line mode off.
  static void enableKeys() {
    final kernel = _kernel32;
    if (kernel == null) return;
    try {
      final handle = _inputHandle(kernel);
      final mode = _mode(kernel, handle);
      if (mode == null) return;
      _saved ??= mode;
      if (mode & _virtualTerminalInput == 0) {
        _setMode(kernel, handle, mode | _virtualTerminalInput);
      }
    } catch (_) {
      // No console, or an old Windows without the setting: keys stay as
      // they were, and letters like j/k still work.
    }
  }

  /// Puts back the mode from before [enableKeys]. Call before turning line
  /// mode back on.
  static void restore() {
    final kernel = _kernel32;
    final saved = _saved;
    _saved = null;
    if (kernel == null || saved == null) return;
    try {
      _setMode(kernel, _inputHandle(kernel), saved);
    } catch (_) {
      // Nothing more can be done; line mode is turned back on anyway.
    }
  }
}
