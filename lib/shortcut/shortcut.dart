import 'dart:io';

import 'package:flutter_fit_utils/flutter_fit_utils.dart';
import 'package:quick_actions/quick_actions.dart';

import '../config/ui_config.dart';

/// Représente un shortcut de l'application accessible depuis
/// le menu d'un téléphone.
class Shortcut extends Modelable {
  static const String _stringKey = "string_key";
  static const String _routeKey = "route";
  static const String _menuIndexKey = "menu_page_index";
  static const String _iosIconKey = "ios_icon";
  static const String _androidIconKey = "android_icon";

  /// Titre du shortcut.
  final String stringKey;
  /// Route du shortcut.
  /// Lorsque l'app va ouvrir, elle va naviguer vers cette route.
  final String route;
  /// Index de la page du menu à ouvrir.
  /// Par défaut: 0.
  final int menuIndex;

  /// Icone pour la version iOS.
  final String? iosIcon;
  /// Icone pour la version android.
  final String? androidIcon;

  /// Créer un instance depuis un [Model].
  Shortcut.fromModel(super.model) :
    stringKey = model.data[_stringKey].toString(),
    route = model.data[_routeKey]?.toString() ?? "",
    menuIndex = (model.data[_menuIndexKey]?.toInt() ?? 0) as int,
    iosIcon = model.data[_iosIconKey]?.toString(),
    androidIcon = model.data[_androidIconKey]?.toString(),
    super.fromModel();

  /// Convertit l'instance en [ShortcutItem] pour le package quick_actions.
  ShortcutItem toShortcutItem() => ShortcutItem(
    type: id,
    localizedTitle: getString(stringKey),
    icon: Platform.isIOS ? iosIcon : androidIcon,
  );

  @override
  Modelable copyWith({String? id, String? userId, bool? invalid = false}) {
    throw UnimplementedError();
  }

  @override
  Model toModel() {
    throw UnimplementedError();
  }
}