import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_answers/dto/quizflex_user_activity_api_entity.dart';
import 'package:nerd_nudge/quiz/quiz_answers/screens/read_more.dart';
import 'package:nerd_nudge/quiz/quiz_answers/services/quizflex_submission.dart';
import '../../../utilities/api_end_points.dart';
import '../../../utilities/api_service.dart';
import '../../../utilities/colors.dart';
import '../../home/screens/realworld_challenges_home_page.dart';
import '../../quiz_question/services/start_realworld_challenge.dart';

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
                builder: (context) => RealworldChallengeServiceMainPage(),
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
            _onClose(context);
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

  static Future<void> submitQuizflex() async {
    QuizflexSubmissionService quizflexSubmissionService = QuizflexSubmissionService();
    quizflexSubmissionService.submitQuizflex();
  }


  Future<void> _onClose(BuildContext context) async {
    submitQuizflex();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RealWorldChallengeHomePage(),
      ),
    );
  }
}