import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> reportError(dynamic exception, StackTrace? stackTrace, String reason) async {
  if (isInDebugMode) {
    print(exception);
    print(stackTrace);
  } else {
    await FirebaseCrashlytics.instance.recordError(
        exception,
        stackTrace,
        reason: reason
    );
  }
}

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}