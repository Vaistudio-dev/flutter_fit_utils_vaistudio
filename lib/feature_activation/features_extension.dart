import 'package:flutter_fit_utils_vaistudio/feature_activation/feature_activation.dart';

/// Extension on the [List<FeatureActivation>] type.
extension FeatureExtension on List<FeatureActivation> {
  /// Returns a feature activation that has a matching id.
  FeatureActivation getById(String id) {
    if (any((element) => element.id == id)) {
      return firstWhere((element) => element.id == id);
    }

    return const FeatureActivation(id: "not found", errorMessageKey: "error");
  }
}