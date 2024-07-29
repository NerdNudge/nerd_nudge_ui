import 'package:flutter/material.dart';
import 'package:nerd_nudge/insights/screens/trends_insights/user_topic_trend_insights_chart.dart';
import '../../../utilities/colors.dart';
import '../../services/insights_duration_state.dart';
import '../../services/summary_insights_service.dart';
import '../../services/topic_trend_insights_service.dart';

class UserTrendsMainPage extends StatefulWidget {
  const UserTrendsMainPage({super.key});

  static final userSummaryInsights =
      SummaryInsightsService().getUserSummaryInsights();
  static var userSummaryInsightsObject;
  static var userTopics;

  @override
  State<UserTrendsMainPage> createState() => _UserTrendsMainPageState();

  static void setValues() {
    userSummaryInsightsObject = InsightsDurationState.last30DaysFlag
        ? userSummaryInsights['last30days']
        : userSummaryInsights['lifetime'];
    userTopics = userSummaryInsightsObject['userTopics'];
  }
}

class _UserTrendsMainPageState extends State<UserTrendsMainPage> {
  late String selectedTopic;
  late Widget _currentTopicScreen;
  late List<String> userTopics;
  late String _trendType;
  late String _alternativeTrendType;

  @override
  void initState() {
    super.initState();

    UserTrendsMainPage.setValues();
    _trendType = 'Score';
    _alternativeTrendType = 'Rank';
    updateTopics();
    _currentTopicScreen = _getUserTopicsForTrends();
  }

  void updateTopics() {
    userTopics = [];
    userTopics.add('Overall');
    UserTrendsMainPage.userTopics.forEach((topicName) {
      userTopics.add(topicName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      color: Colors.white,
      child: ListTile(
        title: _currentTopicScreen,
      ),
    );
  }

  _getUserTopicsForTrends() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            '$_trendType Trend Insights',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Select a Topic: ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 13),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: userTopics.map((String option) {
            return FilterChip(
              label: Text(option),
              onSelected: (bool selected) {
                print(option);
                setState(() {
                  selectedTopic = option;
                  _currentTopicScreen = UserTrendDataChart.getSelectedTopicTrend(
                      context,
                      selectedTopic,
                      TopicTrendInsightsService().getTopicTrend(selectedTopic, _trendType), _trendType, closeButtonFunctionality);
                });
              },
              selectedColor: Colors.white,
              checkmarkColor: Colors.green,
              backgroundColor: Colors.grey.shade500,
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '$_alternativeTrendType Trend: ',
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
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: Icon(Icons.star_border_rounded),
                onPressed: () => _toggleScoreAndRankingsTrendLabels(),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _toggleScoreAndRankingsTrendLabels() {
    setState(() {
      _alternativeTrendType = (_alternativeTrendType == 'Score') ? 'Rank' : 'Score';
      _trendType = (_trendType == 'Score') ? 'Rank' : 'Score';
      _currentTopicScreen = _getUserTopicsForTrends();
    });
  }

  closeButtonFunctionality() {
    setState(() {
      _currentTopicScreen = _getUserTopicsForTrends();
    });
  }
}
