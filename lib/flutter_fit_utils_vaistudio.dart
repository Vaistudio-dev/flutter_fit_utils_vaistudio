library flutter_fit_utils_vaistudio;

import 'config/developer_config.dart';
import 'config/ui_config.dart';

export 'config/index.dart';
export 'extensions/index.dart';
export 'fcm_provider.dart';
export 'app_build_info/index.dart';
export 'notification_service.dart';
export 'subscription/subscription_provider.dart';
export 'subscription/paywall.dart';

/// Initializes the following configs:
/// - UIConfig
/// - DeveloperConfig
Future<void> initConfigs() async {
  await uiConfig.initialize();
  devConfig.read();
}
