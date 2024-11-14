import 'package:flutter/services.dart';
import 'package:nerd_nudge/user_home_page/dto/user_home_stats.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../utilities/constants.dart';

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
      print('updated offerings: $offerings');
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
        _userCurrentOffering = _getOfferDisplayName(activeEntitlement.identifier);
      } else {
        _userCurrentOffering = Constants.FREEMIUM;
        //_userCurrentOffering = 'Nerd Nudge Pro';
      }
      print('updated current offering: $_userCurrentOffering');
    } catch (e) {
      print('Error fetching customer info: $e');
      _userCurrentOffering = Constants.FREEMIUM;
    }
  }

  static String _getOfferDisplayName(String identifier) {
    switch (identifier) {
      case 'nerdnudgepro_399_1m':
      case 'nerdnudgepro_399_1m_ios':
        return 'Nerd Nudge Pro - Monthly';
      case 'nerdnudgepro_3999_1y':
      case 'nerdnudgepro_3999_1y_ios':
        return 'Nerd Nudge Pro - Yearly';
      default:
        return Constants.FREEMIUM;
    }
  }
}