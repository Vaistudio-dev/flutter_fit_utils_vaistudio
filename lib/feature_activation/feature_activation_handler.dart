import 'package:flutter/material.dart';
import 'package:flutter_fit_utils_ui/flutter_fit_utils_ui.dart';
import 'package:flutter_fit_utils_vaistudio/flutter_fit_utils_vaistudio.dart';

/// Widget that alters the visibility of it's child, based on if the user is authorized to see it.
/// It depends on the general activation of the feature, or if the user has a premium access.
class FeatureActivationHandler extends StatelessWidget {
  /// Id of the feature to manage.
  final String featureId;
  /// Feature to display.
  final Widget child;

  /// Creates a new [FeatureActivationHandler].
  const FeatureActivationHandler({super.key, required this.featureId, required this.child});

  @override
  Widget build(BuildContext context) {
    final FeatureActivation feature = uiConfig.appFeatures.getById(featureId);
    final bool isEnabledForUser = feature.isEnabledForUser(context);

    return feature.visible ? GestureDetector(
      onTap: () {
        if (isEnabledForUser) return;

        if (feature.errorMessageKey == "subscriptionError" && context.subscriptionProvider.onRestrictedAccess != null) {
          context.subscriptionProvider.onRestrictedAccess!(context);
          return;
        }
        context.showSnackbar(getString(feature.errorMessageKey));
      },
      child: AbsorbPointer(
        absorbing: !isEnabledForUser,
        child: child,
      ),
    ) : const SizedBox(height: 0, width: 0);
  }
}