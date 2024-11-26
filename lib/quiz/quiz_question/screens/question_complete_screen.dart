import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_question/screens/question_actions.dart';
import 'package:nerd_nudge/quiz/quiz_question/screens/question_body.dart';
import 'package:nerd_nudge/quiz/quiz_question/screens/question_header.dart';
import 'package:nerd_nudge/quiz/quiz_question/screens/question_options_body.dart';
import 'package:nerd_nudge/quiz/quiz_question/screens/question_timer_body.dart';
import 'package:nerd_nudge/topics/screens/topic_selection_home_page.dart';
import 'package:nerd_nudge/utilities/styles.dart';

import '../../../user_home_page/dto/user_home_stats.dart';

class QuestionScreen extends StatelessWidget {
  QuestionScreen({super.key, required this.completeQuiz});

  final completeQuiz;

  @override
  Widget build(BuildContext context) {
    if (completeQuiz == null) {
      return const Center(
        child: Text(
          'No more questions available.',
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }

    completeQuiz['startTime'] = DateTime.now();
    UserHomeStats().incrementQuizCount();
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: QuestionHeader(
                    topic: TopicSelection.selectedTopic,
                    subtopic: completeQuiz['sub_topic'],
                    difficultyLevel: completeQuiz['difficulty_level'],
                  ),
                ),
                Container(
                  child: QuestionTimer(completeQuiz: completeQuiz,),
                ),
                Styles.getSizedHeightBox(15),
                Container(
                  child: QuestionContainer(
                    questionText: completeQuiz['question'],
                  ),
                ),
                Styles.getSizedHeightBox(15),
                Container(
                  child: PossibleAnswersContainer(
                    completeQuiz: completeQuiz,
                  ),
                ),
                Styles.getSizedHeightBox(15),
                Container(
                  child: QuestionActionButtons(
                    completeQuiz: completeQuiz,
                  ),
                ),
                Styles.getSizedHeightBox(20),
              ],
            ),
          ),
        ),
        //BottomMenu(),
      ],
    );
  }
}
