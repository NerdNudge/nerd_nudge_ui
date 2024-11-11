import 'package:flutter/material.dart';
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
        SizedBox(
          height: 10.0,
        ),
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
        SizedBox(
          height: 15.0,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Styles.getTitleDescriptionWidget('Question: ', '3/10', Colors.black, Colors.green, 15, 16),
              ),
              Expanded(
                child: Styles.getTitleDescriptionWidget('Score: ', '2/2', Colors.black, Colors.green, 15, 16),
              ),
              Expanded(
                child: Styles.getTitleDescriptionWidget('Difficulty: ', difficultyLevel, Colors.black, Colors.black, 15, 15),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
      ],
    );
  }
}
