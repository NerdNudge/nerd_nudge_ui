import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_answers/screens/answers_page_actions.dart';
import 'package:nerd_nudge/quiz/quiz_answers/screens/read_more.dart';
import 'package:nerd_nudge/quiz/quiz_question/services/nerd_quizflex_service.dart';
import 'package:nerd_nudge/realworld_challenges/quiz_question/screens/realworld_challenge_completion_screen.dart';
import 'package:nerd_nudge/topics/screens/explore_topic_selection_home_page.dart';
import 'package:nerd_nudge/utilities/constants.dart';

import '../../../../utilities/styles.dart';
import '../../../cache_and_lock_manager/cache_locks_keys.dart';
import '../../../menus/screens/menu_options.dart';
import '../../../topics/screens/subtopic_selection.dart';
import '../../../user_home_page/dto/user_home_stats.dart';
import '../screens/realworld_challenge_complete_screen.dart';

class RealworldChallengeServiceMainPage extends StatefulWidget {
  const RealworldChallengeServiceMainPage({super.key});

  static int correctAnswers = 0;
  static int totalDailyQuiz = 3;
  static int currentIndex = 0;

  static void resetCurrentQuizzes() {
    _RealworldChallengeServiceMainPageState._currentQuizzes = [];
    correctAnswers = 0;
    currentIndex = 0;
  }

  @override
  State<RealworldChallengeServiceMainPage> createState() =>
      _RealworldChallengeServiceMainPageState();
}

class _RealworldChallengeServiceMainPageState
    extends State<RealworldChallengeServiceMainPage> {
  @override
  void initState() {
    super.initState();
    CacheLockKeys cacheLockKeys = CacheLockKeys();
    cacheLockKeys.updateQuizFlexShotsKey();
  }

  static List<dynamic> _currentQuizzes = [];
  static bool _quizSubmitted = false;

  @override
  Widget build(BuildContext context) {
    int l = _currentQuizzes.length;
    print('length of current quizzes under RWC: $l');
    var nextQuiz = _getNextQuiz();
    if(nextQuiz == Constants.COMPLETED) {
      print('Completed the existing daily RWC quizzes.');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RealworldChallengeCompletionScreen(),
        ),
      );
    }
    else if (nextQuiz == null) {
      return Scaffold(
        appBar: Styles.getAppBar('Real-World Challenge'),
        drawer: MenuOptions.getMenuDrawer(context),
        body: Center(
          child: Text(
            'Please upgrade to continue.',
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('Real-World Challenge'),
        drawer: MenuOptions.getMenuDrawer(context),
        body: nextQuiz is Widget
            ? nextQuiz
            : RealWorldChallengeScreen(completeQuiz: nextQuiz,),
      ),
    );
  }

  startQuiz() {
    print('pushing for quiz service');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RealworldChallengeServiceMainPage(),
      ),
    );
  }

  dynamic _getNextQuiz() {
    _quizSubmitted = false;
    return _getNextQuizflex();
  }

  dynamic _getNextQuizflex() {
    if (_currentQuizzes.isEmpty) {
      _updateCurrentQuiz();
      return null;
    }
    else if(RealworldChallengeServiceMainPage.currentIndex >= _currentQuizzes.length) {
      return Constants.COMPLETED;
    }

    var quizFlex = _currentQuizzes[RealworldChallengeServiceMainPage.currentIndex];
    RealworldChallengeServiceMainPage.currentIndex ++;
    return quizFlex;
  }

  _updateCurrentQuiz() async {
    var nextQuizList = await _getNextQuizzes();
    if (nextQuizList.isEmpty) {
      if (!_quizSubmitted && !ReadMorePage.isQuizflexEmpty()) {
        AnswersPageActionButtons.submitQuizflex();
        ReadMorePage.resetUserActivityEntity();
        _quizSubmitted = true;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubtopicSelectionPage(
                title: ExploreTopicSelection.selectedTopic,
                showShotsOrQuiz: startQuiz,
                isPaywallOpen: true,
                page: 'Quizflex'),
          ),
        );
      });
    } else {
      setState(() {
        print('adding new list of RWC');
        _currentQuizzes.addAll(nextQuizList);
        int len = _currentQuizzes.length;
        print('current rwc quizzes length: $len');

        if (RealworldChallengeServiceMainPage.currentIndex >= _currentQuizzes.length) {
          RealworldChallengeServiceMainPage.currentIndex = _currentQuizzes.length - 1;
        }
      });
    }
  }

  Future<List<dynamic>> _getNextQuizzes() async {
    if (UserHomeStats().hasUserExhaustedNerdQuiz()) {
      print('User has exhausted the quiz counts.');
      return [];
    } else {
      print('Fetching the next rwc set.');
      var nextChallenges = await NerdQuizflexService()
          .getRealWorldChallenges(ExploreTopicSelection.selectedTopic, 'Random', RealworldChallengeServiceMainPage.totalDailyQuiz);
      print('Fetched RWC: $nextChallenges');
      return nextChallenges['data'] ?? [];
    }
  }
}
