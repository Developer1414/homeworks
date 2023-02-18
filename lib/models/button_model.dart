import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customButton(
    {String text = '',
    Color color = Colors.grey,
    required Function onTap,
    Size size = const Size(double.infinity, 60),
    double borderRadius = 15.0,
    EdgeInsets padding = EdgeInsets.zero,
    double textSize = 22.0,
    Color textColor = Colors.white,
    TextAlign textAlign = TextAlign.start,
    int maxLines = 1}) {
  return Padding(
    padding: padding,
    child: Material(
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      color: color,
      child: InkWell(
        onTap: () => onTap.call(),
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AutoSizeText(
                text,
                maxLines: maxLines,
                textAlign: textAlign,
                minFontSize: 10,
                style: GoogleFonts.roboto(
                    color: textColor,
                    fontSize: textSize,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
