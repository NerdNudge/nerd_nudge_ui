import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseAPI {
  static const _apikey = 'goog_bcIotbsIPCTidmmXUaBxzGKHFYu';
  static List<Offering> _offerings = [];
  static String _userCurrentOffering = '';

  static get offerings => _offerings;
  static get userCurrentOffering => _userCurrentOffering;

  static Future init() async {
    PurchasesConfiguration configuration = PurchasesConfiguration(_apikey);
    await Purchases.configure(configuration);
    await updateNerdNudgeOfferings();
    await updateCurrentOffer();
  }

  static Future<void> updateNerdNudgeOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      _offerings = offerings.all.values.toList();
    } on PlatformException catch (e) {
      print('Error fetching offerings: $e');
    }
  }

  static Future<String?> updateCurrentOffer() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.active.isNotEmpty) {
        EntitlementInfo activeEntitlement = customerInfo.entitlements.active.values.first;
        _userCurrentOffering = activeEntitlement.identifier;
      } else {
        _userCurrentOffering = 'Freemium';
        //_userCurrentOffering = 'Nerd Nudge Pro';
      }
    } catch (e) {
      print('Error fetching customer info: $e');
      _userCurrentOffering = 'Freemium';
    }
  }
}