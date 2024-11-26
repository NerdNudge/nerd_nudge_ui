import 'package:flutter/material.dart';
import '../../../menus/screens/menu_options.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/styles.dart';
import '../../../bottom_menus/screens/bottom_menu_options.dart';

class ChallengeDetailPage extends StatelessWidget {
  final Map<String, dynamic> challenge;
  final bool joined;

  ChallengeDetailPage({required this.challenge, required this.joined});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar(challenge['name']),
        drawer: MenuOptions.getMenuDrawer(context),
        body: _getBody(context),
        bottomNavigationBar: const BottomMenu(),
      ),
    );
  }

  _getBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Styles.getSizedHeightBoxByScreen(context, 20),
            Text(
              challenge['description'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.purpleButtonColor,
              ),
            ),
            Styles.getSizedHeightBoxByScreen(context, 20),
            Row(
              children: [
                const Icon(Icons.folder, color: Colors.white70),
                Styles.getSizedWidthBoxByScreen(context, 10),
                Text(
                  'Type: ${challenge['type']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            Styles.getSizedHeightBoxByScreen(context, 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white70),
                Styles.getSizedWidthBoxByScreen(context, 10),
                Text(
                  'Start Date: ${challenge['startDate']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            Styles.getSizedHeightBoxByScreen(context, 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white70),
                Styles.getSizedWidthBoxByScreen(context, 10),
                Text(
                  'End Date: ${challenge['endDate']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            Styles.getSizedHeightBoxByScreen(context, 10),
            Row(
              children: [
                const Icon(Icons.group, color: Colors.white70),
                SizedBox(width: 10.0),
                Text(
                  '${challenge['members']} members joined',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.white70),
                SizedBox(width: 10.0),
                Text(
                  '${challenge['prizes']} prizes',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Text(
              'Pro Tip:',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: CustomColors.purpleButtonColor,
              ),
            ),
            SizedBox(height: 10,),
            Text(
              'Improve your challenge rank by taking quizzes between the start and end dates as often as you can.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Styles.getElevatedButton(
                  'Cancel',
                  Colors.white70,
                  Colors.black,
                  context,
                      (ctx) => Navigator.pop(context),
                ),
                SizedBox(width: 20,),
                Styles.getElevatedButton(
                  _getJoinButtonText(),
                  CustomColors.purpleButtonColor,
                  Colors.white,
                  context,
                      (ctx) => joinChallenge(ctx),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getJoinButtonText() {
    return joined ? 'Quit Challenge' : 'Join';
  }

  joinChallenge(BuildContext ctx) {

  }
}
