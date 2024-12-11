import 'package:flutter/material.dart';
import 'package:nerd_nudge/user/rankings.dart';
import 'package:nerd_nudge/user/scores.dart';
import 'package:nerd_nudge/utilities/styles.dart';

class QuestionHeader extends StatelessWidget {
  const QuestionHeader({
    Key? key,
    required this.topic,
    required this.subtopic,
    required this.difficultyLevel,
  }) : super(key: key);

  final String topic;
  final String subtopic;
  final String difficultyLevel;

  @override
  Widget build(BuildContext context) {
    double score = UserScores.getUserScore();
    int rank = UserRankings.getUserRank();

    return Column(
      children: <Widget>[
        Styles.getSizedHeightBoxByScreen(context, 15),
        Column(
          children: <Widget>[
            Styles.getTitleDescriptionWidget(
              'Topic: ',
              topic,
              Colors.black,
              Colors.black,
              15,
              17,
            ),
            Styles.getTitleDescriptionWidget(
              'Sub-topic: ',
              subtopic,
              Colors.black,
              Colors.black,
              15,
              17,
            ),
          ],
        ),
        Styles.getSizedHeightBoxByScreen(context, 15), // 1.5% of screen height
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Styles.getSizedWidthBoxByScreen(context, 10),
            Expanded(
              flex: 2,
              child: Styles.getTitleDescriptionWidget(
                'Score: ',
                score.toString(),
                Colors.black,
                Colors.green,
                15,
                16,
              ),
            ),
            /*Expanded(
              flex: 2,
              child: Styles.getTitleDescriptionWidget(
                'Rank: ',
                rank.toString(),
                Colors.black,
                Colors.green,
                15,
                16,
              ),
            ),*/
            Expanded(
              flex: 1,
              child: Styles.getTitleDescriptionWidget(
                'Difficulty: ',
                difficultyLevel,
                Colors.black,
                Colors.black,
                15,
                15,
              ),
            ),
            //Styles.getSizedWidthBoxByScreen(context, 10),
          ],
        ),
        Styles.getSizedHeightBoxByScreen(context, 12), // 1.2% of screen height
      ],
    );
  }
}
