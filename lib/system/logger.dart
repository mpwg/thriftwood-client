import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lunasea/core.dart';
import 'package:lunasea/system/bridge/swift_data_accessor.dart';
import 'package:lunasea/types/exception.dart';
import 'package:lunasea/types/log_type.dart';

class LunaLogger {
  static String get checkLogsMessage => 'lunasea.CheckLogsMessage'.tr();

  void initialize() {
    FlutterError.onError = (details) async {
      if (kDebugMode) FlutterError.dumpErrorToConsole(details);
      Zone.current.handleUncaughtError(
        details.exception,
        details.stack ?? StackTrace.current,
      );
    };
  }

  /// Get recent logs
  Future<List<Map<String, dynamic>>> get logs async {
    try {
      return await SwiftDataAccessor.getLogs();
    } catch (error) {
      if (kDebugMode) print('Failed to get logs from SwiftData: $error');
      return [];
    }
  }

  Future<String> export() async {
    try {
      final logs = await SwiftDataAccessor.exportLogs();
      final encoder = JsonEncoder.withIndent(' '.repeat(4));
      return encoder.convert(logs);
    } catch (error) {
      if (kDebugMode) print('Failed to export logs from SwiftData: $error');
      return '[]';
    }
  }

  Future<void> clear() async {
    try {
      await SwiftDataAccessor.clearLogs();
    } catch (error) {
      if (kDebugMode) print('Failed to clear logs in SwiftData: $error');
    }
  }

  void debug(String message) {
    SwiftDataAccessor.writeLog(
      message: message,
      type: 'debug',
    );
  }

  void warning(String message, [String? className, String? methodName]) {
    SwiftDataAccessor.writeLog(
      message: message,
      type: 'warning',
      className: className,
      methodName: methodName,
    );
  }

  void error(String message, dynamic error, StackTrace? stackTrace) {
    if (kDebugMode) {
      print(message);
      print(error);
      print(stackTrace);
    }

    if (error is! NetworkImageLoadException) {
      SwiftDataAccessor.writeLog(
        message: message,
        type: 'error',
        error: error?.toString(),
      );
    }
  }

  void critical(dynamic error, StackTrace stackTrace) {
    if (kDebugMode) {
      print(error);
      print(stackTrace);
    }

    if (error is! NetworkImageLoadException) {
      SwiftDataAccessor.writeLog(
        message: error?.toString() ?? LunaUI.TEXT_EMDASH,
        type: 'critical',
        error: error?.toString(),
      );
    }
  }

  void exception(LunaException exception, [StackTrace? trace]) {
    switch (exception.type) {
      case LunaLogType.WARNING:
        warning(exception.toString(), exception.runtimeType.toString());
        break;
      case LunaLogType.ERROR:
        error(exception.toString(), exception, trace);
        break;
      default:
        break;
    }
  }
}
