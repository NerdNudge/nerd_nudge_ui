import 'package:flutter/material.dart';
import 'package:nerd_nudge/topics/screens/explore_topic_selection_home_page.dart';
import 'package:nerd_nudge/topics/screens/topic_selection_home_page.dart';
import 'package:nerd_nudge/utilities/styles.dart';

import '../../quiz_question/screens/question_body.dart';
import '../../quiz_question/screens/question_header.dart';
import 'answers_page_actions.dart';
import 'answers_stats.dart';

class AnswerScreen extends StatelessWidget {
  const AnswerScreen(
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
            child: QuestionHeader(
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
          Styles.getSizedHeightBox(15.0),
          _getTimerEndedInfo(didTimerEnd),
          Container(
            child: QuestionContainer(
              questionText: completeQuiz['question'],
            ),
          ),
          Styles.getSizedHeightBox(15.0),
          Container(
            child: AnswerWithStats(
              completeQuiz: completeQuiz,
              didTimerEnd: didTimerEnd,
            ),
          ),
          Styles.getSizedHeightBox(15.0),
          Container(
            child: AnswersPageActionButtons(
              completeQuiz: completeQuiz,
            ),
          ),
          Styles.getSizedHeightBox(30.0),
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
