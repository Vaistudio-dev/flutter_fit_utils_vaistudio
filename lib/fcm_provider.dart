import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Service de gestion du module Firebase Cloud Messaging.
class FCMProvider extends ChangeNotifier {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Callback a effectuer lorsque le token fcm change et n'est plus le même
  /// que celui fourni dans [initialize].
  Function(String)? onUpdateToken;

  /// Initialise le module FCM.
  /// [token]: le token FCM de l'utilisateur.
  /// [onMessage]: callback a appelé lorsqu'on recoit un message.
  /// [onUpdateToken]: callback a appelé si [token] est différent du token du module.
  Future<void> initialize({required String token, required Future<void> Function(RemoteMessage) onMessage, required Function(String) onUpdateToken}) async {
    await _fcm.requestPermission();

    final String? fcmToken = await _fcm.getToken();
    if (fcmToken != null && token != fcmToken) {
      onUpdateToken(fcmToken);
    }

    await _initializePushNotifications(onMessage);
  }

  Future<void> _initializePushNotifications(Future<void> Function(RemoteMessage) onMessage) async {
    await _fcm.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    _fcm.getInitialMessage().then(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(onMessage);
    FirebaseMessaging.onMessage.listen(onMessage);
  }
}

void _handleMessage(RemoteMessage? message) {
  if (message == null || message.notification == null) return;

  if (kDebugMode) {
    print(message.messageId);
    print(message.notification!.title ?? "NO TITLE");
    print(message.notification!.body ?? "NO BODY");
  }
}