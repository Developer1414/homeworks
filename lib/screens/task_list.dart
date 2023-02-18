import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scool_home_working/controllers/app_controller.dart';
import 'package:scool_home_working/models/task_model.dart';
import 'package:scool_home_working/screens/new_task.dart';
import 'package:scool_home_working/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  static DateTime? selectedDate = DateTime.now();
  late SharedPreferences prefs;
  final AppController appController = Get.find();

  List<Task> currentTasks = [];

  Future loadTasks() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('task')) {
      String? data = prefs.getString('task');
      appController.tasks.value = Task.decode(data!);
    }

    if (prefs.containsKey('selectedDate')) {
      String? date = prefs.getString('selectedDate');
      setState(() {
        selectedDate = DateTime.parse(date!);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    loadTasks();

    setState(() {
      appController.selectedTasks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    currentTasks = appController.tasks
        .where((p0) =>
            p0.date ==
            DateTime(
                selectedDate!.year, selectedDate!.month, selectedDate!.day))
        .toList();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: Obx(
          () => appController.selectedTasks.isNotEmpty
              ? Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 15.0, bottom: 15.0),
                        child: SizedBox(
                          height: 65.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                for (var element
                                    in appController.selectedTasks) {
                                  LocalNoticeService()
                                      .localNotificationsPlugin
                                      .cancel(element.notificationId);

                                  appController.tasks.remove(element);
                                }

                                appController.selectedTasks.clear();
                              });

                              String encodedData =
                                  Task.encode(appController.tasks);
                              await prefs.setString('task', encodedData);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(FontAwesomeIcons.trash,
                                    color: Colors.white, size: 25),
                                const SizedBox(width: 10.0),
                                Flexible(
                                  child: AutoSizeText(
                                    'taskList_ButtonDeleteTask'.tr,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 15.0, top: 15.0, bottom: 15.0),
                        child: SizedBox(
                          height: 65.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            onPressed: appController.selectedTasks.length > 1
                                ? null
                                : () async {
                                    setState(() {
                                      NewTask.taskForChange =
                                          appController.selectedTasks[0];

                                      appController.selectedTasks.clear();
                                    });

                                    await Get.to(() => const NewTask());
                                    setState(() {});
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(FontAwesomeIcons.solidPenToSquare,
                                    color: Colors.white, size: 25),
                                const SizedBox(width: 10.0),
                                Flexible(
                                  child: AutoSizeText(
                                    'taskList_ButtonChangeTask'.tr,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : appController.isHomeworksPro.value
                  ? Container(height: 0.0)
                  : const Padding(
                      padding: EdgeInsets.only(bottom: 15.0, top: 15.0),
                      child: AppodealBanner(
                          adSize: AppodealBannerSize.BANNER,
                          placement: "default"),
                    ),
        ),
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          title: AutoSizeText(
            '${'taskList_Title'.tr} ${DateFormat.MMMMd(Get.locale.toString()).format(selectedDate!)}:',
            maxLines: 1,
            minFontSize: 10,
            style: GoogleFonts.roboto(
              color: Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 25.0,
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2100),
                      helpText: 'newTask_datePicker_helpText'.tr,
                      cancelText: 'newTask_datePicker_cancelText'.tr,
                      confirmText: 'newTask_datePicker_confirmText'.tr,
                      fieldLabelText: 'newTask_datePicker_fieldLabelText'.tr,
                      fieldHintText: 'newTask_datePicker_fieldHintText'.tr,
                    );

                    selectedDate = date ?? selectedDate;

                    currentTasks = appController.tasks
                        .where((p0) =>
                            p0.date ==
                            DateTime(selectedDate!.year, selectedDate!.month,
                                selectedDate!.day))
                        .toList();

                    setState(() {});

                    await prefs.setString(
                        'selectedDate', selectedDate.toString());
                  },
                  icon: const FaIcon(FontAwesomeIcons.solidCalendarDays,
                      color: Colors.indigoAccent, size: 30)),
            )
          ],
        ),
        body: currentTasks.isEmpty
            ? Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: AutoSizeText(
                    'taskList_NoHomeworks'.tr,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Colors.black87.withOpacity(0.4),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            : ListView.separated(
                itemCount: currentTasks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15.0),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Material(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (!appController.selectedTasks
                                .contains(currentTasks[index])) {
                              appController.selectedTasks
                                  .add(currentTasks[index]);
                            } else {
                              appController.selectedTasks
                                  .remove(currentTasks[index]);
                            }
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: appController.selectedTasks
                                        .contains(currentTasks[index])
                                    ? Colors.green.withOpacity(0.2)
                                    : currentTasks[index].importantTask
                                        ? Colors.redAccent.withOpacity(0.2)
                                        : Colors.transparent,
                                border: Border.all(
                                    color: appController.selectedTasks
                                            .contains(currentTasks[index])
                                        ? Colors.green
                                        : currentTasks[index].importantTask
                                            ? Colors.redAccent
                                            : Colors.black87.withOpacity(0.4),
                                    width: 2.2),
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  currentTasks[index].importantTask
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.redAccent
                                                            .withOpacity(0.8),
                                                        blurRadius: 10.0)
                                                  ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(7.0),
                                                child: AutoSizeText(
                                                  'taskList_ImportantTask'.tr,
                                                  maxLines: 1,
                                                  style: GoogleFonts.roboto(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            currentTasks[index]
                                                        .notificationId ==
                                                    0
                                                ? Container()
                                                : FaIcon(
                                                    FontAwesomeIcons.solidBell,
                                                    color: Colors.black87
                                                        .withOpacity(0.4),
                                                    size: 15)
                                          ],
                                        )
                                      : Container(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentTasks[index].titleTask,
                                        style: GoogleFonts.roboto(
                                            color: currentTasks[index]
                                                .taskTitleColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      currentTasks[index].importantTask
                                          ? Container()
                                          : currentTasks[index]
                                                      .notificationId ==
                                                  0
                                              ? Container()
                                              : FaIcon(
                                                  FontAwesomeIcons.solidBell,
                                                  color: Colors.black87
                                                      .withOpacity(0.4),
                                                  size: 15)
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    color: Colors.black87.withOpacity(0.4),
                                    height: 2.0,
                                    width: double.infinity,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      currentTasks[index].task,
                                      style: GoogleFonts.roboto(
                                          color:
                                              Colors.black87.withOpacity(0.7),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
