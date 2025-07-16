import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mamacare/services/auth_service.dart';
import 'package:mamacare/services/database_service.dart';
import 'package:mamacare/services/location_service.dart';
import 'package:mamacare/services/notification_service.dart';
import 'package:mamacare/services/sync_service.dart';

class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._internal();

  factory ServiceProvider() => _instance;

  ServiceProvider._internal();

  Future<void> initialize() async {
    // Initialize all services
    await _initializeHive();
    await _initializeNotifications();
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    // Register all adapters here
    // Hive.registerAdapter(UserAdapter());
    // ... other adapters
  }

  Future<void> _initializeNotifications() async {
    final notificationsPlugin = FlutterLocalNotificationsPlugin();
    await NotificationService(notificationsPlugin).initialize();
  }

  AuthService get authService => AuthService();
  DatabaseService get databaseService => DatabaseService();
  LocationService get locationService => LocationService();
  NotificationService get notificationService =>
      NotificationService(FlutterLocalNotificationsPlugin());
  SyncService get syncService => SyncService(apiBaseUrl: 'https://api.mamacare.org');
}