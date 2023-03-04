import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:get/get.dart';
import 'package:scool_home_working/business/user_account.dart';
import 'package:scool_home_working/controllers/app_controller.dart';
import 'package:scool_home_working/models/dialog.dart';
import 'package:scool_home_working/screens/subscription_overview.dart';
import 'package:scool_home_working/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yookassa_payments_flutter/yookassa_payments_flutter.dart';

class Payment {
  final AppController appController = Get.find();

  Future getHomeworksPro() async {
    var clientApplicationKey =
        "live_OTgyMTMyd3WgKx6U_t_xHzTFWmt93Qp1Anns6ZErqWM";
    var amount = Amount(value: 70.00, currency: Currency.rub);
    var shopId = "982132";
    var moneyAuthClientId = "gganqqp7bvspn3g47ehqe2vtnut8hv59";

    var tokenizationModuleInputData = TokenizationModuleInputData(
        clientApplicationKey: clientApplicationKey,
        title: "Homeworks Pro",
        subtitle: "Pro версия приложения",
        amount: amount,
        savePaymentMethod: SavePaymentMethod.userSelects,
        //isLoggingEnabled: true,
        moneyAuthClientId: moneyAuthClientId,
        shopId: shopId,
        tokenizationSettings: const TokenizationSettings(PaymentMethodTypes([
          PaymentMethod.bankCard,
          PaymentMethod.yooMoney,
          PaymentMethod.sberbank
        ])));

    var result =
        await YookassaPaymentsFlutter.tokenization(tokenizationModuleInputData);

    if (result is SuccessTokenizationResult) {
      SubcriptionOverview.isLoading.value = true;

      final http.Response response = await http.post(
          Uri.parse('https://api.yookassa.ru/v3/payments'),
          headers: <String, String>{
            'Authorization':
                'Basic ${base64Encode(utf8.encode('982132:live_qKe6dJ9dSnpPJTweNyvQLb5IjAi9PcPyDyKsVMslDHw'))}',
            'Idempotence-Key': DateTime.now().microsecondsSinceEpoch.toString(),
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            <String, dynamic>{
              "payment_token": result.token,
              "amount": {
                "value": amount.value,
                "currency": amount.currency.value
              },
              "capture": true,
              "description": 'hello',
              "receipt": {
                "customer": {"email": FirebaseAuth.instance.currentUser!.email},
                "items": [
                  {
                    "description": "Homeworks Pro",
                    "quantity": "1",
                    "amount": {
                      "value": amount.value,
                      "currency": amount.currency.value
                    },
                    "vat_code": "1"
                  },
                ]
              },
            },
          ));

      Map<String, dynamic> json = jsonDecode(response.body);

      if (result.paymentMethodType == PaymentMethod.sberbank) {
        SubcriptionOverview.isConfirmPayment.value = true;
      } else if (result.paymentMethodType == PaymentMethod.bankCard ||
          result.paymentMethodType == PaymentMethod.yooMoney) {
        if (json['status'] == 'pending') {
          var url = Uri.parse(json['confirmation']['confirmation_url']);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            throw "Could not launch $url";
          }
        }
      }

      checkPayment(json['id']);
    } else if (result is ErrorTokenizationResult) {
      dialog(
          title: 'notification_TitleError'.tr,
          content: result.error,
          isError: true);

      SubcriptionOverview.isLoading.value = false;

      TokenizationResult.error(result.error);
      return;
    }
  }

  Future checkPayment(String paymentId) async {
    http.Response response;

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      response = await http.get(
          Uri.parse('https://api.yookassa.ru/v3/payments/$paymentId'),
          headers: <String, String>{
            'Authorization':
                'Basic ${base64Encode(utf8.encode('982132:live_qKe6dJ9dSnpPJTweNyvQLb5IjAi9PcPyDyKsVMslDHw'))}',
          });

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);

        if (json['status'] == 'succeeded') {
          timer.cancel();

          appController.isHomeworksPro.value = true;

          DateTime subscriptionDate = DateTime(
                  DateTime.now().year, DateTime.now().month, DateTime.now().day)
              .add(const Duration(days: 30));

          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'subscription': subscriptionDate});

          await LocalNoticeService().addNotification(
            id: Random().nextInt(100000000) +
                DateTime.now().year +
                DateTime.now().month +
                DateTime.now().day +
                DateTime.now().hour +
                DateTime.now().minute +
                DateTime.now().second +
                DateTime.now().millisecond,
            title: 'Homeworks',
            body: 'systemNotification_RemindAboutSubscriptionEnd'.tr,
            endTime: subscriptionDate
                .subtract(const Duration(hours: 24))
                .millisecondsSinceEpoch,
            channel: 'work-end',
          );

          await UserAccount().checkSubscription();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('subscription', subscriptionDate.toString());

          SubcriptionOverview.isLoading.value = false;

          dialog(
              title: 'notification_TitleCongratulations'.tr,
              content: 'proOverview_homeworksProConnected'.tr);
        } else if (json['status'] == 'canceled') {
          timer.cancel();

          dialog(
              title: 'notification_TitleError'.tr,
              content: 'proOverview_notificationErrorCanceled'.tr,
              isError: true);

          SubcriptionOverview.isLoading.value = false;
        }
      }
    });
  }
}
