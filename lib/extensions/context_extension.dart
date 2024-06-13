import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../flutter_fit_utils_vaistudio.dart';

extension VaiStudioContextxtension on BuildContext {
  /// Access to the FCM provider.
  FCMProvider get fcm => read<FCMProvider>();

  /// Access to the FCM provider.
  FCMProvider get watchFcm => watch<FCMProvider>();

  /// Access to the build informations.
  BuildProvider get build => read<BuildProvider>();

  /// Access to the build informations.
  BuildProvider get watchBuild => watch<BuildProvider>();

  /// Access to the subscription provider.
  SubscriptionProvider get subscriptionProvider => read<SubscriptionProvider>();

  /// Access to the subscription provider.
  SubscriptionProvider get watchSubscriptionProvider =>
      watch<SubscriptionProvider>();
}
