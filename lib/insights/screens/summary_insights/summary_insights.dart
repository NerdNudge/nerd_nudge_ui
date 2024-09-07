import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:nerd_nudge/insights/screens/summary_insights/summary_details.dart';
import 'package:nerd_nudge/insights/screens/user_insights_main_page.dart';
import 'package:nerd_nudge/utilities/leaderboard_page.dart';

import '../../../../utilities/colors.dart';
import '../../../../utilities/styles.dart';
import '../../../cache_and_lock_manager/cache_locks_keys.dart';
import '../../services/insights_duration_state.dart';
import '../../services/user_insights_service.dart';
import '../Utilities/PeerComparisonInsights.dart';

class SummaryInsights extends StatefulWidget {
  SummaryInsights({Key? key, required this.userInsights}) : super(key: key);

  final Map<String, dynamic> userInsights;

  @override
  State<SummaryInsights> createState() => _SummaryInsightsState();
  static var userSummaryInsightsObject;
  static var peerComparisonDataObject;
  static var summaryObject;
  static var overallSummaryObject;

  static void setValues(Map<String, dynamic> userInsights) {
    print('Under set values: ');
    print(userInsights);
    overallSummaryObject = userInsights['overallSummary'];
    print(overallSummaryObject);
    userSummaryInsightsObject = InsightsDurationState.last30DaysFlag
        ? overallSummaryObject['last30Days']
        : overallSummaryObject['lifetime'];
    print(userSummaryInsightsObject);
    summaryObject = userSummaryInsightsObject['summary'];
    print(summaryObject);
    peerComparisonDataObject = overallSummaryObject['peerComparison'];
  }
}

class _SummaryInsightsState extends State<SummaryInsights> {
  Map<String, dynamic>? userInsights;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _updateSummary();
  }

  void _updateSummary() {
    SummaryInsights.setValues(widget.userInsights);
    setState(() {
      cardDetails = _getSummaryInsights();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      color: Colors.white,
      child: ListTile(
        onTap: () {},
        title: cardDetails,
      ),
    );
  }

  late Widget cardDetails;

  Widget _getSummaryInsights() {
    var summaryObject = SummaryInsights.userSummaryInsightsObject['summary'];
    int easyValue = summaryObject['stats']['easy'];
    int mediumValue = summaryObject['stats']['medium'];
    int hardValue = summaryObject['stats']['hard'];
    int topicRank = (widget.userInsights.containsKey('rankings') && widget.userInsights['rankings'].containsKey('global'))
        ? widget.userInsights['rankings']['global'] as int
        : 0;
    print('Topic rank: $topicRank');

    return Column(
      children: [
        Text(
          'Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          'Global Rank: $topicRank',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Row(
          children: [
            _getSummaryChart(easyValue.toDouble(), mediumValue.toDouble(), hardValue.toDouble()),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Styles.getTitleDescriptionWidget('Easy: ',
                      easyValue.toString(), Colors.green, Colors.green, 14, 14),
                  Styles.getTitleDescriptionWidget(
                      'Medium: ',
                      mediumValue.toString(),
                      Colors.orange,
                      Colors.orange,
                      14,
                      14),
                  Styles.getTitleDescriptionWidget('Hard: ',
                      hardValue.toString(), Colors.red, Colors.red, 14, 14),
                ],
              ),
            ),
          ],
        ),
        Styles.getTitleDescriptionWidget(
          'Total Questions: ',
          (easyValue + mediumValue + hardValue).toString(),
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
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: CustomColors.mainThemeColor,
                borderRadius: BorderRadius.circular(
                    8.0),
              ),
              child: IconButton(
                icon: Icon(Icons.light_mode),
                onPressed: () => getSummaryDetails(),
                color: Colors.white,
              ),
            ),
            SizedBox(width: 6),
            Container(
              width: 40.0, // Adjust the width and height for the desired size
              height: 40.0,
              decoration: BoxDecoration(
                color: CustomColors.mainThemeColor,
                borderRadius: BorderRadius.circular(
                    8.0),
              ),
              child: IconButton(
                icon: Icon(Icons.group),
                onPressed: () => _getPeerComparison(),
                color: Colors.white,
              ),
            ),
            SizedBox(width: 6),
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: CustomColors.mainThemeColor,
                borderRadius: BorderRadius.circular(
                    8.0),
              ),
              child: IconButton(
                icon: Icon(Icons.leaderboard),
                onPressed: () => getLeaderBoardPage(),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void getLeaderBoardPage() async {
    print('Summary Insights: Leaderboard details clicked.');
    try {
      List<dynamic> leaderboardList = await _fetchLeaderBoard('global', 100);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => LeaderboardPage(leaderBoardList: leaderboardList, buttonClick: getLeaderPageCloseButtonClick, topic: 'Global',),
      ),);
    } catch (e) {
      print('Error fetching leaderboard data: $e');
      setState(() {
        cardDetails = Center(child: Text('Failed to load leaderboard data.'));
      });
    }
  }

  Future<List<dynamic>> _fetchLeaderBoard(String topic, int limit) async {
    try {
      return await UserInsightsService().getLeaderBoard(topic, limit);
    } catch (e) {
      print('Error fetching user insights: $e');
      return [];
    }
  }

  void getSummaryDetails() {
    print('User summary details clicked.');
    setState(() {
      cardDetails = SummaryDetails.getQuestionSummaryDrillDown(SummaryInsights.summaryObject['accuracy'], getCloseButtonClick);
    });
  }

  void _getPeerComparison() {
    print('Peer comparison called.');
    setState(() {
      SummaryInsights.peerComparisonDataObject = SummaryInsights.overallSummaryObject['peerComparison'];
      cardDetails = PeerComparisonInsights(
        closeButton: getCloseButtonClick,
        peerComparisonData: SummaryInsights.peerComparisonDataObject,
        topic: 'Overall',
      );
    });
  }

  void getLeaderPageCloseButtonClick() {
    print('Close button clicked. under leader page');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInsights(),
      ),
    );
  }

  void getCloseButtonClick() {
    print('Close button clicked.');
    setState(() {
      cardDetails = _getSummaryInsights();
    });
  }

  Widget _getSummaryChart(double easyValue, double mediumValue, double hardValue) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Chart(
        layers: _layers(easyValue, mediumValue, hardValue),
      ),
    );
  }

  List<ChartLayer> _layers(double easyValue, double mediumValue, double hardValue) {
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
            ),
          ],
        ],
        settings: const ChartGroupPieSettings(
          gapBetweenChartCircles: 6,
          gapSweepAngle: 7,
          thickness: 10,
        ),
      ),
      ChartTooltipLayer(
        shape: () => ChartTooltipPieShape<ChartGroupPieDataItem>(
          onTextName: (item) => item.label,
          onTextValue: (item) => '${item.amount}',
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
      ),
    ];
  }
}