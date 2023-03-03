import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scool_home_working/controllers/app_controller.dart';
import 'package:scool_home_working/models/task_model.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key, this.taskId = ''});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find();

    Task task = appController.tasks
        .where((p0) => p0.notificationId == taskId)
        .toList()
        .first;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  Get.back();
                },
                icon: const FaIcon(FontAwesomeIcons.arrowLeft,
                    color: Colors.black87, size: 30)),
          ),
          title: AutoSizeText(
            taskId,
            minFontSize: 10,
            maxLines: 1,
            style: GoogleFonts.roboto(
              color: Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: Column(
          children: [
            AutoSizeText(
              task.titleTask,
              minFontSize: 10,
              maxLines: 1,
              style: GoogleFonts.roboto(
                color: Colors.black87,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
