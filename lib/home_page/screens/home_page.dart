import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nerd_nudge/user_profile/dto/user_profile_entity.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/startup_welcome_messages.dart';
import '../../../utilities/styles.dart';
import '../../../bottom_menus/screens/bottom_menu_options.dart';
import '../../insights/screens/user_insights_main_page.dart';
import '../../menus/screens/menu_options.dart';
import '../../nerd_shots/screens/shots_home.dart';
import '../../quiz/home/screens/quiz_home_page.dart';
import '../../subscriptions/subscription_page_tabs.dart';
import '../dto/user_home_stats.dart';
import '../services/home_page_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.userFullName, required this.userEmail});

  final String userFullName;
  final String userEmail;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserHomeStats> _futureUserHomeStats;

  @override
  void initState() {
    super.initState();
    print('uname: ${widget.userFullName}, email: ${widget.userEmail}');
    UserProfileEntity userProfileEntity = UserProfileEntity();
    userProfileEntity.setUserFullName(widget.userFullName);
    userProfileEntity.setUserEmail(widget.userEmail);

    print('Home page: User fullName: ${userProfileEntity.getUserFullName()}, User Email: ${userProfileEntity.getUserEmail()}');
    _futureUserHomeStats = HomePageService().getUserHomePageStats();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('Nerd Home'),
        drawer: MenuOptions.getMenuDrawer(context),
        body: FutureBuilder<UserHomeStats>(
          future: _futureUserHomeStats,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return _getHomePageBody(context, snapshot.data!);
            } else {
              return const Center(child: Text('No data found'));
            }
          },
        ),
        bottomNavigationBar: const BottomMenu(),
      ),
    );
  }

  Widget _getHomePageBody(BuildContext context, UserHomeStats userHomeStats) {
    String message = WelcomeMessages.messages
        .elementAt(Random().nextInt(WelcomeMessages.messages.length));

    String quoteOfTheDay = userHomeStats.quoteOfTheDay;
    String quoteAuthor = userHomeStats.quoteAuthor;
    String quoteId = userHomeStats.quoteId;

    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            child: Container(
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
                padding: const EdgeInsets.only(bottom: 200.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/NN_icon_2.png',
                      height: 100, // Adjust the size as needed
                      width: 100,
                    ),
                    const SizedBox(height: 10), // Space between logo and text
                    const Text(
                      'Nerd Nudge',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 50,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildNerdNudgeQuoteCard(message),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.school_rounded,
                              label: 'NERD QUIZ',
                              color: CustomColors.purpleButtonColor,
                              onPressed: () => onStartQuiz(context),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.lightbulb,
                              label: 'NERD SHOTS',
                              color: Colors.white,
                              textColor: Colors.black,
                              onPressed: () => onNerdShots(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    _getPurpleDivider(),

                    const SizedBox(height: 20),
                    _buildSectionTitle('Nerd Statistics'),
                    _buildNerdStatsCard(userHomeStats),
                    _getPurpleDivider(),
                    const SizedBox(height: 20),

                    _buildSectionTitle('Daily Nerd Quota'),
                    _buildNerdQuotaCard(userHomeStats),
                    _getPurpleDivider(),
                    const SizedBox(height: 20),

                    _buildSectionTitle('Quote of the day'),
                    Styles.buildQuoteCard(context, quoteOfTheDay, quoteAuthor, quoteId),
                    _getPurpleDivider(),
                    const SizedBox(height: 20),
                    _buildNumPeopleCard(userHomeStats),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
      label: Text(
        label,
        style: TextStyle(
            color: textColor, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }

  Widget _getStatsTitle(String message) {
    return Text(
      message,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black54,
        fontSize: 16,
      ),
    );
  }

  Widget _getStatsValue(String message) {
    return Text(
      message,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }

  Widget _buildNerdQuotaCard(UserHomeStats userHomeStats) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        children: [
          Card(
            color: CustomColors.purpleButtonColor,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(
                      'Quizzes Remaining',
                      'Shots Remaining',
                      userHomeStats.getDailyQuizRemaining().toString(),
                      userHomeStats.getDailyShotsRemaining().toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Styles.buildNextActionButton(
              context, 'UPGRADE', 0, SubscriptionPageTabsBased()),
        ],
      ),
    );
  }

  Widget _buildNerdStatsCard(UserHomeStats userHomeStats) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        children: [
          Card(
            color: CustomColors.purpleButtonColor,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(
                      'Total Quizzes',
                      'Percentage Correct',
                      userHomeStats.getTotalQuizzesAttempted().toString(),
                      '${userHomeStats.getTotalPercentageCorrect().toString()} %'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Card(
            color: CustomColors.purpleButtonColor,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(
                      'Highest in a Day',
                      'Highest Correct in a Day',
                      userHomeStats.getHighestInADay().toString(),
                      userHomeStats.getHighestCorrectInADay().toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Card(
            color: CustomColors.purpleButtonColor,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(
                      'Current Streak',
                      'Highest Streak',
                      userHomeStats.getCurrentStreak().toString(),
                      userHomeStats.getHighestStreak().toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Styles.buildNextActionButton(context, 'VIEW MORE', 3, UserInsights()),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
      String title1, String title2, String value1, String value2) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getStatsTitle(title1),
            _getStatsTitle(title2),
          ],
        ),
        const SizedBox(height: 6.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getStatsValue(value1),
            _getStatsValue(value2),
          ],
        ),
      ],
    );
  }

  Widget _buildSingleStatRow(String title, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getStatsTitle(title),
            const SizedBox(width: 16), // Balance alignment
          ],
        ),
        const SizedBox(height: 6.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getStatsValue(value),
            const SizedBox(width: 16), // Balance alignment
          ],
        ),
      ],
    );
  }

  Widget _buildNerdNudgeQuoteCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Text(
        message,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildNumPeopleCard(UserHomeStats userHomeStats) {
    int numPeople = userHomeStats.numPeopleUsedNerdNudge;
    String message = '$numPeople People used Nerd Nudge today.';
    return Card(
      color: CustomColors.purpleButtonColor,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _getPurpleDivider() {
    return const Divider(
      color: Color(0xFF6A69EB),
      thickness: 1,
      indent: 25,
      endIndent: 25,
    );
  }

  void onStartQuiz(BuildContext context) {
    BottomMenu.updateIndex(1);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizHomePage(),
      ),
    );
  }

  void onNerdShots(BuildContext context) {
    BottomMenu.updateIndex(2);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NerdShotsHome(),
      ),
    );
  }
}
