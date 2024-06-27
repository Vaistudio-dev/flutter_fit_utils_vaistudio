import 'dart:convert';

import 'package:flutter_fit_utils_config/remote_config.dart';
import 'package:flutter_fit_utils_vaistudio/feature_activation/feature_activation.dart';

class UIConfig extends RemoteConfig {
  static const String _localeKey = "app_localization";
  static const String _showAppBarKey = "show_app_bar";
  static const String _loadingTriesKey = "max_loading_tries";
  static const String _featuresKey = "feature_activation";

  Map<String, String> _appText = {};

  bool showAppBar = true;

  int maxLoadingTries = 1;

  List<FeatureActivation> appFeatures = [];

  @override
  void read() {
    final config = appConfig.getAll();

    if (config.containsKey(_localeKey)) {
      _appText = Map<String, String>.from(
        jsonDecode(appConfig.getString(_localeKey)) as Map<dynamic, dynamic>);
    }
    
    if (config.containsKey(_showAppBarKey)) {
      showAppBar = appConfig.getBool(_showAppBarKey);
    }
    
    if (config.containsKey(_loadingTriesKey)) {
      maxLoadingTries = appConfig.getInt(_loadingTriesKey);
    }
    
    if (config.containsKey(_featuresKey)) {
      appFeatures = (jsonDecode(appConfig.getString(_featuresKey)) as List<dynamic>).map((item) => FeatureActivation.fromJson(item as Map<String, dynamic>)).toList();
    }
  }

  /// Retourne un [String] de [appText].
  String getString(String key,
      {Map<String, String>? placeholders, String? replacementIfNotFound}) {
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
String getString(String key,
        {Map<String, String>? placeholders, String? replacementIfNotFound}) =>
    uiConfig.getString(key,
        placeholders: placeholders,
        replacementIfNotFound: replacementIfNotFound);
