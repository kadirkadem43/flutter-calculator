import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculator_app/domain/services/i_iap_service.dart';

final iapServiceProvider = Provider<IIapService>((ref) {
  throw UnimplementedError();
});

final premiumProvider = StateNotifierProvider<PremiumNotifier, bool>((ref) {
  final iapService = ref.watch(iapServiceProvider);
  return PremiumNotifier(iapService);
});

class PremiumNotifier extends StateNotifier<bool> {
  final IIapService _iapService;

  PremiumNotifier(this._iapService) : super(false) {
    _init();
  }

  Future<void> _init() async {
    final isPremium = await _iapService.isPremium;
    state = isPremium;

    _iapService.premiumStatusStream.listen((status) {
      state = status;
    });
  }

  Future<void> buyPremium() async {
    await _iapService.buyPremium();
  }

  Future<void> restorePurchases() async {
    await _iapService.restorePurchases();
  }
}
