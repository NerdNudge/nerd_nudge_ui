import 'package:flutter/material.dart';
import 'package:nerd_nudge/topics/screens/topic_selection_home_page.dart';
import 'package:nerd_nudge/ads_manager/ads_manager.dart';

import '../../../../utilities/constants.dart';
import '../../../../utilities/quiz_topics.dart';
import '../../../../utilities/styles.dart';
import '../../../menus/screens/menu_options.dart';
import '../../../subscriptions/upgrade_page.dart';
import '../../../user_profile/screens/user_account_types.dart';
import '../screens/question_complete_screen.dart';
import '../../../home_page/dto/user_home_stats.dart';

class QuizService extends StatefulWidget {
  const QuizService({super.key});

  @override
  State<QuizService> createState() => _QuizServiceState();
}

class _QuizServiceState extends State<QuizService> {
  @override
  Widget build(BuildContext context) {
    var nextQuiz = getNextQuiz();
    if (nextQuiz == null) {
      return Scaffold(
        appBar: Styles.getAppBar(Constants.title),
        drawer: MenuOptions.getMenuDrawer(context),
        body: Center(
          child: Text(
            'You have exhausted your daily quiz quota. Please upgrade to continue.',
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar(Constants.title),
        drawer: MenuOptions.getMenuDrawer(context),
        body: nextQuiz is Widget ? nextQuiz : QuestionScreen(completeQuiz: nextQuiz),
      ),
    );
  }

  getNextQuiz() {
    if (UserHomeStats().hasUserExhaustedNerdQuiz()) {
      print('User has exhausted the quiz counts.');
      if (UserHomeStats().getUserAccountType() == AccountType.FREEMIUM) {
        print('Freemium user.');
        // Delay the navigation until after the build phase
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpgradePage(),
            ),
          );
        });
      }
      return null;
    } else {
      int count = UserHomeStats().getUserQuizCountToday();
      print('count: $count');
      if (NerdAdManager.lastShownQuizCount != UserHomeStats().getUserQuizCountToday() && (UserHomeStats().getUserQuizCountToday() == 1 || UserHomeStats().getUserQuizCountToday() == 4)) {
        print('quiz count mod success');
        NerdAdManager.lastShownQuizCount = UserHomeStats().getUserQuizCountToday();
        return NerdAdManager(
          onAdClosed: () {
            setState(() {
              var nextQuiz = getNextQuiz();
              if (nextQuiz != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizService(),
                  ),
                );
              }
            });
          },
        );
      }
      else {
        String selectedTopic = TopicSelection.selectedTopic;
        print('QuizService: $selectedTopic');
        UserHomeStats().incrementQuizCount();
        var quizType = Topics.getQuizType(selectedTopic);
        var nextQuestion = quizType.getNextQuestion();
        nextQuestion['category'] = selectedTopic;
        return nextQuestion;
      }
    }
  }
}