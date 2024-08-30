import 'package:flutter/material.dart';
import 'package:nerd_nudge/insights/screens/trends_insights/user_trends_bar_chart_creator.dart';
import 'package:nerd_nudge/utilities/styles.dart';

import '../../../utilities/colors.dart';
import '../../services/insights_duration_state.dart';

class UserTrendDataChart {
  static getSelectedTopicTrend(
      BuildContext context, String selectedTopic, var trendsData, String type, Function closeButtonFunction) {
    String trendType =
        InsightsDurationState.last30DaysFlag ? 'Daily' : 'Daily';
    bool isScore = (type == 'Score');
    return Column(
      children: [
        Text(
          '$type Trend Insights - $trendType',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Styles.getSizedHeightBox(10),
        Text(
          'Topic: $selectedTopic',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Styles.getSizedHeightBox(14),
        AspectRatio(
          aspectRatio: 1.6,
          child: UserTrendsBarChartCreator(
            trendsData: trendsData,
            isScore: isScore,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: CustomColors.mainThemeColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => closeButtonFunction(),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
