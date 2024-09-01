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
        Styles.getSizedHeightBox(20),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Corrected iteration over map entries
              for (var entry in lifetimeSummary[selectedTopic]['subtopics'].entries)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Styles.getSizedHeightBox(10),
                    Styles.getTitleDescriptionWidget(
                      '${entry.key} ',  // Subtopic name
                      '(${entry.value}%)',  // Percentage correct
                      Styles.getSliderColorForPercentageCorrect(
                        entry.value.toDouble(),
                      ),
                      Styles.getSliderColorForPercentageCorrect(
                        entry.value.toDouble(),
                      ),
                      14,
                      14,
                    ),
                    Styles.getSlider(
                      entry.value.toDouble(),
                      Styles.getSliderColorForPercentageCorrect(
                        entry.value.toDouble(),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Styles.getSizedHeightBox(20),
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
            Styles.getSizedWidthBox(40),
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