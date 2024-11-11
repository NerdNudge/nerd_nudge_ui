import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_answers/screens/answers_page_actions.dart';
import 'package:nerd_nudge/quiz/quiz_answers/screens/read_more.dart';
import 'package:nerd_nudge/quiz/quiz_question/services/nerd_quizflex_service.dart';
import 'package:nerd_nudge/topics/screens/explore_topic_selection_home_page.dart';
import 'package:nerd_nudge/topics/screens/topic_selection_home_page.dart';
import 'package:nerd_nudge/ads_manager/ads_manager.dart';

import '../../../../utilities/constants.dart';
import '../../../../utilities/styles.dart';
import '../../../cache_and_lock_manager/cache_locks_keys.dart';
import '../../../menus/screens/menu_options.dart';
import '../../../topics/screens/subtopic_selection.dart';
import '../../../user_home_page/dto/user_home_stats.dart';
import '../screens/question_complete_screen.dart';

class QuizService extends StatefulWidget {
  const QuizService({super.key});

  static void resetCurrentQuizzes() {
    _QuizServiceState._currentQuizzes = [];
  }

  @override
  State<QuizService> createState() => _QuizServiceState();
}

class _QuizServiceState extends State<QuizService> {

  @override
  void initState() {
    super.initState();
    CacheLockKeys cacheLockKeys = CacheLockKeys();
    cacheLockKeys.updateQuizFlexShotsKey();
  }


  static List<dynamic> _currentQuizzes = [];
  static int _currentIndex = 0;
  static bool _quizSubmitted = false;

  @override
  Widget build(BuildContext context) {
    int l = _currentQuizzes.length;
    print('length of current quizzes: $l');
    var nextQuiz = _getNextQuiz();
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
        body: nextQuiz is Widget
            ? nextQuiz
            : QuestionScreen(completeQuiz: nextQuiz),
      ),
    );
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

  dynamic _getNextQuiz() {
    if (UserHomeStats().hasUserExhaustedNerdQuiz()) {
      if (! _quizSubmitted && ! ReadMorePage.isQuizflexEmpty()) {
        AnswersPageActionButtons.submitQuizflex();
        ReadMorePage.resetUserActivityEntity();
        _quizSubmitted = true;
      }

      print('User has exhausted the quiz counts.');
      if (UserHomeStats().getUserAccountType() == Constants.FREEMIUM) {
        print('Freemium user.');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubtopicSelectionPage(title: ExploreTopicSelection.selectedTopic, showShotsOrQuiz: startQuiz, isPaywallOpen: true, page: 'Quizflex'),
            ),
          );
        });
      }
      return null;
    } else {
      _quizSubmitted = false;
      print('Last shown Quiz count: ${NerdAdManager.lastShownQuizCount}, Quiz count today: ${UserHomeStats().getUserQuizCountToday()}');
      if (UserHomeStats().getUserAccountType() == Constants.FREEMIUM && NerdAdManager.lastShownQuizCount != UserHomeStats().getUserQuizCountToday() &&
          UserHomeStats().adsFrequencyQuizFlex != 0 &&
          (UserHomeStats().getUserQuizCountToday() % UserHomeStats().adsFrequencyQuizFlex == 0)) {
        NerdAdManager.lastShownQuizCount = UserHomeStats().getUserQuizCountToday();
        return NerdAdManager(
          onAdClosed: () {
            setState(() {
              var nextQuiz = _getNextQuiz();
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
      } else {
        return _getNextQuizflex();
      }
    }
  }

  dynamic _getNextQuizflex() {
    if (_currentQuizzes.isEmpty || _currentIndex >= _currentQuizzes.length) {
      _updateCurrentQuiz();
      return null;
    }

    var quizFlex = _currentQuizzes[_currentIndex];
    _currentIndex++;
    return quizFlex;
  }

  _updateCurrentQuiz() async {
    var nextQuizList = await _getNextQuizzes();
    if (nextQuizList.isEmpty) {
      if (! _quizSubmitted && ! ReadMorePage.isQuizflexEmpty()) {
        AnswersPageActionButtons.submitQuizflex();
        ReadMorePage.resetUserActivityEntity();
        _quizSubmitted = true;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubtopicSelectionPage(title: ExploreTopicSelection.selectedTopic, showShotsOrQuiz: startQuiz, isPaywallOpen: true, page: 'Quizflex'),
          ),
        );
      });
    } else {
      setState(() {
        print('adding new list of quizflexes');
        _currentQuizzes.addAll(nextQuizList);
        int len = _currentQuizzes.length;
        print('current quizzes length: $len');

        if (_currentIndex >= _currentQuizzes.length) {
          _currentIndex = _currentQuizzes.length - 1;
        }
      });
    }
  }

  Future<List<dynamic>> _getNextQuizzes() async {
    if (UserHomeStats().hasUserExhaustedNerdQuiz()) {
      print('User has exhausted the quiz counts.');
      return [];
    } else {
      print('Fetching the next quizzes set.');
      var nextQuestions = await NerdQuizflexService().getNextQuizflexes(
          ExploreTopicSelection.selectedTopic, ExploreTopicSelection.selectedSubtopic, 10);
      print('Fetched Quizzes: $nextQuestions');
      return nextQuestions['data'] ?? [];
    }
  }
}
