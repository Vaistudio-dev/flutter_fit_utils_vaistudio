import 'package:flutter/material.dart';

import 'build_version.dart';

/// Provides information about [BuildVersion].
class BuildProvider extends ChangeNotifier {
  /// Current version on the user's device (x.x.x).
  String currentAppVersion = "";

  /// Current build number on the user's device.
  int currentBuild = 0;

  /// Latest build information.
  late BuildVersion buildVersion;

  /// Update status based on the user's version and the
  /// latest available.
  UpdateStatus appUpdateStatus = UpdateStatus.none;

  /// Updates [buildVersion].
  void updateBuild(BuildVersion build) {
    buildVersion = build;
    appUpdateStatus = buildVersion.getAppUpdateStatus(currentBuild);
    notifyListeners();
  }
}