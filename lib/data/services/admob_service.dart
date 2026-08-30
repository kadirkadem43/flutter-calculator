import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:calculator_app/domain/services/i_ad_service.dart';
import 'dart:io' show Platform;

class AdMobService implements IAdService {
  // Use test ad units by default
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw UnsupportedError('Unsupported platform');
  }

  @override
  Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  @override
  BannerAd createBannerAd({
    required void Function() onAdLoaded,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onAdLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onAdFailedToLoad(error);
        },
      ),
    );
  }
}
