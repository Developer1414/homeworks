import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:scool_home_working/controllers/app_controller.dart';
import 'package:scool_home_working/models/dialog.dart';
import 'package:scool_home_working/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount {
  final AppController appController = Get.find();

  Future login({required String emailAddress, required String password}) async {
    try {
      Login.isLoading.value = true;

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      await checkSubscription();

      Get.back();

      Login.isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        dialog(
            title: 'notification_TitleError'.tr,
            content: 'login_userNotFound'.tr,
            isError: true);
        Login.isLoading.value = false;
      } else if (e.code == 'wrong-password') {
        dialog(
            title: 'notification_TitleError'.tr,
            content: 'login_wrongPassword'.tr,
            isError: true);
        Login.isLoading.value = false;
      }
    }
  }

  Future checkSubscription() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        appController.subscriptionExpirationDate =
            (value.get('subscription') as Timestamp).toDate();

        appController.isHomeworksPro.value =
            (value.get('subscription') as Timestamp)
                        .toDate()
                        .difference(DateTime.now())
                        .inDays <=
                    0
                ? false
                : true;
      });
    } else {
      appController.isHomeworksPro.value = false;
    }
  }

  Future register(
      {required String emailAddress, required String password}) async {
    try {
      Login.isLoading.value = true;

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'subscription': DateTime(2023, 3, 4, 12)
      });

      Login.isLoading.value = false;

      Get.back();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        dialog(
            title: 'notification_TitleError'.tr,
            content: 'login_weakPassword'.tr,
            isError: true);
        Login.isLoading.value = false;
      } else if (e.code == 'email-already-in-use') {
        dialog(
            title: 'notification_TitleError'.tr,
            content: 'login_emailAlreadyInUse'.tr,
            isError: true);
        Login.isLoading.value = false;
      }
    } catch (e) {
      dialog(
          title: 'notification_TitleError'.tr,
          content: e.toString(),
          isError: true);
      Login.isLoading.value = false;
    }
  }
}
