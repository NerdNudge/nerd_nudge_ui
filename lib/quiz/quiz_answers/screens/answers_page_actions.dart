import 'package:flutter/material.dart';
import 'package:nerd_nudge/explore_menu/screens/explore_home_page.dart';
import 'package:nerd_nudge/quiz/quiz_answers/screens/read_more.dart';
import 'package:nerd_nudge/quiz/quiz_answers/services/quizflex_submission.dart';
import '../../../utilities/colors.dart';
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
          icon: const Icon(Icons.info_outline, color: Colors.white),
          label: const Text(
            'Info',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.mainThemeColor,
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
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
                builder: (context) => const QuizService(),
              ),
            );
          },
          icon: const Icon(Icons.navigate_next, color: Colors.white),
          label: const Text(
            'Next',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.mainThemeColor,
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            _onClose(context);
          },
          icon: const Icon(Icons.close, color: Colors.white),
          label: const Text(
            'Close',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
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
        builder: (context) => const ExplorePage(),
      ),
    );
  }
}