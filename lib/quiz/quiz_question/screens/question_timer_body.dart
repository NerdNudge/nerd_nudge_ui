import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:nerd_nudge/quiz/quiz_question/screens/question_utils.dart';
import 'package:nerd_nudge/utilities/styles.dart';

import '../../../user/rankings.dart';
import '../../../user/scores.dart';
import '../../quiz_answers/screens/answer_complete_screen.dart';

class QuestionTimer extends StatelessWidget {
  const QuestionTimer({super.key, required this.completeQuiz});

  final completeQuiz;

  @override
  Widget build(BuildContext context) {
    return LinearTimer(
      duration: Duration(seconds: completeQuiz['time_limit_secs']),

      onTimerEnd: () {
        print('Timer Ended !!!');

        bool isAnswerCorrect = QuestionUtils.isAnswerCorrect(completeQuiz, true);

        UserScores.updateUserScore(completeQuiz['difficulty_level'], isAnswerCorrect);
        UserRankings.updateUserRank(completeQuiz['difficulty_level'], isAnswerCorrect);

        Styles.showGlobalSnackbarMessageAndIcon('** Time Out **', FontAwesomeIcons.hourglassHalf, Colors.black);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnswerScreen(completeQuiz: completeQuiz, didTimerEnd: true, timeTaken: 10,),
          ),
        );
      },
      color: Color(0xFF252d3c),
    );
  }
}

