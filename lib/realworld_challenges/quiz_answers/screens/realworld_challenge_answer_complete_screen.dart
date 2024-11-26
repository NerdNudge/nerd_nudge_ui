import 'package:flutter/material.dart';
import 'package:nerd_nudge/topics/screens/explore_topic_selection_home_page.dart';
import 'package:nerd_nudge/utilities/styles.dart';

import '../../quiz_question/screens/realworld_challenge_body.dart';
import '../../quiz_question/screens/realworld_challenge_header.dart';
import 'realworld_challenge_answers_page_actions.dart';
import 'realworld_challenge_answers_stats.dart';

class RealworldChallengeAnswerScreen extends StatelessWidget {
  const RealworldChallengeAnswerScreen(
      {super.key,
      required this.completeQuiz,
      required this.didTimerEnd,
      required this.timeTaken});

  final completeQuiz;
  final bool didTimerEnd;
  final double timeTaken;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('Answer Details'),
        //drawer: MenuOptions.getMenuDrawer(context),
        body: _getBody(),
        //bottomNavigationBar: BottomMenu(),
      ),
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: RealworldChallengeHeader(
              topic: ExploreTopicSelection.selectedTopic,
              subtopic: completeQuiz['sub_topic'],
              difficultyLevel: completeQuiz['difficulty_level'],
            ),
          ),
          Container(
            height: 4, // Height of the horizontal bar
            width: double.infinity, // Width of the horizontal bar
            color: const Color(0xFF252d3c),
          ),
          const SizedBox(
            height: 15.0,
          ),
          _getTimerEndedInfo(didTimerEnd),
          Container(
            child: RealworldChallengeContainer(
              questionText: completeQuiz['question'],
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            child: RealworldChallengeAnswerWithStats(
              completeQuiz: completeQuiz,
              didTimerEnd: didTimerEnd,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            child: RealworldChallengeAnswersPageActionButtons(
              completeQuiz: completeQuiz,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTimerEndedInfo(bool didTimerEnd) {
    return Center(
      child: Text(
        didTimerEnd ? '** Time Out **' : '** Time Taken: ${timeTaken.toStringAsFixed(2)} secs',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: didTimerEnd ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}
