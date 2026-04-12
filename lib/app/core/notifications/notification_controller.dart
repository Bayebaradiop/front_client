import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../constante_Endpoit/api_endpoints.dart';
import '../api/api_service.dart';
import '../../routes/app_routes.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final _storage = GetStorage();

  final fcmToken = ''.obs;
  final isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();

    // Get and display FCM token for testing
    final token = await getToken();
    debugPrint('═' * 80);
    debugPrint('📱 FCM Token: $token');
    debugPrint('═' * 80);

    isInitialized.value = true;
  }

  Future<void> _requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _messaging.requestPermission();
  }

  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      fcmToken.value = token ?? '';
      return token;
    } catch (e) {
      debugPrint('[FCM] Error getting token: $e');
      return null;
    }
  }

  Future<void> sendTokenToBackend(String token) async {
    try {
      final api = Get.find<ApiService>();
      await api.put(ApiEndpoints.fcmToken, {'fcmToken': token});
      debugPrint('[FCM] Token sent to backend successfully');
    } catch (e) {
      debugPrint('[FCM] Error sending token to backend: $e');
    }
  }

  Future<void> saveFcmToken() async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      await sendTokenToBackend(token);
      _storage.write('fcm_token', token);
    }
  }

  void setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    debugPrint(
      '[FCM] Foreground message received: ${message.notification?.title}',
    );

    final data = message.data;
    final type = data['type'];

    if (type == 'APPOINTMENT_REMINDER') {
      await _showLocalNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'Rappel de rendez-vous',
        body: 'Vous avez un rendez-vous prévu bientôt',
        payload: jsonEncode(data),
      );
    }
  }

  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'medibook_reminders',
      'Rappels de rendez-vous',
      channelDescription: 'Notifications pour les rappels de rendez-vous',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        _handleNotificationNavigation(data);
      } catch (e) {
        debugPrint('[FCM] Error parsing notification payload: $e');
      }
    }
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    final type = data['type'];

    if (type == 'APPOINTMENT_REMINDER') {
      final rdvId = data['rdvId'];
      final cabinetId = data['cabinetId'];

      if (rdvId != null) {
        Get.toNamed(AppRoutes.rdvDetail, arguments: {'rdvId': rdvId});
      }
    }
  }

  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    debugPrint('[FCM] Background message: ${message.notification?.title}');
  }
}
