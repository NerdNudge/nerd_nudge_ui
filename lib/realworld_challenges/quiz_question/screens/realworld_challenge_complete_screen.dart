import 'package:flutter/material.dart';
import 'package:nerd_nudge/realworld_challenges/quiz_question/screens/realworld_challenge_actions.dart';
import 'package:nerd_nudge/realworld_challenges/quiz_question/screens/realworld_challenge_body.dart';
import 'package:nerd_nudge/realworld_challenges/quiz_question/screens/realworld_challenge_header.dart';
import 'package:nerd_nudge/realworld_challenges/quiz_question/screens/realworld_challenge_options_body.dart';
import 'package:nerd_nudge/realworld_challenges/quiz_question/screens/realworld_challenge_timer_body.dart';
import 'package:nerd_nudge/topics/screens/explore_topic_selection_home_page.dart';
import 'package:nerd_nudge/utilities/styles.dart';

import '../../../user_home_page/dto/user_home_stats.dart';

class RealWorldChallengeScreen extends StatelessWidget {
  RealWorldChallengeScreen({super.key, required this.completeQuiz});

  final completeQuiz;

  @override
  Widget build(BuildContext context) {
    if (completeQuiz == null) {
      return const Center(
        child: Text(
          'No more questions available.',
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }

    completeQuiz['startTime'] = DateTime.now();
    UserHomeStats().incrementQuizCount();
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: RealworldChallengeHeader(
                    topic: ExploreTopicSelection.selectedTopic,
                    subtopic: completeQuiz['sub_topic'],
                    difficultyLevel: completeQuiz['difficulty_level'],
                  ),
                ),
                Container(
                  child: RealworldChallengeTimer(completeQuiz: completeQuiz,),
                ),
                Styles.getSizedHeightBox(15),
                Container(
                  child: RealworldChallengeContainer(
                    questionText: completeQuiz['question'],
                  ),
                ),
                Styles.getSizedHeightBox(15),
                Container(
                  child: RealworldChallengePossibleAnswersContainer(
                    completeQuiz: completeQuiz,
                  ),
                ),
                Styles.getSizedHeightBox(15),
                Container(
                  child: RealworldChallengeActionButtons(
                    completeQuiz: completeQuiz,
                  ),
                ),
                Styles.getSizedHeightBox(20),
              ],
            ),
          ),
        ),
        //BottomMenu(),
      ],
    );
  }
}
