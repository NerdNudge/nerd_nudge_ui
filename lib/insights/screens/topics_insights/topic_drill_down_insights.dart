import 'package:flutter/material.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/styles.dart';

class TopicDrillDown {
  static getTopicDrillDown(lifetimeSummary, selectedTopic, Function getCloseButtonClick) {
    print('drill down clicked.');
    return Column(
      children: [
        Text(
          'Sub-Topic Performance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var topic in lifetimeSummary[selectedTopic]['topics'])
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Styles.getTitleDescriptionWidget(
                      '${topic['id']} ',
                      '(${topic['percentage_correct']}%)',
                      Styles.getSliderColorForPercentageCorrect(
                        topic['percentage_correct'].toDouble(),
                      ),
                      Styles.getSliderColorForPercentageCorrect(
                        topic['percentage_correct'].toDouble(),
                      ),
                      14,
                      14,
                    ),
                    Styles.getSlider(
                      topic['percentage_correct'].toDouble(),
                      Styles.getSliderColorForPercentageCorrect(
                        topic['percentage_correct'].toDouble(),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Styles.getTitleDescriptionWidget(
              'Overall Percentage: ',
              '59%',
              Colors.black,
              Colors.black,
              15,
              15,
            ),
            SizedBox(width: 40),
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: CustomColors.mainThemeColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => getCloseButtonClick(),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}