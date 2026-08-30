import 'dart:async';

abstract class IIapService {
  Future<void> init();
  Stream<bool> get premiumStatusStream;
  Future<bool> get isPremium;
  Future<void> buyPremium();
  Future<void> restorePurchases();
}
