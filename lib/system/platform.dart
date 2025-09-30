import 'package:flutter/foundation.dart';

enum LunaPlatform {
  IOS;

  static bool get isAndroid => false;

  static bool get isIOS {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  }

  static bool get isLinux => false;

  static bool get isMacOS => false;

  static bool get isWeb => false;

  static bool get isWindows => false;

  static bool get isMobile => isIOS;
  static bool get isDesktop => false;

  static LunaPlatform get current {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return LunaPlatform.IOS;
      default:
        throw UnsupportedError('Only iOS platform is supported');
    }
  }

  String get name {
    switch (this) {
      case LunaPlatform.IOS:
        return 'iOS';
    }
  }
}
