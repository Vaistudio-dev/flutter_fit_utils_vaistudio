import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fit_utils_ui/fit_button.dart';
import 'package:flutter_fit_utils_ui/fit_text.dart';
import 'package:flutter_fit_utils_vaistudio/flutter_fit_utils_vaistudio.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget that shows the user that he must update the app in order to continue
/// using it.
class MandatoryUpdate extends StatelessWidget {
  static const String _defaultTitle = "Update Required";
  static const String _defaultText =
      "Update the app to get the latest features";
  static const String _defaultButtonText = "Update Now";

  /// Title of the message.
  final String title;

  /// Text to explain to the user that he must update the app.
  final String text;

  /// Text for the button to redirect to the store page.
  final String buttonText;

  /// Creates a new [MandatoryUpdate].
  const MandatoryUpdate({
    super.key,
    this.title = _defaultTitle,
    this.text = _defaultText,
    this.buttonText = _defaultButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final BuildConfig buildConfig = BuildConfig();
    buildConfig.read();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FitText.headline(
              title,
              alignment: Alignment.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 32.0),
            Icon(
              CupertinoIcons.arrow_up_right_diamond_fill,
              size: 160,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (buildConfig.storeUrl.isNotEmpty)
              FitButton(
                onTap: () {
                  launchUrl(
                    Uri.parse(buildConfig.storeUrl),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: FitText.button(buttonText),
              ),
          ],
        ),
      ),
    );
  }
}
