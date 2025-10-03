import 'package:thriftwood/core.dart';
import 'package:thriftwood/types/log_type.dart';

part 'log.g.dart';

@HiveType(typeId: 23, adapterName: 'LunaLogAdapter')
class LunaLog extends HiveObject {
  @HiveField(0)
  final int timestamp;
  @HiveField(1)
  final LunaLogType type;
  @HiveField(2)
  final String? className;
  @HiveField(3)
  final String? methodName;
  @HiveField(4)
  final String message;
  @HiveField(5)
  final String? error;
  @HiveField(6)
  final String? stackTrace;

  LunaLog({
    required this.timestamp,
    required this.type,
    this.className,
    this.methodName,
    required this.message,
    this.error,
    this.stackTrace,
  });

  factory LunaLog.withMessage({
    required LunaLogType type,
    required String message,
    String? className,
    String? methodName,
  }) {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    return LunaLog(
      timestamp: timestamp,
      type: type,
      message: message,
    );
  }

  factory LunaLog.withError({
    required LunaLogType type,
    required String message,
    required dynamic error,
    required StackTrace? stackTrace,
    String? className,
    String? methodName,
  }) {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String? _className, _methodName;
    
    // Parse stack trace to extract class and method info from top frame
    if (stackTrace != null) {
      final frames = _parseStackTrace(stackTrace);
      if (frames.isNotEmpty) {
        _className = frames.first.uri;
        _methodName = frames.first.member;
      }
    }
    
    return LunaLog(
      timestamp: timestamp,
      type: type,
      className: className ?? _className,
      methodName: methodName ?? _methodName,
      message: message,
      error: error?.toString(),
      stackTrace: stackTrace?.toString(),
    );
  }

  /// Parses a stack trace string to extract frame information
  static List<_StackFrame> _parseStackTrace(StackTrace stackTrace) {
    final lines = stackTrace.toString().split('\n');
    final frames = <_StackFrame>[];
    
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      
      // Parse stack trace line format: "#0 ClassName.methodName (file:///path/to/file.dart:line:column)"
      final match = RegExp(r'#\d+\s+(.+?)\s+\((.+?):(\d+):(\d+)\)').firstMatch(line);
      if (match != null) {
        final memberInfo = match.group(1) ?? '';
        final uri = match.group(2) ?? '';
        
        frames.add(_StackFrame(
          member: memberInfo,
          uri: uri,
        ));
      }
    }
    
    return frames;
  }

  Map<String, dynamic> toJson() {
    return {
      "timestamp":
          DateTime.fromMillisecondsSinceEpoch(timestamp).toIso8601String(),
      "type": type.title,
      "message": message,
      if (className?.isNotEmpty ?? false) "class_name": className,
      if (methodName?.isNotEmpty ?? false) "method_name": methodName,
      if (error?.isNotEmpty ?? false) "error": error,
      if (stackTrace?.isNotEmpty ?? false)
        "stack_trace": stackTrace?.trim().split('\n') ?? [],
    };
  }
}

/// Simple class to hold stack frame information
class _StackFrame {
  final String member;
  final String uri;
  
  _StackFrame({
    required this.member,
    required this.uri,
  });
}
