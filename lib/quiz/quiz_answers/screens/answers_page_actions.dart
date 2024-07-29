
import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_answers/screens/read_more.dart';
import 'package:nerd_nudge/utilities/styles.dart';

import '../../home/screens/quiz_home_page.dart';
import '../../quiz_question/services/start_quiz.dart';

class AnswersPageActionButtons extends StatelessWidget {
  const AnswersPageActionButtons({super.key, required this.completeQuiz});

  final completeQuiz;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadMorePage(completeQuiz: completeQuiz,),
              ),
            );
          },
          style: Styles.getButtonStyle(),
          child: Text(
            'Read More',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
          width: 15.0,
        ),
        TextButton(
          onPressed: () {
            //Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizService(),
              ),
            );
          },
          style: Styles.getButtonStyle(),
          child: Text(
            'Next',
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
