import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_answers/screens/read_more.dart';
import '../../../utilities/colors.dart';
import '../../home/screens/quiz_home_page.dart';
import '../../quiz_question/services/start_quiz.dart';

class AnswersPageActionButtons extends StatelessWidget {
  const AnswersPageActionButtons({super.key, required this.completeQuiz});

  final completeQuiz;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadMorePage(completeQuiz: completeQuiz),
              ),
            );
          },
          icon: Icon(Icons.info_outline, color: Colors.white),
          label: Text(
            'Info',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.mainThemeColor,
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizService(),
              ),
            );
          },
          icon: Icon(Icons.navigate_next, color: Colors.white),
          label: Text(
            'Next',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.mainThemeColor,
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizHomePage(),
              ),
            );
          },
          icon: Icon(Icons.close, color: Colors.white),
          label: Text(
            'Close',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}