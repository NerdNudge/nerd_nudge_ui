import 'package:flutter/material.dart';
import 'package:nerd_nudge/insights/screens/trends_insights/user_trend_insights_main_page.dart';
import 'package:nerd_nudge/insights/screens/trends_insights/user_trends_bar_chart_creator.dart';
import 'package:nerd_nudge/utilities/styles.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/logger.dart';
import '../../services/insights_duration_state.dart';
import '../../services/topic_trend_insights_service.dart';

class UserTrendDataChart {
  static getSelectedTopicTrend(
      BuildContext context,
      String selectedTopic,
      String alternativeTrendType,
      Map<String, String> actualTopicNamesToCodesMapping,
      String type,
      Function closeButtonFunction,
      Function updateCurrentTopicScreen // Add the callback function here
      ) {
    String trendType =
    InsightsDurationState.last30DaysFlag ? 'Daily' : 'Daily';
    bool isScore = (type == 'Score');
    NerdLogger.logger.d('isScore: $isScore, type: $type');

    return Stack(
      children: [
        Column(
          children: [
            Center(
              child: Text(
                '$type Trend - $trendType',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Styles.getSizedHeightBox(10),
            Center(
              child: Text(
                'Topic: $selectedTopic',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Styles.getSizedHeightBox(14),
            AspectRatio(
              aspectRatio: 1.6,
              child: UserTrendsBarChartCreator(
                trendsData: _getTrendsData(type, actualTopicNamesToCodesMapping, selectedTopic),
                isScore: isScore,
              ),
            ),
            Styles.getSizedHeightBox(15),
            Styles.getDivider(),
            Styles.getSizedHeightBox(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$alternativeTrendType Trend: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: CustomColors.mainThemeColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: () => {
                      _onAlternateTrendSelection(
                          context,
                          selectedTopic,
                          alternativeTrendType,
                          actualTopicNamesToCodesMapping,
                          _getToggledTrend(type),
                          closeButtonFunction,
                          updateCurrentTopicScreen // Pass the callback here
                      ),
                    },
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: CustomColors.mainThemeColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => closeButtonFunction(),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static _onAlternateTrendSelection(
      BuildContext context,
      String selectedTopic,
      String alternativeTrendType,
      actualTopicNamesToCodesMapping,
      String type,
      Function closeButtonFunction,
      Function updateCurrentTopicScreen // Accept the callback function
      ) {
    final newScreen = getSelectedTopicTrend(
        context, selectedTopic, _getToggledTrend(alternativeTrendType), actualTopicNamesToCodesMapping, alternativeTrendType, closeButtonFunction, updateCurrentTopicScreen);

    updateCurrentTopicScreen(newScreen); // Use the callback to update the screen
  }

  static _getToggledTrend(String text) {
    return text == 'Score' ? 'Rank' : 'Score';
  }

  static _getTrendsData(String trendsType, Map<String, String> actualTopicNamesToCodesMapping, String selectedTopic) {
    return TopicTrendInsightsService().getTopicTrendInsights(
        actualTopicNamesToCodesMapping[selectedTopic]!,
        trendsType,
        UserTrendsMainPage.userTrendsObject);
  }
}