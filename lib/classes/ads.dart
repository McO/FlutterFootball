import 'dart:io';

class AdsConfiguration {
  String getAppId() {
    if (Platform.isIOS) {
      return "IOS_APP_ID";
    } else if (Platform.isAndroid) {
      return "com.rasp.flutterfootball";
    }
    return null;
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return "IOS_AD_UNIT_BANNER";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    }
    return null;
  }

  static String getNativeAdUnitId() {
    if (Platform.isIOS) {
      return "IOS_AD_UNIT_BANNER";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/2247696110";
    }
    return null;
  }

//  BannerAd buildBannerAd() {
//    return BannerAd(
//        adUnitId: BannerAd.testAdUnitId,
//        size: AdSize.fullBanner,
//        listener: (MobileAdEvent event) {
//          if (event == MobileAdEvent.loaded) {
//            myBanner..show();
//          }
//        });
//  }
//
//  BannerAd createBannerAd() {
//    return BannerAd(
//      adUnitId: getBannerAdUnitId(),
//      size: AdSize.banner,
////      targetingInfo: targetingInfo,
//      listener: (MobileAdEvent event) {
//        print("BannerAd event $event");
//      },
//    );
//  }
}
