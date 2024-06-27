import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fit_utils_config/remote_config.dart';

class DeveloperConfig extends RemoteConfig {
  static const String _developerListKey = "devs";

  List<String> _developerList = [];

  @override
  void read() {
    final config = appConfig.getAll();

    if (config.containsKey(_developerListKey)) {
      _developerList = readStringList(_developerListKey);
    }
  }

  /// Returns [true] if the current's user email is in the developper list.
  bool isDevelopper() => _developerList
      .contains(FirebaseAuth.instance.currentUser?.email?.toLowerCase() ?? "");
}

final DeveloperConfig devConfig = DeveloperConfig();
