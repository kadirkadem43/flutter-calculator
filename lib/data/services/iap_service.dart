import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calculator_app/domain/services/i_iap_service.dart';

class IapService implements IIapService {
  final SharedPreferences _prefs;
  final InAppPurchase _iap = InAppPurchase.instance;
  
  static const String _premiumKey = 'is_premium_user';
  static const String _premiumProductId = 'com.example.calculator.premium'; // Replace with real ID

  final _premiumStatusController = StreamController<bool>.broadcast();
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  IapService(this._prefs);

  @override
  Future<void> init() async {
    final available = await _iap.isAvailable();
    if (!available) {
      // Store unavailable
      return;
    }

    _subscription = _iap.purchaseStream.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // Handle error
    });
  }

  @override
  Stream<bool> get premiumStatusStream => _premiumStatusController.stream;

  @override
  Future<bool> get isPremium async {
    return _prefs.getBool(_premiumKey) ?? false;
  }

  @override
  Future<void> buyPremium() async {
    final ProductDetailsResponse response = await _iap.queryProductDetails({_premiumProductId});
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      // Product not found, for development we can mock success if needed
      // _setPremium(true);
      return;
    }
    
    final productDetails = response.productDetails.first;
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Handle error
        } else if (purchaseDetails.status == PurchaseStatus.purchased || 
                   purchaseDetails.status == PurchaseStatus.restored) {
          
          if (purchaseDetails.productID == _premiumProductId) {
            _setPremium(true);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> _setPremium(bool value) async {
    await _prefs.setBool(_premiumKey, value);
    _premiumStatusController.add(value);
  }
}
