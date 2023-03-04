import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scool_home_working/controllers/app_controller.dart';
import 'package:scool_home_working/screens/login.dart';

Future modalBottomSheetUserDetails() async {
  final AppController appController = Get.find();

  RxBool isLoading = false.obs;

  await Get.bottomSheet(Container(
    height: FirebaseAuth.instance.currentUser != null ? 212.0 : 140.0,
    margin: const EdgeInsets.all(15.0),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
    child: Obx(
      () => isLoading.value
          ? const Center(
              child: SizedBox(
                width: 25.0,
                height: 25.0,
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: FirebaseAuth.instance.currentUser != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'profile_title'.tr,
                          minFontSize: 10,
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                            color: Colors.black87,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Container(
                          height: 2.0,
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        AutoSizeText(
                          '${'profile_accountTitle'.tr}: ${FirebaseAuth.instance.currentUser!.email}',
                          minFontSize: 10,
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        AutoSizeText(
                          '${'profile_subscriptionTitle'.tr}: ${appController.isHomeworksPro.value ? '${'profile_subscriptionActiveUntil'.tr} ${DateFormat.MMMMd('ru_RU').format(appController.subscriptionExpirationDate)}' : 'profile_subscriptionNotActive'.tr}',
                          minFontSize: 10,
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        SizedBox(
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
                              isLoading.value = true;
                              FirebaseAuth.instance.signOut().whenComplete(() {
                                Get.back();
                                appController.isHomeworksPro.value = false;
                                isLoading.value = false;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(FontAwesomeIcons.rightFromBracket,
                                    color: Colors.white, size: 25),
                                const SizedBox(width: 10.0),
                                Flexible(
                                  child: AutoSizeText(
                                    'profile_logout'.tr,
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
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          'profile_notLogged'.tr,
                          minFontSize: 10,
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                            color: Colors.black87,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        SizedBox(
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
                              Get.off(() => const Login());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(FontAwesomeIcons.rightToBracket,
                                    color: Colors.white, size: 25),
                                const SizedBox(width: 10.0),
                                Flexible(
                                  child: AutoSizeText(
                                    'profile_login'.tr,
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
                      ],
                    ),
            ),
    ),
  ));
}
