import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_question/screens/question_actions.dart';
import 'package:nerd_nudge/quiz/quiz_question/screens/question_body.dart';
import 'package:nerd_nudge/quiz/quiz_question/screens/question_header.dart';
import 'package:nerd_nudge/quiz/quiz_question/screens/question_options_body.dart';
import 'package:nerd_nudge/quiz/quiz_question/screens/question_timer_body.dart';
import 'package:nerd_nudge/topics/screens/topic_selection_home_page.dart';

class QuestionScreen extends StatelessWidget {
  QuestionScreen({super.key, required this.completeQuiz});

  final completeQuiz;

  @override
  Widget build(BuildContext context) {
    if (completeQuiz == null) {
      return Center(
        child: Text(
          'No more questions available.',
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }

    completeQuiz['startTime'] = DateTime.now();
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
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: QuestionContainer(
                    questionText: completeQuiz['question'],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: PossibleAnswersContainer(
                    completeQuiz: completeQuiz,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: QuestionActionButtons(
                    completeQuiz: completeQuiz,
                  ),
                ),
              ],
            ),
          ),
        ),
        //BottomMenu(),
      ],
    );
  }
}
