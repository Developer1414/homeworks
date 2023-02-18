import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class AdController {
  Future showInterstitialAd(Function func) async {
    //Appodeal.setInterstitialCallbacks(onInterstitialShown: () => func.call());

    var isCanShow = await Appodeal.canShow(AppodealAdType.Interstitial);
    var isLoaded = await Appodeal.isLoaded(AppodealAdType.Interstitial);

    if (isCanShow && isLoaded) {
      Appodeal.show(AppodealAdType.Interstitial);
    }
  }
}
