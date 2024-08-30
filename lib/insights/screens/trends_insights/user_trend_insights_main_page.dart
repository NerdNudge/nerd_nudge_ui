import 'package:flutter/material.dart';
import 'package:nerd_nudge/insights/screens/trends_insights/user_topic_trend_insights_chart.dart';
import '../../../utilities/colors.dart';
import '../../services/topic_trend_insights_service.dart';

class UserTrendsMainPage extends StatefulWidget {
  const UserTrendsMainPage({super.key, required this.userInsights});

  final Map<String, dynamic> userInsights;

  static Map<String, dynamic> userTrendsObject = {};
  static List<String> userTopics = [];

  @override
  State<UserTrendsMainPage> createState() => _UserTrendsMainPageState();

  static void setValues(Map<String, dynamic> userInsights) {
    userTrendsObject = userInsights['trendSummary'];
    userTopics = _getUserTopics();
  }

  static List<String> _getUserTopics() {
    List<String> userTopics = [];
    userTopics.add('global');
    if (userTrendsObject.containsKey('userTrends')) {
      Map<String, dynamic> userTrends = userTrendsObject['userTrends'];
      userTopics = userTrends.keys.toList();
    }

    return userTopics;
  }
}

class _UserTrendsMainPageState extends State<UserTrendsMainPage> {
  late String selectedTopic;
  late Widget _currentTopicScreen;
  late String _trendType;
  late String _alternativeTrendType;

  @override
  void initState() {
    super.initState();

    UserTrendsMainPage.setValues(widget.userInsights);
    _trendType = 'Score';
    _alternativeTrendType = 'Rank';
    _currentTopicScreen = _getUserTopicsForTrends();
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
          children: UserTrendsMainPage.userTopics.map((String option) {
            return FilterChip(
              label: Text(option),
              onSelected: (bool selected) {
                print(option);
                setState(() {
                  selectedTopic = option;
                  _currentTopicScreen = UserTrendDataChart.getSelectedTopicTrend(
                      context,
                      selectedTopic,
                      TopicTrendInsightsService().getTopicTrendInsights(selectedTopic, _trendType, UserTrendsMainPage.userTrendsObject), _trendType, closeButtonFunctionality);
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
