import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:scool_home_working/controllers/app_controller.dart';
import 'package:scool_home_working/firebase_options.dart';
import 'package:scool_home_working/models/dialog.dart';
import 'package:scool_home_working/screens/new_task.dart';
import 'package:scool_home_working/screens/task_list.dart';
import 'package:scool_home_working/services/app_translations.dart';
import 'package:scool_home_working/services/notification_service.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AppMetrica.activate(
      const AppMetricaConfig("1c4c46c4-2c6b-405c-8475-4dee61677738"));

  Appodeal.initialize(
      appKey: "1f3a950d6bd222ab56f499d2fd8f0217a2e6fd7f415147a4",
      adTypes: [
        AppodealAdType.Interstitial,
        AppodealAdType.Banner,
        AppodealAdType.MREC
      ],
      onInitializationFinished: (errors) => {});

  await LocalNoticeService().setup();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    /*initializeDateFormatting(Get.deviceLocale.toString(), null)
        .then((value) => runApp(const MyApp()));*/
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.put(AppController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: ui.window.locale,
      fallbackLocale: const Locale('en', 'US'),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AppUpdateInfo? _updateInfo;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;

        if (_updateInfo?.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          InAppUpdate.startFlexibleUpdate().then((_) {
            InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
              dialog(
                  title: '${'notification_TitleError'.tr} code:2',
                  content: e.toString(),
                  isError: true);
            });
          }).catchError((e) {
            dialog(
                title: '${'notification_TitleError'.tr} code:1',
                content: e.toString(),
                isError: true);
          });
        }
      });
    }).catchError((e) {
      dialog(
          title: 'notification_TitleError'.tr,
          content: e.toString(),
          isError: true);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final InAppReview inAppReview = InAppReview.instance;

    if (prefs.containsKey('task') && !prefs.containsKey('requestReview')) {
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview().whenComplete(() {
          prefs.setBool('requestReview', true);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    List screens = [const TaskList(), const NewTask()];

    final AppController appController = Get.find();

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            unselectedItemColor: Colors.black87.withOpacity(0.4),
            selectedItemColor: Colors.black.withOpacity(0.7),
            elevation: 15,
            iconSize: 28,
            type: BottomNavigationBarType.fixed,
            currentIndex: appController.currentScreen.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedLabelStyle: GoogleFonts.roboto(
              color: Colors.black87.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.listCheck),
                activeIcon: FaIcon(FontAwesomeIcons.listCheck),
                label: '',
                tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.plus),
                activeIcon: FaIcon(FontAwesomeIcons.plus),
                label: '',
                tooltip: '',
              ),
            ],
            onTap: (index) {
              appController.currentScreen.value = index;
            },
          ),
        ),
        body: Obx(() => screens.elementAt(appController.currentScreen.value)),
      ),
    );
  }
}
