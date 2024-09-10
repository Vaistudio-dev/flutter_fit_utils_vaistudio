import 'dart:convert';

import 'package:flutter_fit_utils/model/model.dart';
import 'package:flutter_fit_utils_config/remote_config.dart';
import 'package:flutter_fit_utils_vaistudio/shortcut/shortcut.dart';

class ShortcutConfig extends RemoteConfig {
  static const String _configKey = "shortcuts";

  List<Shortcut> availableShortcuts = [];

  static final ShortcutConfig _singleton = ShortcutConfig._internal();

  factory ShortcutConfig() {
    return _singleton;
  }

  ShortcutConfig._internal();

  @override
  void read() {
    availableShortcuts = (jsonDecode(appConfig.getString(_configKey)) as List<dynamic>).map((e) => Shortcut.fromModel(Model.fromJson(e as Map<String, dynamic>))).toList();
  }
}