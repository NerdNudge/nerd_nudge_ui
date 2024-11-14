import 'package:flutter/material.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/styles.dart';

class TopicDrillDown {
  static getTopicDrillDown(BuildContext context, lifetimeSummary, selectedTopic, Function getCloseButtonClick) {
    print('drill down clicked.');
    final subtopics = lifetimeSummary[selectedTopic]?['subtopics'] as Map<String, dynamic>? ?? {};
    return Column(
      children: [
        Text(
          'Sub-Topic Performance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Styles.getSizedHeightBoxByScreen(context, 20),
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
                    Styles.getSizedHeightBoxByScreen(context, 10),
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
        Styles.getSizedHeightBoxByScreen(context, 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Styles.getTitleDescriptionWidget(
              'Overall Percentage: ',
              '${_calculateOverallPercentage(subtopics).toStringAsFixed(1)}%',
              Colors.black,
              Colors.black,
              15,
              15,
            ),
            Styles.getSizedWidthBoxByScreen(context, 20),
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

  static double _calculateOverallPercentage(Map<String, dynamic> subtopics) {
    if (subtopics.isEmpty) return 0.0;
    double total = 0.0;
    subtopics.values.forEach((value) {
      total += (value as num).toDouble();
    });
    return total / subtopics.length;
  }
}