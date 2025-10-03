import 'package:flutter/services.dart';
import 'package:lunasea/system/logger.dart';

/// Detects if Flutter is running embedded within SwiftUI as a secondary component
/// vs. Flutter being the primary navigation controller
class EmbeddedContextDetector {
  static const _channel = MethodChannel('com.thriftwood.bridge');
  static bool? _isEmbedded;

  /// Check if Flutter is running embedded in SwiftUI (vs. Flutter-primary mode)
  static Future<bool> isEmbeddedInSwiftUI() async {
    if (_isEmbedded != null) return _isEmbedded!;

    try {
      final result = await _channel.invokeMethod<bool>('isEmbeddedContext');
      _isEmbedded = result ?? false;

      LunaLogger().debug('Flutter embedded context detected: $_isEmbedded');
      return _isEmbedded!;
    } catch (e) {
      // If the method channel isn't available, assume Flutter-primary mode
      LunaLogger().debug(
          'Could not detect embedded context, assuming Flutter-primary: $e');
      _isEmbedded = false;
      return false;
    }
  }

  /// Reset the cached state (for testing)
  static void reset() {
    _isEmbedded = null;
  }
}
