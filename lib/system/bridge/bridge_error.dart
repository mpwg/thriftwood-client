import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Comprehensive error reporting system for bridge operations
/// This system provides detailed, actionable error messages with full context
/// to help developers identify and fix bridge-related issues during development.
class BridgeError extends Error {
  final String operation;
  final String component;
  final String message;
  final dynamic originalError;
  final Map<String, dynamic>? context;
  final StackTrace? originalStackTrace;

  BridgeError({
    required this.operation,
    required this.component,
    required this.message,
    this.originalError,
    this.context,
    this.originalStackTrace,
  });

  /// Create a BridgeError from a PlatformException
  factory BridgeError.fromPlatformException(
    PlatformException e,
    String operation,
    String component, {
    Map<String, dynamic>? context,
  }) {
    return BridgeError(
      operation: operation,
      component: component,
      message: 'Platform channel error: ${e.message ?? "Unknown error"}',
      originalError: e,
      context: {
        'code': e.code,
        'details': e.details?.toString(),
        ...?context,
      },
    );
  }

  /// Create a BridgeError from a generic exception
  factory BridgeError.fromException(
    dynamic e,
    String operation,
    String component, {
    Map<String, dynamic>? context,
    StackTrace? stackTrace,
  }) {
    return BridgeError(
      operation: operation,
      component: component,
      message: 'Bridge operation failed: ${e.toString()}',
      originalError: e,
      context: context,
      originalStackTrace: stackTrace,
    );
  }

  /// Create a BridgeError for type validation failures
  factory BridgeError.typeValidation(
    String operation,
    String component,
    String expectedType,
    dynamic actualValue, {
    String? fieldPath,
    Map<String, dynamic>? context,
  }) {
    final path = fieldPath != null ? ' at path "$fieldPath"' : '';
    return BridgeError(
      operation: operation,
      component: component,
      message:
          'Type validation failed$path: Expected $expectedType, got ${actualValue.runtimeType}',
      context: {
        'expectedType': expectedType,
        'actualType': actualValue.runtimeType.toString(),
        'actualValue': actualValue.toString(),
        if (fieldPath != null) 'fieldPath': fieldPath,
        ...?context,
      },
    );
  }

  /// Create a BridgeError for threading violations
  factory BridgeError.threadingViolation(
    String operation,
    String component,
    String expectedThread,
    String actualThread, {
    Map<String, dynamic>? context,
  }) {
    return BridgeError(
      operation: operation,
      component: component,
      message:
          'Threading violation: Operation must be performed on $expectedThread, but was called from $actualThread',
      context: {
        'expectedThread': expectedThread,
        'actualThread': actualThread,
        ...?context,
      },
    );
  }

  /// Create a BridgeError for channel initialization failures
  factory BridgeError.channelNotInitialized(
    String operation,
    String component,
    String channelName, {
    Map<String, dynamic>? context,
  }) {
    return BridgeError(
      operation: operation,
      component: component,
      message:
          'Method channel "$channelName" not initialized. Ensure bridge initialization completed before calling $operation.',
      context: {
        'channelName': channelName,
        'suggestedFix':
            'Call BridgeInitializer.initialize() during app startup',
        ...?context,
      },
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('❌ BridgeError in $component during $operation:');
    buffer.writeln('   Message: $message');

    if (context != null && context!.isNotEmpty) {
      buffer.writeln('   Context:');
      context!.forEach((key, value) {
        buffer.writeln('     $key: $value');
      });
    }

    if (originalError != null) {
      buffer.writeln('   Original Error: $originalError');
    }

    if (kDebugMode && originalStackTrace != null) {
      buffer.writeln('   Stack Trace:');
      buffer.writeln(
          originalStackTrace.toString().split('\n').take(10).join('\n'));
    }

    return buffer.toString();
  }

  /// Get a user-friendly error message suitable for UI display
  String get userMessage {
    switch (component) {
      case 'HiveBridge':
        return 'Failed to sync data with local storage. Please try again.';
      case 'FlutterSwiftUIBridge':
        return 'Navigation error occurred. Please restart the app if the problem persists.';
      case 'NativeBridge':
        return 'Unable to access native features. Some functionality may be limited.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Get actionable debugging information for developers
  String get debugInfo {
    final suggestions = <String>[];

    // Add specific suggestions based on error type and context
    if (message.contains('Type validation failed')) {
      suggestions
          .add('Check the data types being passed between Flutter and Swift');
      suggestions.add('Verify the JSON serialization/deserialization logic');
    }

    if (message.contains('Threading violation')) {
      suggestions
          .add('Ensure all method channel calls are made on the main thread');
      suggestions
          .add('Use @MainActor or DispatchQueue.main.async in Swift code');
    }

    if (message.contains('channel') && message.contains('not initialized')) {
      suggestions.add(
          'Verify BridgeInitializer.initialize() is called during app startup');
      suggestions
          .add('Check that the method channel name matches on both sides');
    }

    if (originalError is PlatformException) {
      final platformError = originalError as PlatformException;
      if (platformError.code == 'UNIMPLEMENTED') {
        suggestions
            .add('The requested method is not implemented on the native side');
        suggestions
            .add('Check if the native bridge handler includes this method');
      }
    }

    final buffer = StringBuffer();
    buffer.writeln('🔧 Debug Information:');
    if (suggestions.isNotEmpty) {
      buffer.writeln('   Suggestions:');
      for (final suggestion in suggestions) {
        buffer.writeln('   • $suggestion');
      }
    }

    return buffer.toString();
  }
}

/// Error reporter utility for consistent error handling across the bridge system
class BridgeErrorReporter {
  static void report(BridgeError error) {
    // Always log the full error details
    debugPrint(error.toString());

    if (kDebugMode) {
      // In debug mode, also print debugging suggestions
      debugPrint(error.debugInfo);
    }

    // TODO: In production, could integrate with crash reporting services
    // like Firebase Crashlytics or Sentry here
  }

  /// Report a platform exception with enhanced context
  static void reportPlatformException(
    PlatformException e,
    String operation,
    String component, {
    Map<String, dynamic>? context,
  }) {
    final error = BridgeError.fromPlatformException(e, operation, component,
        context: context);
    report(error);
  }

  /// Report a generic exception with enhanced context
  static void reportException(
    dynamic e,
    String operation,
    String component, {
    Map<String, dynamic>? context,
    StackTrace? stackTrace,
  }) {
    final error = BridgeError.fromException(e, operation, component,
        context: context, stackTrace: stackTrace);
    report(error);
  }
}
