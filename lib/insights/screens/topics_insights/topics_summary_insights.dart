import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/styles.dart';
import '../../services/user_insights_service.dart';
import 'package:nerd_nudge/utilities/leaderboard_page.dart';

import '../user_insights_main_page.dart';

class TopicSummaryInsights {

  static late BuildContext context;

  static getSelectedTopicSummary(BuildContext context, dynamic topicObject, String selectedTopic,
      Function getDetails, Function getPeerComparison, Function getCloseButtonClick, int topicRank) {
    print('Under topic summary details: $topicObject');
    TopicSummaryInsights.context = context;
    return Column(
      children: [
        Text(
          'Topics Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        _getCompleteDashboardSection(
          selectedTopic,
          'Topic Rank: $topicRank',
          (topicObject['easy'] as num).toDouble(),      // Convert to double
          (topicObject['medium'] as num).toDouble(),    // Convert to double
          (topicObject['hard'] as num).toDouble(),      // Convert to double
          topicObject['easy'] + topicObject['medium'] + topicObject['hard'],
          context,
          getDetails,
          getPeerComparison,
          getCloseButtonClick,
        ),
      ],
    );
  }

  static _getCompleteDashboardSection(
      String title,
      String rankDesc,
      double easyValue,
      double mediumValue,
      double hardValue,
      int totalQuestions,
      BuildContext context,
      Function topicsDrillDown,
      Function getPeerComparison,
      Function getCloseButtonClick) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          rankDesc,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Row(
          children: [
            _getSummaryChart(easyValue, mediumValue, hardValue),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Styles.getTitleDescriptionWidget(
                    'Easy: ',
                    easyValue.toString(),
                    Colors.green,
                    Colors.green,
                    14,
                    14,
                  ),
                  Styles.getTitleDescriptionWidget(
                      'Medium: ',
                      mediumValue.toString(),
                      Colors.orange,
                      Colors.orange,
                      14,
                      14),
                  Styles.getTitleDescriptionWidget(
                    'Hard: ',
                    hardValue.toString(),
                    Colors.red,
                    Colors.red,
                    14,
                    14,
                  ),
                ],
              ),
            ),
          ],
        ),
        Styles.getTitleDescriptionWidget(
          'Total Questions: ',
          totalQuestions.toString(),
          Colors.black,
          Colors.black,
          15,
          15,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Click For Details: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Container(
              width: 40.0, // Adjust the width and height for the desired size
              height: 40.0,
              decoration: BoxDecoration(
                color: CustomColors
                    .mainThemeColor, // Background color of the button
                borderRadius: BorderRadius.circular(
                    8.0), // Adjust the border radius for a square shape
              ),
              child: IconButton(
                icon: Icon(Icons.light_mode),
                onPressed: () =>
                    topicsDrillDown(), // Ensure the buttonClick function accepts BuildContext as a parameter
                color: Colors.white, // Foreground color of the X icon
              ),
            ),
            SizedBox(width: 6),
            Container(
              width: 40.0, // Adjust the width and height for the desired size
              height: 40.0,
              decoration: BoxDecoration(
                color: CustomColors
                    .mainThemeColor, // Background color of the button
                borderRadius: BorderRadius.circular(
                    8.0), // Adjust the border radius for a square shape
              ),
              child: IconButton(
                icon: Icon(Icons.group),
                onPressed: () =>
                    getPeerComparison(), // Ensure the buttonClick function accepts BuildContext as a parameter
                color: Colors.white, // Foreground color of the X icon
              ),
            ),
            SizedBox(width: 6),
            Container(
              width: 40.0, // Adjust the width and height for the desired size
              height: 40.0,
              decoration: BoxDecoration(
                color: CustomColors
                    .mainThemeColor, // Background color of the button
                borderRadius: BorderRadius.circular(
                    8.0), // Adjust the border radius for a square shape
              ),
              child: IconButton(
                icon: Icon(Icons.leaderboard),
                onPressed: () =>
                    getLeaderBoardPage(title),
                color: Colors.white, // Foreground color of the X icon
              ),
            ),
            SizedBox(width: 6),
            Container(
              width: 40.0, // Adjust the width and height for the desired size
              height: 40.0,
              decoration: BoxDecoration(
                color: CustomColors
                    .mainThemeColor, // Background color of the button
                borderRadius: BorderRadius.circular(
                    8.0), // Adjust the border radius for a square shape
              ),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () =>
                    getCloseButtonClick(), // Ensure the buttonClick function accepts BuildContext as a parameter
                color: Colors.white, // Foreground color of the X icon
              ),
            ),
          ],
        ),
      ],
    );
  }

  static void getLeaderBoardPage(String topic) async {
    print('Topic Insights: Leaderboard details clicked.');
    try {
      List<dynamic> leaderboardList = await _fetchLeaderBoard(topic, 100);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => LeaderboardPage(leaderBoardList: leaderboardList, buttonClick: getLeaderPageCloseButtonClick, topic: topic,),
      ),);
    } catch (e) {
      print('Error fetching leaderboard data: $e');
    }
  }

  static void getLeaderPageCloseButtonClick() {
    print('Close button clicked. under leader page');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInsights(),
      ),
    );
  }

  static Future<List<dynamic>> _fetchLeaderBoard(String topic, int limit) async {
    try {
      return await UserInsightsService().getLeaderBoard(topic, limit);
    } catch (e) {
      print('Error fetching user insights: $e');
      return [];
    }
  }

  static _getSummaryChart(
      double easyValue, double mediumValue, double hardValue) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Chart(
        layers: _layers(easyValue, mediumValue, hardValue),
      ),
    );
  }

  static List<ChartLayer> _layers(
      double easyValue, double mediumValue, double hardValue) {
    return [
      ChartGroupPieLayer(
        items: [
          [
            ChartGroupPieDataItem(
              amount: easyValue,
              color: Colors.green,
              label: 'Easy',
            ),
            ChartGroupPieDataItem(
              amount: mediumValue,
              color: Colors.orange,
              label: 'Medium',
            ),
            ChartGroupPieDataItem(
              amount: hardValue,
              color: Colors.red,
              label: 'Hard',
            )
          ]
        ],
        settings: const ChartGroupPieSettings(
            gapBetweenChartCircles: 6, gapSweepAngle: 7, thickness: 10),
      ),
      ChartTooltipLayer(
        shape: () => ChartTooltipPieShape<ChartGroupPieDataItem>(
          onTextName: (item) => item.label,
          onTextValue: (item) => '${item.amount.toString()}',
          radius: 10.0,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(12.0),
          nameTextStyle: const TextStyle(
            color: Color(0xFF8043F9),
            fontWeight: FontWeight.w700,
            height: 1.47,
            fontSize: 12.0,
          ),
          valueTextStyle: const TextStyle(
            color: Color(0xFF1B0E41),
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
          ),
        ),
      )
    ];
  }
}
