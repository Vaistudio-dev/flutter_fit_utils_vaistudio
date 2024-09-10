library flutter_fit_utils_vaistudio;

import 'app_build_info/build_config.dart';
import 'config/developer_config.dart';
import 'config/ui_config.dart';

export 'config/index.dart';
export 'extensions/index.dart';
export 'fcm_provider.dart';
export 'app_build_info/index.dart';
export 'notification_service.dart';
export 'subscription/subscription_provider.dart';
export 'subscription/paywall.dart';
export 'internet_handler/internet_handler.dart';
export 'internet_handler/network_alert.dart';
export 'feature_activation/feature_activation.dart';
export 'feature_activation/feature_activation_handler.dart';
export 'feature_activation/features_extension.dart';
export 'crashlytics.dart';
export 'validation.dart';
export 'checkup.dart';
export 'password_validator.dart';
export 'shortcut/shortcut_service.dart';

/// Initializes the following configs:
/// - UIConfig
/// - DeveloperConfig
Future<void> initConfigs() async {
  await uiConfig.initialize();
  devConfig.read();
  buildConfig.read();
}
