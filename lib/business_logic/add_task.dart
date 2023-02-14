import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scool_home_working/controllers/ad_controller.dart';
import 'package:scool_home_working/controllers/app_controller.dart';
import 'package:scool_home_working/models/dialog.dart';
import 'package:scool_home_working/models/task_model.dart';
import 'package:scool_home_working/screens/new_task.dart';
import 'package:scool_home_working/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future addNewTask(
    {int noticeID = 0,
    bool isImportantTaskEnable = false,
    bool isNotificationEnable = false,
    required DateTime selectedDate,
    required TextEditingController titleController,
    required TextEditingController taskController,
    required DateTime selectedDateNotification,
    required TimeOfDay selectedTimeNotification,
    required Color pickerColor}) async {
  final AppController appController = Get.find();

  if (isNotificationEnable) {
    await AdController().showInterstitialAd(() {});
  }

  if (NewTask.taskForChange == null) {
    appController.tasks.add(Task(
        notificationId: noticeID,
        importantTask: isImportantTaskEnable,
        date: selectedDate,
        titleTask: titleController.text,
        task: taskController.text,
        taskTitleColor: pickerColor));
  } else {
    if (!isNotificationEnable) {
      LocalNoticeService()
          .localNotificationsPlugin
          .cancel(NewTask.taskForChange?.notificationId ?? 0);
    }

    appController.tasks[appController.tasks.indexOf(NewTask.taskForChange)] =
        Task(
            notificationId: noticeID,
            importantTask: isImportantTaskEnable,
            date: selectedDate,
            titleTask: titleController.text,
            task: taskController.text,
            taskTitleColor: pickerColor);
  }

  if (isNotificationEnable) {
    DateTime dateForNotification = DateTime(
        DateTime.now().year,
        selectedDateNotification.month,
        selectedDateNotification.day,
        selectedTimeNotification.hour,
        selectedTimeNotification.minute);

    LocalNoticeService().addNotification(
      id: noticeID,
      title: 'Homeworks',
      body: "${'systemNotification_Remind'.tr} \"${titleController.text}\"",
      endTime: dateForNotification.millisecondsSinceEpoch,
      channel: 'work-end',
    );
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String encodedData = Task.encode(appController.tasks.toList());
  await prefs.setString('task', encodedData);

  if (NewTask.taskForChange == null) {
    dialog(
        title: 'notification_TitleNotification'.tr,
        content: 'newTask_notificationTaskAdded'.tr);
  } else {
    dialog(
        title: 'notification_TitleNotification'.tr,
        content: 'newTask_notificationTaskChanged'.tr);
  }
}
