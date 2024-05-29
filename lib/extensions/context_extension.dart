import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../flutter_fit_utils_vaistudio.dart';

extension VaiStudioContextxtension on BuildContext {
  /// Accès au module FCM.
  FCMProvider get fcm => read<FCMProvider>();
  /// Accès au module FCM.
  FCMProvider get watchFcm => watch<FCMProvider>();
}