import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_question/services/start_quiz.dart';
import '../../../topics/screens/topic_selection_home_page.dart';

class RealWorldChallengeHomePage extends StatefulWidget {
  const RealWorldChallengeHomePage({super.key});

  @override
  State<RealWorldChallengeHomePage> createState() => _RealWorldChallengeHomePageState();
}

class _RealWorldChallengeHomePageState extends State<RealWorldChallengeHomePage> {
  @override
  Widget build(BuildContext context) {
    return TopicSelectionHomePage(title: 'Nerd Quiz', showShotsOrQuiz: startQuiz, page: 'Quizflex',);
  }

  startQuiz() {
    print('pushing for quiz service');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizService(),
      ),
    );
  }
}