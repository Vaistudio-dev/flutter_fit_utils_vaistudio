import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

/// Local notification service for android and iOS.
class NotificationService {
  /// Gestionnaire des notifications.
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification service.
  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings("ic_notification");
    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );

    tz.initializeTimeZones();
  }

  /// Ask permission to the user to send notifications.
  static Future<bool?>? getPermission() {
    if (Platform.isIOS) {
      return notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isMacOS) {
      return notifications
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else {
      return notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
  }

  /// Returns template notifications details.
  static NotificationDetails getBasicNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails("VaiStudio", "VaiStudio",
          importance: Importance.max),
      iOS: DarwinNotificationDetails(),
    );
  }

  /// Shows a basic notification.
  static Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      NotificationDetails? notificationDetails}) async {
    return notifications.show(
        id, title, body, notificationDetails ?? getBasicNotificationDetails(),
        payload: payload);
  }

  /// Shows a notification with a live progress.
  /// IMPORTANT: Supported on Android only.
  static Future<void> showCountdownNotification(int countdown,
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      AndroidNotificationDetails? androidNotificationDetails,
      String channelId = "VaiStudio",
      String channelName = "Progress VaiStudio"}) async {
    if (!Platform.isAndroid) {
      return;
    }

    androidNotificationDetails ??= AndroidNotificationDetails(
      channelId,
      channelName,
      onlyAlertOnce: true,
      priority: Priority.min,
      importance: Importance.min,
      playSound: false,
      enableVibration: false,
      when: DateTime.now().millisecondsSinceEpoch + countdown * 1000,
      usesChronometer: true,
      chronometerCountDown: true,
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await notifications.show(id, title, body, notificationDetails,
        payload: payload);
  }

  /// Programme l'affichage d'une notification à un temps précis.
  static Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate,
      bool showEveryDay = false,
      NotificationDetails? notificationDetails}) async {
    return notifications.zonedSchedule(
      id,
      title,
      body,
      TZDateTime.from(scheduledDate, local),
      notificationDetails ?? getBasicNotificationDetails(),
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: showEveryDay ? DateTimeComponents.time : null,
    );
  }
}
