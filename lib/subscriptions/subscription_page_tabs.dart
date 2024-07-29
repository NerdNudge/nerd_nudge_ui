import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';

import '../bottom_menus/screens/bottom_menu_options.dart';
import '../menus/screens/menu_options.dart';
import '../utilities/colors.dart';
import '../utilities/styles.dart';

class SubscriptionPageTabsBased extends StatelessWidget {
  SubscriptionPageTabsBased({super.key});

  final Color freemiumColor = Colors.green;
  final Color proColor = Colors.yellow.shade900;
  final Color maxColor = CustomColors.purpleButtonColor;

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
              child: DefaultTabController(
                length: 3,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SegmentedTabControl(
                        tabTextColor: Colors.white,
                        selectedTabTextColor: Colors.black,
                        indicatorPadding: const EdgeInsets.all(4),
                        squeezeIntensity: 2,
                        tabPadding: const EdgeInsets.symmetric(horizontal: 8),
                        tabs: [
                          SegmentTab(
                            label: 'Freemium',
                            backgroundColor: CustomColors.mainThemeColor,
                            color: CustomColors.purpleButtonColor,
                          ),
                          SegmentTab(
                            label: 'NerdNudge Pro',
                            backgroundColor: CustomColors.mainThemeColor,
                            color: CustomColors.purpleButtonColor,
                          ),
                          SegmentTab(
                            label: 'NerdNudge Max',
                            backgroundColor: CustomColors.mainThemeColor,
                            color: CustomColors.purpleButtonColor,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _getAccountTabDetails(
                            context,
                            'Freemium',
                            Icons.lock_open,
                            'Yes',
                            'Yes',
                            '12',
                            '15',
                            'No',
                            'No',
                            'No',
                            'Free',
                            false,
                          ),
                          _getAccountTabDetails(
                            context,
                            'NerdNudge Pro',
                            Icons.rocket,
                            'Yes',
                            'Yes',
                            '40',
                            '50',
                            'Yes',
                            'Yes',
                            'No',
                            '\$4.99',
                            false,
                          ),
                          _getAccountTabDetails(
                            context,
                            'NerdNudge Max',
                            Icons.diamond_outlined,
                            'Yes',
                            'Yes',
                            'Unlimited',
                            'Unlimited',
                            'Yes',
                            'Yes',
                            'Yes',
                            '\$5.99',
                            true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _getCardBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Color _getAccountColor(String accountType) {
    switch (accountType) {
      case 'NerdNudge Max':
        return maxColor;
      case 'NerdNudge Pro':
        return proColor;
      default:
        return freemiumColor;
    }
  }

  Widget _getAccountTabDetails(
      BuildContext context,
      String accountType,
      IconData icon,
      String insights,
      String challenges,
      String quizQuota,
      String shotsQuota,
      String adsFree,
      String prioritySupport,
      String exclusiveContent,
      String monthlyPrice,
      bool isPopular,
      ) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        padding: const EdgeInsets.all(10.0),
        decoration: _getCardBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5.0),
            _getMostPopularContainer(isPopular),
            const SizedBox(height: 20.0),
            Icon(
              icon,
              color: _getAccountColor(accountType),
              size: 80.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              accountType,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: _getAccountColor(accountType),
              ),
            ),
            Styles.getColoredDivider(_getAccountColor(accountType)),
            const SizedBox(height: 20.0),
            _getContentRow('Insights: ', insights, accountType),
            const SizedBox(height: 5.0),
            _getContentRow('Challenges: ', challenges, accountType),
            const SizedBox(height: 5.0),
            _getContentRow('Daily Quiz Quota: ', quizQuota, accountType),
            const SizedBox(height: 5.0),
            _getContentRow('Daily Shots Quota: ', shotsQuota, accountType),
            const SizedBox(height: 10.0),
            _getContentRow('Ads Free: ', adsFree, accountType),
            const SizedBox(height: 10.0),
            _getContentRow('Priority Support: ', prioritySupport, accountType),
            const SizedBox(height: 10.0),
            _getContentRow('Exclusive Content: ', exclusiveContent, accountType),
            const SizedBox(height: 10.0),
            _getContentRow('Monthly Price: ', monthlyPrice, accountType),
            const SizedBox(height: 50.0),
            Styles.getElevatedButton(
              'Current Plan',
              CustomColors.purpleButtonColor,
              Colors.white,
              context,
                  (p0) => null,
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _getMostPopularContainer(bool isPopular) {
    if (isPopular) {
      return Text(
        '[ MOST POPULAR ]',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade900,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getContentRow(String message, String value, String accountType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.circle, color: Colors.black, size: 8.0),
        const SizedBox(width: 10.0),
        Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 5.0),
        _getIconOrText(value, accountType),
      ],
    );
  }

  Widget _getIconOrText(String value, String accountType) {
    if (value == 'Yes') {
      return const Icon(
        Icons.check,
        color: Colors.green,
        size: 25,
      );
    } else if (value == 'No') {
      return const Icon(
        Icons.close,
        color: Colors.red,
        size: 25,
      );
    } else {
      return Text(
        value,
        style: TextStyle(
          fontSize: 16,
          color: _getAccountColor(accountType),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    }
  }
}