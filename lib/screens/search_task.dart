import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchTask extends StatelessWidget {
  const SearchTask({super.key});

  static TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: searchController,
                    style: GoogleFonts.roboto(
                      color: Colors.black87.withOpacity(0.7),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                        hintText: 'Название предмета или задание...'.tr,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
