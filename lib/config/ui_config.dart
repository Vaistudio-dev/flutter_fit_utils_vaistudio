import 'dart:convert';

import 'package:flutter_fit_utils_config/remote_config.dart';

class UIConfig extends RemoteConfig {
  static const String _localeKey = "app_localization";
  static const String _showAppBarKey = "show_app_bar";
  static const String _loadingTriesKey = "max_loading_tries";

  Map<String, String> _appText = {};

  bool showAppBar = true;

  int maxLoadingTries = 1;

  @override
  void read() {
    _appText = Map<String, String>.from(jsonDecode(appConfig.getString(_localeKey)) as Map<dynamic, dynamic>);
    showAppBar = appConfig.getBool(_showAppBarKey);
    maxLoadingTries = appConfig.getInt(_loadingTriesKey);
  }

  /// Retourne un [String] de [appText].
  String getString(String key, {Map<String, String>? placeholders, String? replacementIfNotFound}) {
    String result = _appText[key] ?? key;

    if (result == key && replacementIfNotFound != null) {
      result = replacementIfNotFound;
    }

    if (placeholders != null && placeholders.isNotEmpty) {
      for (final String key in placeholders.keys) {
        result = result.replaceAll("*$key*", placeholders[key]!);
      }
    }

    return result;
  }
}

/// UIConfig of the app.
final UIConfig uiConfig = UIConfig();

/// Returns a localized [String] for the UI.
String getString(String key, {Map<String, String>? placeholders, String? replacementIfNotFound}) => uiConfig.getString(key, placeholders: placeholders, replacementIfNotFound: replacementIfNotFound);
