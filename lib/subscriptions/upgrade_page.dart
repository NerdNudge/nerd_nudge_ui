import 'package:flutter/material.dart';
import '../utilities/styles.dart';
import '../bottom_menus/screens/bottom_menu_options.dart';
import '../menus/screens/menu_options.dart';
import '../utilities/colors.dart';

class UpgradePage extends StatelessWidget {
  const UpgradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.getAppBar('Upgrade to Pro'),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text('You have exhausted your daily Quota.\n *** Upgrade your plan to continue ***', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 16,
                      ),),
                      const SizedBox(height: 20),
                      _buildUpgradeCard(
                        context,
                        'NerdNudge Pro',
                        Icons.rocket,
                        'Get 40 daily quizzes and 50 daily shots with no ads!',
                        '\$4.99/month',
                      ),
                      const SizedBox(height: 20),
                      _buildUpgradeCard(
                        context,
                        'NerdNudge Max',
                        Icons.diamond_outlined,
                        'Unlimited daily quizzes and shots with no ads!',
                        '\$5.99/month',
                      ),
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

  Widget _buildUpgradeCard(BuildContext context, String title, IconData icon, String description, String price) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(
          color: Colors.white,
          width: 2,
        ),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: CustomColors.purpleButtonColor,
              size: 60.0,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: CustomColors.purpleButtonColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.purpleButtonColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                // Handle subscription logic here
              },
              child: Text(
                'Upgrade for $price',
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