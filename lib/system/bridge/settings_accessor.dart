import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lunasea/system/bridge/swift_data_accessor.dart';

/// Settings accessor that provides reactive listening for SwiftData settings changes
/// Replaces LunaBox.lunasea.listenableBuilder functionality with SwiftData
class SettingsAccessor extends ChangeNotifier {
  static final SettingsAccessor _instance = SettingsAccessor._internal();
  factory SettingsAccessor() => _instance;
  SettingsAccessor._internal();

  Map<String, dynamic> _settings = {};

  /// Get current settings value
  T? getValue<T>(String key, {T? defaultValue}) {
    return _settings[key] as T? ?? defaultValue;
  }

  /// Update a settings value and notify listeners
  Future<void> updateValue(String key, dynamic value) async {
    final oldValue = _settings[key];
    if (oldValue != value) {
      _settings[key] = value;

      // Update in SwiftData
      await SwiftDataAccessor.updateSettings({key: value});

      // Notify listeners
      notifyListeners();
    }
  }

  /// Initialize settings from SwiftData
  Future<void> initialize() async {
    try {
      final settings = await SwiftDataAccessor.getAppSettings();
      _settings = Map<String, dynamic>.from(settings);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Failed to initialize settings: $e');
    }
  }

  /// Listen to settings changes with a builder pattern
  /// This replaces LunaBox.lunasea.listenableBuilder functionality
  Widget settingsBuilder({
    required Widget Function(BuildContext, Widget?) builder,
    List<String>? keys,
    Widget? child,
  }) {
    return ListenableBuilder(
      listenable: this,
      builder: builder,
      child: child,
    );
  }
}
