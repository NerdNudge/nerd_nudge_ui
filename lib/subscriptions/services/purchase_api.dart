import 'package:flutter/services.dart';
import 'package:nerd_nudge/utilities/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io' show Platform;

import '../../utilities/constants.dart';

class PurchaseAPI {
  static const _apikeyAndroid = 'goog_bcIotbsIPCTidmmXUaBxzGKHFYu';
  static const _apikeyIOS = 'appl_BhHEoHAfyozvdsLdyCmtozzwgxc';

  static List<Offering> _offerings = [];
  static String _userCurrentOffering = '';

  static get offerings => _offerings;
  static get userCurrentOffering => _userCurrentOffering;


  static Future init() async {
    NerdLogger.logger.d('initializing purchase api');
    await configurePurchases();
    await updateCurrentOffer();
    updateNerdNudgeOfferings();
  }

  static Future<void> configurePurchases() async {
    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_apikeyAndroid);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(_apikeyIOS);
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    await Purchases.configure(configuration);
    NerdLogger.logger.d('purchase api configured');
  }

  static Future<void> updateNerdNudgeOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      NerdLogger.logger.d('updated offerings: $offerings');
      _offerings = offerings.all.values.toList();
    } on PlatformException catch (e) {
      NerdLogger.logger.e('Error fetching offerings: $e');
    }
  }

  static Future<void> updateCurrentOffer() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.active.isNotEmpty) {
        EntitlementInfo activeEntitlement = customerInfo.entitlements.active.values.first;
        _userCurrentOffering = _getOfferDisplayName(activeEntitlement.identifier);
      } else {
        _userCurrentOffering = Constants.FREEMIUM;
      }
      NerdLogger.logger.d('updated current offering: $_userCurrentOffering');
    } catch (e) {
      NerdLogger.logger.e('Error fetching customer info: $e');
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