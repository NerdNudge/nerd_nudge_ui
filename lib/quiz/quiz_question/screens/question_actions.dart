import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_question/screens/question_utils.dart';
import 'package:nerd_nudge/user/rankings.dart';
import 'package:nerd_nudge/user/scores.dart';

import '../../../../utilities/styles.dart';
import '../../quiz_answers/screens/answer_complete_screen.dart';

class QuestionActionButtons extends StatelessWidget {
  const QuestionActionButtons({super.key, required this.completeQuiz});

  final completeQuiz;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          onPressed: () {
            var sub = completeQuiz['selected_answers'];
            print('submit pressed: $sub');

            bool isAnswerCorrect = QuestionUtils.isAnswerCorrect(completeQuiz, false);
            UserScores.updateUserScore(completeQuiz['difficulty_level'], isAnswerCorrect);
            UserRankings.updateUserRank(completeQuiz['difficulty_level'], isAnswerCorrect);
            DateTime endTime = DateTime.now();
            double differenceInSeconds = endTime.difference(completeQuiz['startTime']).inMilliseconds / 1000.0;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnswerScreen(completeQuiz: completeQuiz, didTimerEnd: false, timeTaken: differenceInSeconds,),
              ),
            );
          },
          style: Styles.getButtonStyle(),
          child: const Text(
            'Submit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
          width: 25.0,
        ),
      ],
    );
  }
}
