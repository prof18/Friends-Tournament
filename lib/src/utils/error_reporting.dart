/*
 * Copyright 2020 Marco Gomiero
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */




Future<void> reportError(dynamic error, dynamic stackTrace) async {
  // TODO: migrate to crashlytics
  // var sentry = SentryClient(dsn: dsn);
  // // Print the exception to the console.
  // print('Caught error: $error');
  // if (isInDebugMode) {
  //   // Print the full stacktrace in debug mode.
  //   print(stackTrace);
  // } else {
  //   // Send the Exception and Stacktrace to Sentry in Production mode.
  //   sentry.captureException(
  //     exception: error,
  //     stackTrace: stackTrace,
  //   );
  // }
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