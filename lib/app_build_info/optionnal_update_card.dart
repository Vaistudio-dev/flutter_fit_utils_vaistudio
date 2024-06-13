import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fit_utils_ui/fit_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../flutter_fit_utils_vaistudio.dart';

/// Widget that shows the user that there is an optionnal update available.
class OptionnalUpdateCard extends StatelessWidget {
  static const String _defaultText = "There is an update available";

  /// Text displayed on the card.
  final String text;

  /// Creates a new [OptionnalUpdateCard].
  const OptionnalUpdateCard({
    super.key,
    this.text = _defaultText,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final ThemeData theme = Theme.of(context);

        BuildConfig buildConfig = BuildConfig();
        buildConfig.read();

        if (context.watchBuild.appUpdateStatus != UpdateStatus.optionnal ||
            buildConfig.storeUrl.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          color: theme.colorScheme.primary,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              launchUrl(
                Uri.parse(buildConfig.storeUrl),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(CupertinoIcons.arrow_up_right_diamond_fill,
                      color: theme.colorScheme.onPrimary),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FitText.title(
                        text,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    CupertinoIcons.right_chevron,
                    size: 20,
                    color: theme.colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
