import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_question/services/start_quiz.dart';
import '../../../topics/screens/topic_selection_home_page.dart';

class QuizTopicSelection {
  static String selectedTopic = '';
}

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();

  static getSelectedOptions() {
    return '_selectedOptions';
  }
}

class _QuizHomePageState extends State<QuizHomePage> {
  @override
  Widget build(BuildContext context) {
    return TopicSelectionHomePage(title: 'Nerd Quiz', showShotsOrQuiz: startQuiz, page: 'Quizflex',);
  }

  startQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizService(),
      ),
    );
  }
}