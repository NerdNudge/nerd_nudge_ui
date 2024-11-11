import 'package:flutter/material.dart';
import 'package:nerd_nudge/realworld_challenges/quiz_question/services/start_realworld_challenge.dart';
import 'package:nerd_nudge/topics/screens/explore_topic_selection_home_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    RealworldChallengeServiceMainPage.resetCurrentQuizzes();
    return ExploreTopicSelectionHomePage();
  }
}