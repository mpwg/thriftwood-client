// ignore: always_use_package_imports
import '../window_manager.dart';

bool isPlatformSupported() => false; // iOS doesn't need window management
LunaWindowManager getWindowManager() {
  throw UnsupportedError('LunaWindowManager unsupported on iOS');
}
