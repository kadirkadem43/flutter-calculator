import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class IAdService {
  Future<void> init();
  BannerAd createBannerAd({required void Function() onAdLoaded, required void Function(LoadAdError) onAdFailedToLoad});
}
