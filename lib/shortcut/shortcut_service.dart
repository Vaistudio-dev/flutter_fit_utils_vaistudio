import 'package:flutter_fit_utils_vaistudio/shortcut/shortcut.dart';
import 'package:flutter_fit_utils_vaistudio/shortcut/shortcut_config.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_actions/quick_actions.dart';

/// Service des shortcuts de l'application.
/// Home Screen quick actions pour iOS.
/// App Shortcuts pour Android.
class ShortcutService {
  static final ShortcutService _singleton = ShortcutService._internal();

  late GoRouter router;

  factory ShortcutService() {
    return _singleton;
  }

  ShortcutService._internal();

  void initialize(GoRouter router) {
    this.router = router;


  }

  /// Détecte si l'application a été lançé depuis un shortcut.
  /// Si oui, exécuté le shortcut.
  void executeShortcut() {
    const QuickActions().initialize((type) {
      final List<Shortcut> availableShortcuts = _getAvailableShortcuts();
      if (!availableShortcuts.any((element) => element.id == type)) {
        return;
      }

      final clickedShortcut = availableShortcuts.firstWhere((element) => element.id == type);

      if (clickedShortcut.route.isNotEmpty) {
        router.push(clickedShortcut.route);
        return;
      }

      if (clickedShortcut.menuIndex != 0) {
        router.pushReplacement("/", extra: clickedShortcut.menuIndex);
      }
    });
  }

  /// Établie les shortcuts disponible.
  static void setAvailableShortcuts() {
    const QuickActions().setShortcutItems(_getAvailableShortcuts().map((e) => e.toShortcutItem()).toList());
  }


  static List<Shortcut> _getAvailableShortcuts() {
    ShortcutConfig().read();
    return ShortcutConfig().availableShortcuts;
  }
}