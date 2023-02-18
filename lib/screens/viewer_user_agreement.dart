import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:ui' as ui;

class UserAgreementViewer extends StatefulWidget {
  const UserAgreementViewer({super.key});

  @override
  State<UserAgreementViewer> createState() => _UserAgreementViewerState();
}

class _UserAgreementViewerState extends State<UserAgreementViewer> {
  final pdfController = PdfController(
    document: PdfDocument.openAsset(
        'lib/assets/${ui.window.locale.toString() == 'ru_RU' ? 'UserAgreement_RU' : 'UserAgreement_US'}.pdf'),
  );

  @override
  Widget build(BuildContext context) {
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
                'proOverview_userAgreementTitle'.tr,
                minFontSize: 10,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  color: Colors.black87,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            body: PdfView(
              controller: pdfController,
            )));
  }
}
