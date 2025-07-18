import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:mamacare/utils/app_exceptions.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  factory NotificationService(FlutterLocalNotificationsPlugin notificationsPlugin) {
    return _instance;
  }

  NotificationService._internal()
      : _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Notification channels
  static const String _pregnancyChannelId = 'pregnancy_channel';
  static const String _vaccinationChannelId = 'vaccination_channel';
  static const String _generalChannelId = 'general_channel';

Future<void> initialize({
    void Function(NotificationResponse)? onNotificationTap,
  }) async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap ?? (details) {
          // Default handling if none provided
          debugPrint('Notification tapped: ${details.payload}');
        },
      );

      await _createNotificationChannels();
    } catch (e) {
      throw NotificationException('Initialization failed: ${e.toString()}');
    }
  }

  Future<void> _createNotificationChannels() async {
    // Android-specific channel creation
    const AndroidNotificationChannel pregnancyChannel = AndroidNotificationChannel(
      _pregnancyChannelId,
      'Pregnancy Reminders',
      description: 'Notifications for pregnancy milestones',
      importance: Importance.high,
      playSound: true,
    );

    const AndroidNotificationChannel vaccinationChannel =
        AndroidNotificationChannel(
      _vaccinationChannelId,
      'Vaccination Reminders',
      description: 'Notifications for vaccination schedules',
      importance: Importance.high,
      playSound: true,
    );

    const AndroidNotificationChannel generalChannel = AndroidNotificationChannel(
      _generalChannelId,
      'General Notifications',
      description: 'General purpose notifications',
      importance: Importance.high,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(pregnancyChannel);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(vaccinationChannel);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(generalChannel);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime date,
    required String channelId,
    required String channelName,
    String? payload,
  }) async {
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(date, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: 'Scheduled $channelName notifications',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
     // uiLocalNotificationDateInterpretation: null, // Can be omitted completely
      payload: payload,
      matchDateTimeComponents: null,
      );
    } catch (e) {
      throw NotificationException(
          'Failed to schedule notification: ${e.toString()}');
    }
  }

  Future<void> schedulePregnancyReminder({
    required int id,
    required String title,
    required String body,
    required DateTime date,
    String? payload,
  }) async {
    await scheduleNotification(
      id: id,
      title: title,
      body: body,
      date: date,
      channelId: _pregnancyChannelId,
      channelName: 'Pregnancy Reminders',
      payload: payload,
    );
  }

  Future<void> scheduleVaccinationReminder({
    required int id,
    required String title,
    required String body,
    required DateTime date,
    String? payload,
  }) async {
    await scheduleNotification(
      id: id,
      title: title,
      body: body,
      date: date,
      channelId: _vaccinationChannelId,
      channelName: 'Vaccination Reminders',
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
    } catch (e) {
      throw NotificationException('Failed to cancel notification: ${e.toString()}');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      throw NotificationException(
          'Failed to cancel all notifications: ${e.toString()}');
    }
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      await _notificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _generalChannelId,
            'General Notifications',
            channelDescription: 'General purpose notifications',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );
    } catch (e) {
      throw NotificationException(
          'Failed to show notification: ${e.toString()}');
    }
  }
}