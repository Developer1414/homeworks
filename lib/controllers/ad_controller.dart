import 'package:appodeal_flutter/appodeal_flutter.dart';

class AdController {
  Future showInterstitialAd(Function func) async {
    Appodeal.show(AdType.interstitial);

    Appodeal.setInterstitialCallback((event) {
      if (event == 'onInterstitialShown') {
        func.call();
      }
    });
  }
}
