import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:scool_home_working/models/dialog.dart';

class NewUpdate extends StatelessWidget {
  const NewUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool isUpdating = false.obs;

    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 70,
            backgroundColor: Colors.transparent,
            title: AutoSizeText(
              'newUpdate_Title'.tr,
              maxLines: 1,
              style: GoogleFonts.roboto(
                color: Colors.black87.withOpacity(0.7),
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              Obx(
                () => isUpdating.value
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            splashRadius: 25.0,
                            onPressed: () async {
                              Get.back();
                            },
                            icon: const Icon(Icons.close_rounded,
                                color: Colors.redAccent, size: 30)),
                      ),
              )
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      isUpdating.value
                          ? 'newUpdate_textInstalling'.tr
                          : 'newUpdate_textUpdateIsAvailable'.tr,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: Colors.black87.withOpacity(0.7),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    isUpdating.value
                        ? const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: SizedBox(
                              width: 45.0,
                              height: 45.0,
                              child:
                                  CircularProgressIndicator(strokeWidth: 6.0),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              height: 65.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                onPressed: () async {
                                  InAppUpdate.startFlexibleUpdate().then((_) {
                                    InAppUpdate.completeFlexibleUpdate()
                                        .then((_) {
                                      isUpdating.value = false;
                                      Get.back();
                                    }).catchError((e) {
                                      dialog(
                                          title:
                                              '${'notification_TitleError'.tr} code:2',
                                          content: e.toString(),
                                          isError: true);
                                    });
                                  }).catchError((e) {
                                    dialog(
                                        title:
                                            '${'notification_TitleError'.tr} code:1',
                                        content: e.toString(),
                                        isError: true);
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.system_update_rounded,
                                        color: Colors.white, size: 30),
                                    const SizedBox(width: 5.0),
                                    AutoSizeText(
                                      'newUpdate_buttonInstall'.tr,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
