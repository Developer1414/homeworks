import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;

import 'package:intl/intl.dart';
import 'package:scool_home_working/screens/viewer_user_agreement.dart';

class SubcriptionOverview extends StatelessWidget {
  const SubcriptionOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 170,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  '${NumberFormat.simpleCurrency(locale: ui.window.locale.toString() == 'ru_RU' ? 'ru_RU' : 'en_US').format(ui.window.locale.toString() == 'ru_RU' ? 70 : 0.94)} / ${'proOverview_month'.tr}',
                  minFontSize: 10,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: Colors.black87,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: SizedBox(
                    height: 65.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: const Color.fromARGB(255, 255, 164, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () async {},
                      child: AutoSizeText(
                        'proOverview_buttonConnect'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: '${'proOverview_userAgreementWarn'.tr} ',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          )),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Get.to(() => const UserAgreementViewer()),
                          text: 'proOverview_userAgreement'.tr,
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                            letterSpacing: 0.5,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
                          )),
                        )
                      ])),
                ),
              ],
            ),
          ),
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
                  Get.back();
                },
                icon: const FaIcon(FontAwesomeIcons.arrowLeft,
                    color: Colors.black87, size: 30)),
          ),
          title: AutoSizeText(
            'Homeworks Pro',
            minFontSize: 10,
            maxLines: 1,
            style: GoogleFonts.roboto(
              color: Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                minVerticalPadding: 10,
                horizontalTitleGap: 10,
                contentPadding: EdgeInsets.zero,
                leading:
                    Image.asset('lib/assets/block.png', width: 35, height: 35),
                title: AutoSizeText(
                  'proOverview_noAdTitle'.tr,
                  minFontSize: 10.0,
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                    color: Colors.black87,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                subtitle: Text(
                  'proOverview_noAdSubtitle'.tr,
                  style: GoogleFonts.roboto(
                    color: Colors.black87.withOpacity(0.7),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              ListTile(
                minVerticalPadding: 10,
                horizontalTitleGap: 10,
                contentPadding: EdgeInsets.zero,
                leading: Image.asset('lib/assets/to-do-list.png',
                    width: 35, height: 35),
                title: Text(
                  'proOverview_infinityTasksTitle'.tr,
                  style: GoogleFonts.roboto(
                    color: Colors.black87,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                subtitle: Text(
                  'proOverview_infinityTasksSubtitle'.tr,
                  style: GoogleFonts.roboto(
                    color: Colors.black87.withOpacity(0.7),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              ListTile(
                minVerticalPadding: 10,
                horizontalTitleGap: 10,
                contentPadding: EdgeInsets.zero,
                leading: Image.asset('lib/assets/notification.png',
                    width: 35, height: 35),
                title: Text(
                  'proOverview_infinityNotificationsTitle'.tr,
                  style: GoogleFonts.roboto(
                    color: Colors.black87,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                subtitle: Text(
                  'proOverview_infinityNotificationsSubtitle'.tr,
                  style: GoogleFonts.roboto(
                    color: Colors.black87.withOpacity(0.7),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
