import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scool_home_working/business/user_account.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();

  static RxBool isRegister = true.obs;
  static RxBool isLoading = false.obs;

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
        home: Obx(
          () => isLoading.value
              ? Scaffold(
                  body: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 6.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        AutoSizeText(
                          'login_loadingPleaseWait'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            color: Colors.black87.withOpacity(0.7),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Scaffold(
                  resizeToAvoidBottomInset: false,
                  bottomNavigationBar: SizedBox(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: SizedBox(
                              height: 65.0,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                onPressed: () async {
                                  if (emailController.text.isEmpty ||
                                      passwordController.text.isEmpty) {
                                    return;
                                  }

                                  if (isRegister.value) {
                                    UserAccount().register(
                                        emailAddress:
                                            emailController.text.trim(),
                                        password: passwordController.text);
                                  } else {
                                    UserAccount().login(
                                        emailAddress:
                                            emailController.text.trim(),
                                        password: passwordController.text);
                                  }
                                },
                                child: Obx(
                                  () => AutoSizeText(
                                    isRegister.value
                                        ? 'login_buttonRegister'.tr
                                        : 'login_buttonLogin'.tr,
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
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Obx(
                              () => RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: isRegister.value
                                          ? '${'login_alreadyHaveAnAccount'.tr} '
                                          : '${'login_noAccount'.tr} ',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      )),
                                    ),
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => isRegister.toggle(),
                                      text: isRegister.value
                                          ? '${'login_buttonLogin'.tr}!'
                                          : '${'login_buttonRegister'.tr}!',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                        letterSpacing: 0.5,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue,
                                      )),
                                    )
                                  ])),
                            ),
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
                      'login_titleAuthorization'.tr,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 5.0),
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: GoogleFonts.roboto(
                              color: Colors.black87.withOpacity(0.7),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: InputDecoration(
                                hintText: 'login_textInputEmailAddress'.tr,
                                hintStyle: GoogleFonts.roboto(
                                  color: Colors.black87.withOpacity(0.5),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        width: 2.0,
                                        color:
                                            Colors.black87.withOpacity(0.4))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        width: 2.5,
                                        color:
                                            Colors.black87.withOpacity(0.6)))),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: AutoSizeText(
                            'login_textWarning'.tr,
                            minFontSize: 10,
                            maxLines: 1,
                            style: GoogleFonts.roboto(
                              color: Colors.black87.withOpacity(0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 15.0),
                          child: TextField(
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            style: GoogleFonts.roboto(
                              color: Colors.black87.withOpacity(0.7),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: InputDecoration(
                                hintText: 'login_textInputPassword'.tr,
                                hintStyle: GoogleFonts.roboto(
                                  color: Colors.black87.withOpacity(0.5),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        width: 2.0,
                                        color:
                                            Colors.black87.withOpacity(0.4))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                        width: 2.5,
                                        color:
                                            Colors.black87.withOpacity(0.6)))),
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
