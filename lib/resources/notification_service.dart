import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:money_tracker/models/notification.dart';
import 'package:money_tracker/resources/network_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:money_tracker/resources/user_simple_preferences.dart';
import '../global.dart';

class NotificationConstants {
  static const String channelID = 'my_channel_id';
  static const String channelName = 'my_channel_name';
  static const String channelDescription = 'my_channel_description';
}

class NotificationService {
  final String _urlPrefix = NetworkService.getApiUrl();
  static final NotificationService _singleton = NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _singleton;
  }

  NotificationService._internal() {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/logo'),
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(const AndroidNotificationChannel(
            NotificationConstants.channelID,
            NotificationConstants.channelName,
            description: NotificationConstants.channelDescription,
            importance: Importance.high,
          ));
    }
  }

  Future<void> scheduleMonthlyNotification(
      int day, int hour, int minute, String name, int id) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      NotificationConstants.channelID,
      NotificationConstants.channelName,
      channelDescription: NotificationConstants.channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month + 1, day, hour, minute);
    }

    print('Scheduled Date: $scheduledDate');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Przypomnenie o płatności!',
      'Pamiętaj o zapłacie podatku $name.',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  Future<void> showNotification(
      {required String title, required String body, int id = 0}) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      NotificationConstants.channelID,
      NotificationConstants.channelName,
      channelDescription: NotificationConstants.channelDescription,
      importance: Importance.max,
      priority: Priority.max,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  addNewNotification(MyNotification notification) async {
    Map<String, dynamic> body = {'notification': notification};
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/notification/addNewNotification'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
      body: jsonEncode(body),
    );
    return json.decode(res.body);
  }

  updateNotification(MyNotification notification) async {
    Map<String, dynamic> body = {'notification': notification};
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/notification/updateNotification'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
      body: jsonEncode(body),
    );
    return json.decode(res.body);
  }

  getNotifications(String userId) async {
    final http.Response res = await client.post(
      Uri.parse('$_urlPrefix/notification/$userId/getNotifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': UserSimplePreferences.accessToken
      },
    );
    Map<String, dynamic> cat = json.decode(res.body);
    if (!cat['success']) return [];

    return List<MyNotification>.from(
        cat['notification'].map((u) => MyNotification.fromJson(u)));
  }
}
