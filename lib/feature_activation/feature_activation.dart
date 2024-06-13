import 'package:flutter/cupertino.dart';
import 'package:flutter_fit_utils_vaistudio/flutter_fit_utils_vaistudio.dart';

/// Represents the state of activation of a feature of the app.
class FeatureActivation {
  static const String _idKey = "id";
  static const String _visibleKey = "visible";
  static const String _enabledKey = "enabled";
  static const String _needsEntitlementKey = "needs_entitlement";
  static const String _errorMessageKey = "error_message";

  /// Id of the feature.
  final String id;

  /// Returns [true] if the feature should be visible.
  final bool visible;

  /// Returns [true] if the feature should be enabled. Which means that it can be used.
  final bool enabled;

  /// Returns [true] if a user needs a premium access to use the feaature.
  final bool needsEntitlement;

  /// Error message to show to a non-premium user when he tries to use a restricted feature.
  final String errorMessageKey;

  /// Creates a new [FeatureActivation].
  const FeatureActivation({this.id = "", this.visible = false, this.enabled = false, this.needsEntitlement = false, this.errorMessageKey = "featureNotAvailable"});

  /// Returns [true] if the current user is allowed to use this feature.
  bool isEnabledForUser(BuildContext context) {
    if (needsEntitlement) {
      return enabled && context.subscriptionProvider.isEntitlementActive;
    }
    return enabled;
  }

  /// Creates a [FeatureActivation] from json.
  FeatureActivation.fromJson(Map<String, dynamic> model) :
    id = model[_idKey].toString(),
    visible = model[_visibleKey] as bool,
    enabled = model[_enabledKey] as bool,
    needsEntitlement = model[_needsEntitlementKey]?.toString().toLowerCase() == "true",
    errorMessageKey = model[_errorMessageKey]?.toString() ?? "featureNotAvailable";
}