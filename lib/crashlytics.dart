import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Active le module Firebase Crashlytics.
/// Enables Firebase Crashlytics for the app.
/// If [alwaysShowErrorWidget] is [true], the error widget will also be shown in debug.
void enabledCrashlytics(Widget errorWidget, {bool alwaysShowErrorWidget = false}) {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (kDebugMode && !alwaysShowErrorWidget) {
      return ErrorWidget(details.exception);
    }
    return errorWidget;
  };
}