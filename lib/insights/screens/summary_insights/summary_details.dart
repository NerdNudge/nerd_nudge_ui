import 'package:flutter/material.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/styles.dart';

class SummaryDetails {
  static Widget getQuestionSummaryDrillDown(dynamic accuracy, Function buttonClick) {

    double easyPercentage = accuracy['easy'];
    double mediumPercentage = accuracy['medium'];
    double hardPercentage = accuracy['hard'];
    double overallPercentage = accuracy['overall'];

    return Column(
      children: [
        const Text(
          'Summary Drill Down',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Styles.getTitleDescriptionWidget(
                  'Easy: ', '$easyPercentage %', Colors.green, Colors.green, 14, 14),
              Styles.getSlider(easyPercentage.toDouble(), Colors.green),
              Styles.getTitleDescriptionWidget(
                  'Medium: ', '$mediumPercentage %', Colors.orange, Colors.orange, 14, 14),
              Styles.getSlider(mediumPercentage.toDouble(), Colors.orange),
              Styles.getTitleDescriptionWidget(
                  'Hard: ', '$hardPercentage %', Colors.red, Colors.red, 14, 14),
              Styles.getSlider(hardPercentage.toDouble(), Colors.red),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Styles.getTitleDescriptionWidget(
              'Overall Percentage: ',
              '$overallPercentage %',
              Colors.black,
              Colors.black,
              15,
              15,
            ),
            const SizedBox(width: 40),
            Container(
              width: 40.0, // Adjust the width and height for the desired size
              height: 40.0,
              decoration: BoxDecoration(
                color: CustomColors.mainThemeColor, // Background color of the button
                borderRadius: BorderRadius.circular(
                    8.0), // Adjust the border radius for a square shape
              ),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => buttonClick(), // Ensure the buttonClick function accepts BuildContext as a parameter
                color: Colors.white, // Foreground color of the X icon
              ),
            ),
          ],
        ),
      ],
    );
  }
}