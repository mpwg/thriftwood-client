import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lunasea/database/models/indexer.dart';
import 'package:lunasea/database/models/log.dart';
import 'package:lunasea/database/models/profile.dart';
import 'package:lunasea/database/table.dart';
import 'package:lunasea/system/logger.dart';
import 'package:lunasea/vendor.dart';

enum LunaBox<T> {
  alerts<dynamic>('alerts'),
  indexers<LunaIndexer>('indexers'),
  logs<LunaLog>('logs'),
  lunasea<dynamic>('lunasea'),
  profiles<LunaProfile>('profiles');

  final String key;
  const LunaBox(this.key);

  // Simple in-memory storage until SwiftData migration is complete
  static final Map<String, Map<dynamic, dynamic>> _storage = {};

  Map<dynamic, dynamic> get _instance {
    _storage[key] ??= <dynamic, dynamic>{};
    return _storage[key]!;
  }

  Iterable<dynamic> get keys => _instance.keys;
  Iterable<T> get data => _instance.values.cast<T>();

  int get size => _instance.length;
  bool get isEmpty => _instance.isEmpty;

  static Future<void> open() async {
    // Initialize all storage maps
    for (final box in LunaBox.values) {
      _storage[box.key] ??= <dynamic, dynamic>{};
    }
  }

  T? read(dynamic key, {T? fallback}) {
    final value = _instance[key];
    return value != null ? value as T : fallback;
  }

  T? readAt(int index) {
    final keys = _instance.keys.toList();
    if (index >= 0 && index < keys.length) {
      return _instance[keys[index]] as T?;
    }
    return null;
  }

  bool contains(dynamic key) {
    return _instance.containsKey(key);
  }

  Future<int> create(T value) async {
    final keys = _instance.keys.where((k) => k is int).cast<int>();
    final nextKey = keys.isEmpty ? 0 : keys.reduce((a, b) => a > b ? a : b) + 1;
    _instance[nextKey] = value;
    return nextKey;
  }

  Future<void> update(dynamic key, T value) async {
    _instance[key] = value;
  }

  Future<void> delete(dynamic key) async {
    _instance.remove(key);
  }

  Future<void> clear() async {
    _instance.clear();
  }

  Stream<MapEntry<dynamic, dynamic>> watch([dynamic key]) {
    // Simple stub - return empty stream for now
    return const Stream.empty();
  }

  ValueNotifier<Map<dynamic, dynamic>> listenable([List<dynamic>? keys]) {
    return ValueNotifier(_instance);
  }

  ValueListenableBuilder listenableBuilder({
    required Widget Function(BuildContext, Widget?) builder,
    List<dynamic>? selectKeys,
    List<LunaTableMixin>? selectItems,
    Key? key,
    Widget? child,
  }) {
    final items = selectItems?.map((item) => item.key).toList();
    final keys = [...?selectKeys, ...?items];

    return ValueListenableBuilder(
      key: key,
      valueListenable: listenable(keys.isNotEmpty ? keys : null),
      builder: (context, _, widget) => builder(context, widget),
      child: child,
    );
  }
}

extension LunaBoxExtension on LunaBox {
  /// This only works for boxes that are typed specifically for a hive object
  /// Should be improved to actually support every box.
  List<Map<String, dynamic>> export() {
    try {
      return _instance.keys
          .map<Map<String, dynamic>>((k) => (_instance[k]! as dynamic).toJson())
          .toList();
    } catch (error, stack) {
      LunaLogger().error('Failed to export LunaBox', error, stack);
      return [];
    }
  }
}
