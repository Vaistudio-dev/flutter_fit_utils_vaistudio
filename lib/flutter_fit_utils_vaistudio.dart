library flutter_fit_utils_vaistudio;

import 'config/developer_config.dart';
import 'config/ui_config.dart';

export 'config/index.dart';
export 'extensions/index.dart';
export 'fcm_provider.dart';

/// Initializes the following configs:
/// - UIConfig
/// - DeveloperConfig
Future<void> initConfigs() async {
  await uiConfig.initialize();
  devConfig.read();
}