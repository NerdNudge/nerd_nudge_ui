import 'package:flutter/material.dart';
import 'package:nerd_nudge/utilities/styles.dart';

import '../bottom_menus/screens/bottom_menu_options.dart';
import '../menus/screens/menu_options.dart';

class SubscriptionComparisonPage extends StatelessWidget {
  const SubscriptionComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.getAppBar('Subscriptions'),
      drawer: MenuOptions.getMenuDrawer(context),
      bottomNavigationBar: const BottomMenu(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: Styles.getBackgroundBoxDecoration(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildTableHeader(),
                      const SizedBox(height: 30),
                      _buildTableRow('Insights', 'Yes', 'Yes', 'Yes'),
                      const SizedBox(height: 20),
                      _buildTableRow('Challenges', 'Yes', 'Yes', 'Yes'),
                      const SizedBox(height: 20),
                      _buildTableRow('Daily Quiz Quota', '12', '40', 'Unlimited'),
                      const SizedBox(height: 20),
                      _buildTableRow('Daily Shots Quota', '15', '50', 'Unlimited'),
                      const SizedBox(height: 20),
                      _buildTableRow('No Ads', 'No', 'Yes', 'Yes'),
                      const SizedBox(height: 20),
                      _buildTableRow('Priority Support', 'No', 'Yes', 'Yes'),
                      const SizedBox(height: 20),
                      _buildTableRow('Exclusive Content', 'No', 'No', 'Yes'),
                      const SizedBox(height: 20),
                      _buildTableRow('Monthly Price', 'Free', '\$4.99', '\$5.99'),
                      const SizedBox(height: 20),
                      /*_buildSubscribeButton(context, 'Freemium', 'Free', false),
                      const SizedBox(height: 20),
                      _buildSubscribeButton(context, 'Pro', '\$4.99/mnth', true),
                      const SizedBox(height: 20),
                      _buildSubscribeButton(context, 'Max', '\$5.99/mnth', true),*/
                      const SizedBox(height: 20),
                      _getButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Text(
            'Plan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: _buildSubscribeButton1(context, true),
        ),
        SizedBox(width: 10,),
        Expanded(
          child: _buildSubscribeButton1(context, false),
        ),
        SizedBox(width: 10,),
        Expanded(
          child: _buildSubscribeButton1(context, false),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        Expanded(
          child: Text(
            '',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            'Freemium',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            'Pro',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            'Max',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  _getIconOrText(String value) {
    if(value == 'Yes') {
      return const Icon(
        Icons.check,
        color: Colors.green,
        size: 25,
      );
    } else if( value == 'No') {
      return const Icon(
        Icons.close,
        color: Colors.red,
        size: 25,
      );
    }

    return Text(
      value,
      style: const TextStyle(fontSize: 16, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTableRow(String feature, String freemium, String pro, String max) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Text(
            feature,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: _getIconOrText(freemium),
        ),
        Expanded(
          child: _getIconOrText(pro),
        ),
        Expanded(
          child: _getIconOrText(max),
        ),
      ],
    );
  }

  Widget _buildSubscribeButton(BuildContext context, String planName, String price, bool isPremium) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF6A69EB),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        // Handle subscription logic here
      },
      child: Text(
        isPremium ? 'Subscribe to $planName - $price' : '$planName - $price',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubscribeButton1(BuildContext context, bool isCurrent) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF6A69EB),
        minimumSize: const Size(double.infinity, 35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        // Handle subscription logic here
      },
      child: Text(
        isCurrent ? 'Current' : 'Subscribe',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}