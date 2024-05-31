import 'dart:convert';

import 'package:flutter_fit_utils/model/model.dart';
import 'package:flutter_fit_utils_config/remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../flutter_fit_utils_vaistudio.dart';

/// Configuration for the app's build information.
class BuildConfig extends RemoteConfig {
  /// Name of the parameter for the build information.
  static const String versionKey = "build_version";

  String currentAppVersion = "";
  int currentBuild = 0;

  BuildVersion? latestBuildInformation;

  @override
  void read() {
    latestBuildInformation = BuildVersion.fromModel(Model.fromJson(
        jsonDecode(appConfig.getString(versionKey)) as Map<String, dynamic>));
  }

  /// Reads the current app version on the device and sends the data to the [BuildProvider].
  Future<void> getCurrentVersion(BuildProvider buildProvider) async {
    final PackageInfo package = await PackageInfo.fromPlatform();
    buildProvider.currentAppVersion = package.version;
    buildProvider.currentBuild = int.parse(package.buildNumber);

    if (latestBuildInformation == null) {
      read();
    }

    buildProvider.updateBuild(latestBuildInformation!);
  }
}
