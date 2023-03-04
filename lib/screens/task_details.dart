import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scool_home_working/controllers/app_controller.dart';
import 'package:scool_home_working/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find();

    return WillPopScope(
      onWillPop: () async {
        appController.taskIdFromNotification.value = 0;
        return true;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          bottomNavigationBar: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
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
                        appController.tasks.remove(task);

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        String encodedData = Task.encode(appController.tasks);
                        await prefs.setString('task', encodedData);

                        appController.taskIdFromNotification.value = 0;
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
            ],
          ),
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 70,
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 25.0,
                  onPressed: () {
                    appController.taskIdFromNotification.value = 0;
                  },
                  icon: const FaIcon(FontAwesomeIcons.arrowLeft,
                      color: Colors.black87, size: 30)),
            ),
            title: AutoSizeText(
              'taskDetail_title'.tr,
              minFontSize: 10,
              maxLines: 1,
              style: GoogleFonts.roboto(
                color: Colors.black87,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    task.titleTask,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Colors.black87,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  AutoSizeText(
                    task.task,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Colors.black87,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
