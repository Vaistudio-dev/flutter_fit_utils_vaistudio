import 'package:flutter_fit_utils/model/model.dart';

/// App build version info.
/// Provides information about the latest available version
/// and the minimum required version to use the app.
class BuildVersion {
  static const String _minBuildKey = "min_build";
  static const String _deployedBuildKey = "deployed_build";

  /// Minimum build required to use the app.
  final int minBuild;

  /// Latest build available to users.
  final int deployedBuild;

  /// Creates an instance from a [Model].
  BuildVersion.fromModel(Model model)
      : minBuild = model.data[_minBuildKey].toInt() as int,
        deployedBuild = model.data[_deployedBuildKey].toInt() as int;

  /// Returns the [UpdateStatus] based off the user's current version, the minimum build and the latest build.
  UpdateStatus getAppUpdateStatus(int currentBuild) {
    if (currentBuild < minBuild) {
      return UpdateStatus.mandatory;
    }

    if (currentBuild < deployedBuild) {
      return UpdateStatus.optionnal;
    }

    return UpdateStatus.none;
  }
}

/// App update status.
/// Used to notify the user for required or suggested updates.
enum UpdateStatus {
  /// Mandatory update.
  /// Access to the app should be blocked until the user
  /// updates the app.
  mandatory,

  /// Optionnal update. An update is available but not required.
  /// A little notice should be sent to the user to let them know
  /// there is an update available.
  optionnal,

  /// The user is up to date.
  none,
}
