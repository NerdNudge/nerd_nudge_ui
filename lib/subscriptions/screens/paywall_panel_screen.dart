import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../utilities/styles.dart';
import '../services/purchase_api.dart';

class PaywallPanel {
  static List<Package> _packages = [];

  static Widget getSlidingPanel(BuildContext context, PanelController panelController) {
    final List<Offering> offerings = PurchaseAPI.offerings;
    print('Offerings under Paywall Panel: $offerings');

    _packages = offerings
        .map((offering) { return offering.availablePackages!; })
        .expand((pkgList) => pkgList)
        .toList();

    return SlidingUpPanel(
      controller: panelController,
      color: Colors.grey.shade900,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.55,
      panel: Container(
        decoration: Styles.getBoxDecorationForPaywall(),
        child: _buildPaywallPanel(context),
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      backdropEnabled: true, // Adds a backdrop that can also be clicked
      backdropTapClosesPanel:
          true, // Allows tapping on the backdrop to close the panel
    );
  }

  static Widget _buildPaywallPanel(BuildContext context) {
    return _packages.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Upgrade Your Plan',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _packages.length,
                  itemBuilder: (context, index) {
                    final package = _packages[index];
                    return Card(
                      elevation: 4,
                      //color: Color(0xFF2a295d),
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
      if (customerInfo.entitlements.all['pro']?.isActive == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Purchase successful! You are now a pro user.')),
        );
        PurchaseAPI.updateNerdNudgeOfferings();
        PurchaseAPI.updateCurrentOffer();
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase failed: $e')),
      );
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
