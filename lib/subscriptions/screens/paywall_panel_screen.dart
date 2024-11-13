import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nerd_nudge/explore_menu/screens/explore_home_page.dart';
import 'package:nerd_nudge/insights/screens/topics_insights/topics_insights_main_page.dart';
import 'package:nerd_nudge/subscriptions/services/paywall_upgrade_messages.dart';
import 'package:nerd_nudge/utilities/colors.dart';
import 'package:nerd_nudge/utilities/utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../insights/screens/user_insights_main_page.dart';
import '../../realworld_challenges/quiz_question/services/start_realworld_challenge.dart';
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

    _packages = offerings
        .map((offering) {
          return offering.availablePackages!;
        })
        .expand((pkgList) => pkgList)
        .toList();
    String upgradeMessage = PaywallMessages.getRandomMessage(page);
    return SlidingUpPanel(
      controller: panelController,
      color: Colors.grey.shade900,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.55,
      panel: Container(
        decoration: Styles.getBoxDecorationForPaywall(),
        child: buildUpgradeAccountPaywallPanel(context, upgradeMessage),
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      backdropEnabled: true,
      backdropTapClosesPanel: true,
    );
  }

  static Widget buildUpgradeAccountPaywallPanel(
      BuildContext context, String upgradeMessage) {
    return _packages.isEmpty
        ? Center(child: CircularProgressIndicator())
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

      if (customerInfo.entitlements.all['nerdnudgepro_399_1m']?.isActive ==
              true ||
          customerInfo.entitlements.all['nerdnudgepro_3999_1y']?.isActive ==
              true ||
          customerInfo.entitlements.all['nerdnudgepro_399_1m_ios']?.isActive ==
              true ||
          customerInfo.entitlements.all['nerdnudgepro_3999_1y_ios']?.isActive ==
              true) {
        //if (!context.mounted) return;
        Styles.showMessageDialog(
            context, 'Purchase successful!', 'You are now a pro user.');
        Styles.showGlobalSnackbarMessage(
            'Purchase successful! You are now a pro user.');
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

        if (context.mounted) Navigator.of(context).pop();

        UserProfileEntity userProfileEntity = UserProfileEntity();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                  userFullName: userProfileEntity.getUserFullName(),
                  userEmail: userProfileEntity.getUserEmail())),
        );
      } else {
        Styles.showMessageDialog(
            context, 'No Entitlements', 'No active Pro entitlement found.');
        Styles.showGlobalSnackbarMessage('No active Pro entitlement found.');
      }
    } catch (e) {
      Styles.showGlobalSnackbarMessage('Purchase failed: $e');
      Styles.showMessageDialog(
          context, 'Purchase Failure', 'Purchase failed: $e');
    }
  }

  static String _getSubstring(String input) {
    int index = input.indexOf('(');
    if (index != -1) {
      return input.substring(0, index).trim();
    }
    return input;
  }

  static Widget buildDailyChallengePaywallPanel(
      BuildContext context, String topic, String topicCode, Map<String, dynamic> userStats) {
    final today = Utils.getDaystamp();
    Map<String, dynamic> rwc = userStats[topicCode]?['rwc'] ?? {};
    final challengeTakenToday = rwc.containsKey(today);
    print('Under paywall: $today, $rwc, $topic, $topicCode, $userStats, $challengeTakenToday');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Styles.getSizedHeightBox(10),
        Center(
          child: Text(
            topic,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        Styles.getSizedHeightBox(10),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Daily Real-World Challenge',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        Styles.getSizedHeightBox(5),
        _buildLastSevenDaysChallenges(rwc),
        Styles.getSizedHeightBox(10),
        Styles.getDivider(),
        Styles.getSizedHeightBox(10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: _getChallengePaywallMessage(challengeTakenToday),
        ),
        Styles.getSizedHeightBox(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 24, color: Colors.white54),
            Styles.getSizedWidthBox(10),
            Text(
              '10 Questions',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white54,
                  height: 1.5),
            ),
            Styles.getSizedWidthBox(20),
            Text(
              '|',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white54,
                  height: 1.5),
            ),
            Styles.getSizedWidthBox(20),
            Icon(Icons.timer_outlined, size: 24, color: Colors.white54),
            Styles.getSizedWidthBox(10),
            Text(
              '8 Minutes',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white54,
                  height: 1.5),
            ),
          ],
        ),
        Styles.getSizedHeightBox(40),
        if (challengeTakenToday)
          Styles.buildNextActionButton(context, 'CLOSE', 3, ExplorePage())
        else
          Styles.buildNextActionButton(context, 'START NOW', 3, RealworldChallengeServiceMainPage()),
      ],
    );
  }

  static Widget _buildLastSevenDaysChallenges(Map<String, dynamic> rwc) {
    final today = DateTime.now();
    final lastSevenDays = List.generate(7, (index) => today.subtract(Duration(days: 6 - index)));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: lastSevenDays.map((date) {
              final dayOfWeek = DateFormat('E').format(date);
              final daystamp = Utils.formatDateAsDaystamp(date); // Get daystamp for each date
              bool challengeTaken = rwc.containsKey(daystamp);

              // Retrieve total questions and correct answers, then calculate percentage
              final challengeData = rwc[daystamp] ?? [0, 0];
              final totalQuestions = challengeData[0];
              final correctAnswers = challengeData[1];
              final percentage = totalQuestions > 0
                  ? ((correctAnswers / totalQuestions) * 100).toStringAsFixed(1)
                  : '0';

              return Column(
                children: [
                  Text(
                    dayOfWeek, // Display as short weekday format, e.g., "Mon", "Tue"
                    style: TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Styles.getSizedHeightBox(10),
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: challengeTaken
                            ? [Colors.red, Colors.deepOrange, Colors.yellow, Colors.green]
                            : [Colors.grey, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds);
                    },
                    child: Icon(
                      challengeTaken ? Icons.whatshot : Icons.whatshot_outlined, // Fire icons
                      size: 24,
                      color: Colors.white, // Apply the gradient to the icon
                    ),
                  ),
                  Styles.getSizedHeightBox(8),
                  Text(
                    '$percentage%', // Display the calculated percentage
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  static _getChallengePaywallMessage(bool isChallengeTakenToday) {
    String textMessage = '';
    if(isChallengeTakenToday) {
      textMessage = 'Today\'s challenge already taken!';
    }
    else {
      textMessage = 'Solve practical problems inspired by real-world scenarios.';
    }

    return Text(
      textMessage,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.white54,
          height: 1.5),
    );
  }
}
