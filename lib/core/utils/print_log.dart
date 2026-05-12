import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    noBoxingByDefault: true,
  ),
);

/// Prints a log message only in debug mode.
///
/// [level] can be: 'd' (debug), 'i' (info), 'w' (warning), 'e' (error).
void printLog(String message, {String level = 'd'}) {
  if (!kDebugMode) return;
  switch (level) {
    case 'i':
      _logger.i(message);
    case 'w':
      _logger.w(message);
    case 'e':
      _logger.e(message);
    default:
      _logger.d(message);
  }
}

/// Prints an error message only in debug mode.
void printError(
  String message, {
  Object? error,
  StackTrace? stackTrace,
}) {
  if (!kDebugMode) return;
  _logger.e(message, error: error, stackTrace: stackTrace);
}
