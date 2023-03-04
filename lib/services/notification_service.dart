import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:scool_home_working/controllers/app_controller.dart';
import 'package:scool_home_working/main.dart';
import 'package:scool_home_working/screens/task_details.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class LocalNoticeService {
  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSetting);

    await localNotificationsPlugin
        .initialize(initSettings,
            onDidReceiveNotificationResponse: (value) => handlePress(value))
        .then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  void handlePress(NotificationResponse value) {
    final AppController appController = Get.find();
    appController.taskIdFromNotification.value = int.parse(value.payload!);
  }

  Future<void> addNotification(
      {String title = '',
      String body = '',
      int id = 0,
      int endTime = 0,
      String channel = ''}) async {
    tzData.initializeTimeZones();
    final scheduleTime =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);

    final androidDetail = AndroidNotificationDetails(channel, channel);

    final noticeDetail = NotificationDetails(
      android: androidDetail,
    );

    await localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      noticeDetail,
      payload: id.toString(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
