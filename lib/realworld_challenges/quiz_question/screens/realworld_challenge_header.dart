import 'package:flutter/material.dart';
import 'package:nerd_nudge/realworld_challenges/quiz_question/services/start_realworld_challenge.dart';
import 'package:nerd_nudge/utilities/styles.dart';

class RealworldChallengeHeader extends StatelessWidget {
  const RealworldChallengeHeader({super.key, required this.topic, required this.subtopic, required this.difficultyLevel});

  final String topic;
  final String subtopic;
  final String difficultyLevel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Styles.getSizedHeightBoxByScreen(context, 10),
        Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Styles.getTitleDescriptionWidget('Topic: ', topic, Colors.black, Colors.black, 15, 17),
              ),

              Container(
                child: Styles.getTitleDescriptionWidget('Sub-topic: ', subtopic, Colors.black, Colors.black, 15, 17),
              ),
            ],
          ),
        ),
        Styles.getSizedHeightBoxByScreen(context, 15),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Styles.getTitleDescriptionWidget('Question: ', '${RealworldChallengeServiceMainPage.currentIndex}/${RealworldChallengeServiceMainPage.totalDailyQuiz}', Colors.black, Colors.green, 15, 16),
              ),
              Expanded(
                child: Styles.getTitleDescriptionWidget('Score: ', '${RealworldChallengeServiceMainPage.correctAnswers}', Colors.black, Colors.green, 15, 16),
              ),
              Expanded(
                child: Styles.getTitleDescriptionWidget(difficultyLevel, '', Colors.black, Colors.black, 15, 15),
              ),
            ],
          ),
        ),
        Styles.getSizedHeightBoxByScreen(context, 12),
      ],
    );
  }
}
