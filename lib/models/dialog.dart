import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future dialog({String title = '', String content = '', bool isError = false}) {
  return Get.defaultDialog(
    titlePadding: const EdgeInsets.only(top: 20.0),
    title: title,
    titleStyle: GoogleFonts.roboto(
        fontSize: 25,
        color: isError ? Colors.redAccent : Colors.black87.withOpacity(0.7),
        fontWeight: FontWeight.w800),
    content: Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
            fontSize: 22,
            color: isError ? Colors.black87.withOpacity(0.7) : Colors.green,
            fontWeight: FontWeight.w700),
      ),
    ),
  );
}
