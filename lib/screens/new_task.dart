import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scool_home_working/business/add_task.dart';
import 'package:scool_home_working/business/user_account.dart';
import 'package:scool_home_working/models/dialog.dart';
import 'package:scool_home_working/models/task_model.dart';
import 'package:scool_home_working/screens/subscription_overview.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import 'dart:ui' as ui;
import '../controllers/app_controller.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  static Task? taskForChange;

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  late DateTime? selectedDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  final AppController appController = Get.find();

  bool isNotificationEnable = false;
  bool isWarningEnable = false;
  bool isImportantTaskEnable = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController taskController = TextEditingController();

  Color pickerColor = Colors.grey.shade800;
  Color currentColor = Colors.black87;

  DateTime? selectedDateNotification = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  TimeOfDay? selectedTimeNotification = TimeOfDay.now();

  List<String> subjects = [
    'Algebra'.tr,
    'Astronomy'.tr,
    'Biology'.tr,
    'Geography'.tr,
    'Geometry'.tr,
    'NaturalSciences'.tr,
    'Drawing'.tr,
    'ForeignLanguage'.tr,
    'Informatics'.tr,
    'History'.tr,
    'LocalHistory'.tr,
    'Literature'.tr,
    'Maths'.tr,
    'WorldArt'.tr,
    'Music'.tr,
    'BasicMilitaryTraining'.tr,
    'SociallyUsefulWork'.tr,
    'SocialScience'.tr,
    'World'.tr,
    'LifeSafetyFundamentals'.tr,
    'FundamentalsOfFinancialLiteracy'.tr,
    'FundamentalsOfEconomics'.tr,
    'Design'.tr,
    'Psychotraining'.tr,
    'Rhetoric'.tr,
    'NativeLiterature'.tr,
    'NativeLanguage'.tr,
    'RussianLanguage'.tr,
    'EnglishLanguage'.tr,
    'Statistics'.tr,
    'Technology'.tr,
    'Physics'.tr,
    'PhysicalTraining'.tr,
    'Philosophy'.tr,
    'Chemistry'.tr,
    'Painting'.tr,
    'Ecology'.tr
  ];

  Future selectDateAndTime(BuildContext context) async {
    selectedDateNotification = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: Get.locale,
      helpText: 'newTask_datePicker_helpText'.tr,
      cancelText: 'newTask_datePicker_cancelText'.tr,
      confirmText: 'newTask_datePicker_confirmText'.tr,
      fieldLabelText: 'newTask_datePicker_fieldLabelText'.tr,
      fieldHintText: 'newTask_datePicker_fieldHintText'.tr,
    );

    if (selectedDate != null) {
      // ignore: use_build_context_synchronously
      selectedTimeNotification = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: 'newTask_timePicker_helpText'.tr,
        cancelText: 'newTask_datePicker_cancelText'.tr,
        confirmText: 'newTask_datePicker_confirmText'.tr,
        minuteLabelText: 'newTask_timePicker_minuteLabelText'.tr,
        hourLabelText: 'newTask_timePicker_hourLabelText'.tr,
      );
    }

    if (selectedDateNotification == null || selectedTimeNotification == null) {
      selectedDateNotification = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
      selectedTimeNotification = TimeOfDay.now();
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    if (NewTask.taskForChange != null) {
      titleController.text = NewTask.taskForChange!.titleTask;
      taskController.text = NewTask.taskForChange!.task;
      selectedDate = NewTask.taskForChange!.date;
      isImportantTaskEnable = NewTask.taskForChange!.importantTask;
      pickerColor = NewTask.taskForChange!.taskTitleColor;
    }

    setState(() {});
  }

  void dismissKeyboardFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onTap: () {
          dismissKeyboardFocus();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              toolbarHeight: 70,
              backgroundColor: Colors.transparent,
              leading: NewTask.taskForChange == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          splashRadius: 25.0,
                          onPressed: () {
                            NewTask.taskForChange = null;
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          icon: const FaIcon(FontAwesomeIcons.arrowLeft,
                              color: Colors.black87, size: 30)),
                    ),
              title: AutoSizeText(
                NewTask.taskForChange != null
                    ? 'editTask_title'.tr
                    : 'newTask_title'.tr,
                minFontSize: 10,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  color: Colors.black87,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: 30.0,
                    width: 120.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: const Color.fromARGB(255, 255, 164, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => const SubcriptionOverview());
                      },
                      child: AutoSizeText(
                        'Homeworks Pro',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                Obx(
                  () => Visibility(
                    visible: !appController.isHomeworksPro.value,
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 15.0, right: 15.0, bottom: 15.0),
                      decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 164, 0),
                              width: 2.5),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: AutoSizeText(
                          'newTask_notConnectedHomeworksProWarning'.tr,
                          minFontSize: 10,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                              color: Colors.black87.withOpacity(0.7),
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 15.0),
                        child: TextField(
                          controller: titleController,
                          style: GoogleFonts.roboto(
                            color: pickerColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                              hintText: 'newTask_textFieldSubject'.tr,
                              hintStyle: GoogleFonts.roboto(
                                color: Colors.black87.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      width: 2.0,
                                      color: Colors.black87.withOpacity(0.4))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      width: 2.5,
                                      color: Colors.black87.withOpacity(0.6)))),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 5.0, bottom: 15.0),
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 25.0,
                              onPressed: () async {
                                await showColorPicker();
                              },
                              icon: Icon(
                                Icons.color_lens_outlined,
                                size: 35,
                                color: pickerColor,
                              )),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 15.0, bottom: 15.0),
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 25.0,
                              onPressed: () async {
                                dismissKeyboardFocus();
                                await modalBottomSheetSubjects();
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.bars,
                                size: 30,
                                color: Colors.grey.shade800,
                              )),
                        )
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15.0),
                  child: SizedBox(
                    height: 200,
                    child: TextField(
                      controller: taskController,
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      style: GoogleFonts.roboto(
                        color: Colors.black87.withOpacity(0.7),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                          hintText: 'newTask_textFieldTask'.tr,
                          hintStyle: GoogleFonts.roboto(
                            color: Colors.black87.withOpacity(0.5),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.black87.withOpacity(0.4))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                  width: 2.5,
                                  color: Colors.black87.withOpacity(0.6)))),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black87.withOpacity(0.4), width: 2.5),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 5.0, bottom: 5.0, right: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.solidFlag,
                                size: 20.0, color: Colors.green),
                            const SizedBox(width: 10.0),
                            Text(
                              '${'newTask_date'.tr} ${DateFormat.MMMMd(ui.window.locale.toString()).format(selectedDate!)}',
                              style: GoogleFonts.roboto(
                                  color: Colors.black87.withOpacity(0.7),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            splashRadius: 25.0,
                            onPressed: () async {
                              dismissKeyboardFocus();

                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2100),
                                locale: Get.locale,
                                helpText: 'newTask_datePicker_helpText'.tr,
                                cancelText: 'newTask_datePicker_cancelText'.tr,
                                confirmText:
                                    'newTask_datePicker_confirmText'.tr,
                                fieldLabelText:
                                    'newTask_datePicker_fieldLabelText'.tr,
                                fieldHintText:
                                    'newTask_datePicker_fieldHintText'.tr,
                              );

                              selectedDate = date ?? selectedDate;

                              setState(() {});
                            },
                            icon: const FaIcon(
                                FontAwesomeIcons.solidCalendarDays,
                                color: Colors.indigoAccent,
                                size: 30)),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black87.withOpacity(0.4), width: 2.5),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 15.0, left: 15.0),
                        child: Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.solidStar,
                                size: 20.0, color: Colors.orange),
                            const SizedBox(width: 10.0),
                            AutoSizeText(
                              'newTask_ImportantTask'.tr,
                              maxLines: 2,
                              style: GoogleFonts.roboto(
                                  color: Colors.black87.withOpacity(0.7),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0, top: 8.0, bottom: 8.0),
                        child: FlutterSwitch(
                          activeColor: Colors.green,
                          width: 85.0,
                          height: 40.0,
                          toggleSize: 30.0,
                          value: isImportantTaskEnable,
                          borderRadius: 30.0,
                          padding: 6.0,
                          onToggle: (val) {
                            setState(() {
                              isImportantTaskEnable = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black87.withOpacity(0.4), width: 2.5),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.solidBell,
                                  size: 20.0, color: Colors.redAccent),
                              const SizedBox(width: 10.0),
                              AutoSizeText(
                                '${'newTask_Remind'.tr}:',
                                maxLines: 2,
                                style: GoogleFonts.roboto(
                                    color: Colors.black87.withOpacity(0.7),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FlutterSwitch(
                            activeColor: Colors.green,
                            width: 85.0,
                            height: 40.0,
                            toggleSize: 30.0,
                            value: isNotificationEnable,
                            borderRadius: 30.0,
                            padding: 6.0,
                            onToggle: (val) {
                              setState(() {
                                isNotificationEnable = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isNotificationEnable,
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 15.0, right: 15.0, bottom: 15.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black87.withOpacity(0.4), width: 2.5),
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: AutoSizeText(
                                '${DateFormat.MMMMd(Get.deviceLocale.toString()).format(selectedDateNotification!)} ${'newTask_timeAt'.tr} ${selectedTimeNotification!.hour.toString().padLeft(2, '0')}:${selectedTimeNotification!.minute.toString().padLeft(2, '0')}',
                                minFontSize: 10,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    color: Colors.black87.withOpacity(0.7),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 12.0, top: 5.0, bottom: 5.0),
                              child: SizedBox(
                                height: 50,
                                width: 35,
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    splashRadius: 25.0,
                                    onPressed: () async {
                                      dismissKeyboardFocus();
                                      selectDateAndTime(context);
                                    },
                                    icon: const FaIcon(
                                        FontAwesomeIcons.solidCalendarDays,
                                        color: Colors.indigoAccent,
                                        size: 30)),
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => Visibility(
                            visible: !appController.isHomeworksPro.value,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, bottom: 15.0),
                                child: AutoSizeText(
                                  'newTask_Warning'.tr,
                                  maxLines: 2,
                                  minFontSize: 5,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                      color: Colors.black87.withOpacity(0.4),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15.0),
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () async {
                        if (!appController.isHomeworksPro.value) {
                          if (NewTask.taskForChange == null) {
                            if (getNumberOfRemainingTasks() == 0) {
                              Get.to(() => const SubcriptionOverview());

                              dialog(
                                  title: 'notification_TitleError'.tr,
                                  content:
                                      'newTask_notConnectedHomeworksProWarning'
                                          .tr,
                                  isError: true);

                              return;
                            }
                          }

                          if (isNotificationEnable) {
                            if (getNumberOfRemainingNotifications() == 0) {
                              Get.to(() => const SubcriptionOverview());

                              dialog(
                                  title: 'notification_TitleError'.tr,
                                  content:
                                      'newTask_notConnectedHomeworksProWarning'
                                          .tr,
                                  isError: true);

                              return;
                            }
                          }
                        }

                        if (titleController.text.isEmpty) {
                          dialog(
                              title: 'notification_TitleError'.tr,
                              content: 'newTask_subjectEmpty'.tr,
                              isError: true);
                          return;
                        }

                        if (taskController.text.isEmpty) {
                          dialog(
                              title: 'notification_TitleError'.tr,
                              content: 'newTask_taskEmpty'.tr,
                              isError: true);
                          return;
                        }

                        DateTime dateTimeCreatedAt = DateTime(
                            selectedDateNotification!.year,
                            selectedDateNotification!.month,
                            selectedDateNotification!.day,
                            selectedTimeNotification!.hour,
                            selectedTimeNotification!.minute);

                        DateTime dateTimeNow = DateTime.now();

                        final differenceInDays =
                            dateTimeNow.difference(dateTimeCreatedAt).inSeconds;

                        if (differenceInDays >= 0) {
                          dialog(
                              title: 'notification_TitleError'.tr,
                              content: 'newTask_notificationPastTime'.tr,
                              isError: true);
                          return;
                        }

                        int noticeID = isNotificationEnable
                            ? Random().nextInt(100000000) +
                                DateTime.now().year +
                                DateTime.now().month +
                                DateTime.now().day +
                                DateTime.now().hour +
                                DateTime.now().minute +
                                DateTime.now().second +
                                DateTime.now().millisecond
                            : 0;

                        dismissKeyboardFocus();

                        addNewTask(
                            isImportantTaskEnable: isImportantTaskEnable,
                            isNotificationEnable: isNotificationEnable,
                            noticeID: noticeID,
                            selectedDate: selectedDate!,
                            titleController: titleController,
                            taskController: taskController,
                            selectedDateNotification: selectedDateNotification!,
                            selectedTimeNotification: selectedTimeNotification!,
                            pickerColor: pickerColor);

                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NewTask.taskForChange != null
                              ? const FaIcon(FontAwesomeIcons.solidPenToSquare,
                                  color: Colors.white, size: 25)
                              : const FaIcon(FontAwesomeIcons.plus,
                                  color: Colors.white, size: 25),
                          const SizedBox(width: 10.0),
                          Text(
                            NewTask.taskForChange != null
                                ? 'taskList_ButtonChangeTask'.tr
                                : 'newTask_buttonAdd'.tr,
                            style: GoogleFonts.roboto(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => appController.isHomeworksPro.value
                      ? Container(height: 0.0)
                      : const Padding(
                          padding: EdgeInsets.only(bottom: 15.0),
                          child: AppodealBanner(
                              adSize: AppodealBannerSize.BANNER,
                              placement: "default"),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future modalBottomSheetSubjects() async {
    await Get.bottomSheet(Container(
      height: 500.0,
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        children: [
          Container(
            height: 8.0,
            width: 70.0,
            margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(20.0)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: subjects.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: index % 2 != 0
                            ? Colors.transparent
                            : const Color.fromARGB(255, 201, 201, 201)
                                .withOpacity(0.4)),
                    child: ListTile(
                      onTap: () {
                        titleController.text = subjects[index];
                        Get.back();
                      },
                      title: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(subjects[index],
                            style: GoogleFonts.roboto(
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87.withOpacity(0.8))),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }

  int getNumberOfRemainingTasks() {
    List tasks =
        appController.tasks.where((p0) => p0.date == selectedDate).toList();

    tasks = NewTask.taskForChange != null
        ? tasks.where((element) => element != NewTask.taskForChange).toList()
        : tasks;

    return tasks.length >= 5 ? 0 : 5 - tasks.length;
  }

  int getNumberOfRemainingNotifications() {
    List tasks = appController.tasks
        .where((p0) => p0.date == selectedDate)
        .toList()
        .where((element) => element.notificationId != 0)
        .toList();

    tasks = NewTask.taskForChange != null
        ? tasks.where((element) => element != NewTask.taskForChange).toList()
        : tasks;

    return tasks.length >= 3 ? 0 : 3 - tasks.length;
  }

  Future showColorPicker() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('colorPicker_Title'.tr),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
              ),
            ),
            actions: [
              ElevatedButton(
                child: Text('colorPicker_ButtonApply'.tr),
                onPressed: () {
                  setState(() => currentColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
