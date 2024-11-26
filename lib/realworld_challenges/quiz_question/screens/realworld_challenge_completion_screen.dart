import 'package:flutter/material.dart';
import 'package:nerd_nudge/topics/screens/explore_topic_selection_home_page.dart';
import 'package:nerd_nudge/topics/services/topics_service.dart';
import '../../../bottom_menus/screens/bottom_menu_options.dart';
import '../../../menus/screens/menu_options.dart';
import '../../../user_home_page/screens/home_page.dart';
import '../../../user_profile/dto/user_profile_entity.dart';
import '../../../utilities/styles.dart';
import '../services/start_realworld_challenge.dart';

class RealworldChallengeCompletionScreen extends StatelessWidget {
  const RealworldChallengeCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TopicsService().invalidateTopicsCache();
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('Challenge Completed'),
        drawer: MenuOptions.getMenuDrawer(context),
        bottomNavigationBar: const BottomMenu(),
        body: _getBody(context),
      ),
    );
  }

  Widget _getBody(BuildContext context) {
    final int totalQuestions = RealworldChallengeServiceMainPage.totalDailyQuiz;
    final int correctAnswers = RealworldChallengeServiceMainPage.correctAnswers;
    final String topic = ExploreTopicSelection.selectedTopic;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFD1C4E9), // Light purple with a hint of lavender for a soft start
            Color(0xFFB39DDB), // Medium lavender for a smooth gradient transition
            Color(0xFF9575CD), // Deeper purple-blue to add a bit of depth
            Color(0xFF6A69EB), // Slightly darker lavender to provide contrast
            Color(0xFFD1C4E9), // Returning to light purple for symmetry
          ],
          stops: [0.1, 0.3, 0.5, 0.7, 0.9], // Create smooth transitions
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Completion Badge
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(20.0),
              child: const Icon(
                Icons.emoji_events_rounded,
                size: 80,
                color: Color(0xFF7E57C2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Congratulations!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Challenge Completion Summary
            Text("You completed today’s Real-World Challenge in $topic.",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildStatRow("Total Questions:", "$totalQuestions"),
                  const SizedBox(height: 10),
                  _buildStatRow("Correct Answers:", "$correctAnswers"),
                  const SizedBox(height: 10),
                  _buildStatRow("Accuracy:", "${((correctAnswers / totalQuestions) * 100).toStringAsFixed(1)}%"),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // CTA Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    UserProfileEntity userProfileEntity = UserProfileEntity();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(userFullName: userProfileEntity.getUserFullName(), userEmail: userProfileEntity.getUserEmail(),),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    backgroundColor: const Color(0xFF6A69EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}