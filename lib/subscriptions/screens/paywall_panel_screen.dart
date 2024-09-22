import 'package:flutter/material.dart';
import 'package:nerd_nudge/subscriptions/services/paywall_upgrade_messages.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../user_home_page/screens/home_page.dart';
import '../../user_profile/dto/user_profile_entity.dart';
import '../../utilities/styles.dart';
import '../services/purchase_api.dart';

class PaywallPanel {
  static List<Package> _packages = [];

  static Widget getSlidingPanel(
      BuildContext context, PanelController panelController, String page) {
    final List<Offering> offerings = PurchaseAPI.offerings;
    print('Offerings under Paywall Panel: $offerings');

    _packages = offerings.map((offering) {
          return offering.availablePackages!;
        })
        .expand((pkgList) => pkgList)
        .toList();
    return SlidingUpPanel(
      controller: panelController,
      color: Colors.grey.shade900,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.55,
      panel: Container(
        decoration: Styles.getBoxDecorationForPaywall(),
        child: _buildPaywallPanel(context, page),
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      backdropEnabled: true,
      backdropTapClosesPanel: true,
    );
  }

  static Widget _buildPaywallPanel(BuildContext context, String page) {
    String upgradeMessage = PaywallMessages.getRandomMessage(page);
    return _packages.isEmpty ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Upgrade Your Plan',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54),
                ),
              ),
              Styles.getSizedHeightBox(4),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Text(
                  upgradeMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white54,
                      height: 1.5),
                ),
              ),
              Styles.getSizedHeightBox(20),
              Expanded(
                child: ListView.builder(
                  itemCount: _packages.length,
                  itemBuilder: (context, index) {
                    final package = _packages[index];
                    return Card(
                      elevation: 4,
                      color: Colors.white38,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getSubstring(package.storeProduct.title),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            Styles.getSizedHeightBox(15),
                          ],
                        ),
                        subtitle: Text(
                          package.storeProduct.description.isNotEmpty
                              ? package.storeProduct.description
                              : 'Unlock Nerd Nudge Pro and enjoy unlimited Nerd Quizflexes and Nerd Shots.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        trailing: Text(
                          package.storeProduct.priceString,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        onTap: () {
                          _purchasePackage(package, context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }

  static void _purchasePackage(Package package, BuildContext context) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      await Future.delayed(const Duration(seconds: 1));
      if (customerInfo.entitlements.all['pro']?.isActive == true) {
        if (!context.mounted) return;
        Styles.showGlobalSnackbarMessage('Purchase successful! You are now a pro user.');
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(), // Show the loading spinner
            );
          },
        );

        PurchaseAPI.updateNerdNudgeOfferings();
        PurchaseAPI.updateCurrentOffer();
        await Future.delayed(const Duration(seconds: 3));

        if (!context.mounted) return;
        Navigator.of(context).pop();

        UserProfileEntity userProfileEntity = UserProfileEntity();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(userFullName: userProfileEntity.getUserFullName(), userEmail: userProfileEntity.getUserEmail())),
        );
      }
    } catch (e) {
      Styles.showGlobalSnackbarMessage('Purchase failed: $e');
    }
  }

  static String _getSubstring(String input) {
    int index = input.indexOf('(');
    if (index != -1) {
      return input.substring(0, index).trim();
    }
    return input;
  }
}
