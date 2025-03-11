import 'package:flutter/material.dart';
import 'package:flutter_fit_utils_ui/fit_text.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lottie/lottie.dart';

/// Default network alert widget. To show when there is no internet connections available.
class NetworkAlert extends StatelessWidget {
  static const String _defaultTitle = "Whoops!";
  static const String _defaultMessage = "An internet connection is required to use the app. Come back later !";

  /// Title of the error.
  final String title;

  /// Message of the error.
  final String message;

  final TextDirection textDirection;

  final ThemeData? themeData;

  /// Creates a new [NetworkAlert].
  const NetworkAlert({
    super.key,
    this.title = _defaultTitle,
    this.message = _defaultMessage,
    this.textDirection = TextDirection.ltr,
    this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Directionality(
      textDirection: textDirection,
      child: Theme(
        data: themeData ?? ThemeData(),
        child: Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/wifi.json"),
                FitText.headline(title, padding: const EdgeInsets.only(bottom: 6)),
                FitText.body(
                  message,
                  textAlign: TextAlign.center,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}