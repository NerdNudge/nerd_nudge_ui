import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nerd_nudge/utilities/styles.dart';

import '../bottom_menus/screens/bottom_menu_options.dart';
import '../menus/screens/menu_options.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    var freemiumBenefits = json.decode('{}');
    return Scaffold(
      appBar: Styles.getAppBar('Subscriptions'),
      drawer: MenuOptions.getMenuDrawer(context),
      bottomNavigationBar: const BottomMenu(),
      body: Container(
        decoration: Styles.getBackgroundBoxDecoration(),
        child: SingleChildScrollView(  // Wrap the content in a SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildPlanCard(
                  context,
                  planName: 'Freemium',
                  price: 'Free',
                  quizQuota: '12 Quizzes/day',
                  shotsQuota: '15 Nerd Shots/day',
                  benefits: ['Basic Access', 'Includes Ads'],
                  isPremium: false,
                ),
                const SizedBox(height: 20),
                _buildPlanCard(
                  context,
                  planName: 'NerdNudge Pro',
                  price: '\$4.99/month',
                  quizQuota: '40 Quizzes/day',
                  shotsQuota: '50 Nerd Shots/day',
                  benefits: ['No Ads', 'Priority Support'],
                  isPremium: true,
                ),
                const SizedBox(height: 20),
                _buildPlanCard(
                  context,
                  planName: 'NerdNudge Max',
                  price: '\$5.99/month',
                  quizQuota: 'Unlimited Quizzes/day',
                  shotsQuota: 'Unlimited Nerd Shots/day',
                  benefits: ['No Ads', 'Priority Support', 'Exclusive Content'],
                  isPremium: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context,
      {required String planName,
        required String price,
        required String quizQuota,
        required String shotsQuota,
        required List<String> benefits,
        required bool isPremium}) {
    return Card(
      color: Colors.black38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(
          color: Colors.black38,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              planName,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: isPremium ? Color(0xFF6A69EB) : Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              price,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  Icons.quiz,
                  size: 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  quizQuota,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  size: 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  shotsQuota,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              'Benefits:',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5.0),
            ...benefits.map((benefit) => Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 2.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    size: 20,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    benefit,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 20.0),
            ElevatedButton(
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
                isPremium ? 'Subscribe' : 'Continue',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}