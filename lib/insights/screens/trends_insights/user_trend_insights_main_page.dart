import 'package:flutter/material.dart';
import 'package:nerd_nudge/insights/screens/trends_insights/user_topic_trend_insights_chart.dart';
import '../../../topics/services/topics_service.dart';
import '../../../utilities/colors.dart';

class UserTrendsMainPage extends StatefulWidget {
  const UserTrendsMainPage({super.key, required this.userInsights});

  final Map<String, dynamic> userInsights;

  static Map<String, dynamic> userTrendsObject = {};
  static late List<String> userTopics;

  @override
  State<UserTrendsMainPage> createState() => _UserTrendsMainPageState();

  static Future<void> setValues(Map<String, dynamic> userInsights) async {
    userTrendsObject = userInsights['trendSummary'];
    userTopics = await _getUserTopics();
  }

  static Future<List<String>> _getUserTopics() async {
    List<String> userTopics = [];
    userTopics.add('global');
    return TopicsService().getTopicCodesToNamesMapping().then((topicCodesToNamesMapping) {
      if (userTrendsObject.containsKey('userTrends')) {
        Map<String, dynamic> userTrends = userTrendsObject['userTrends'];
        userTopics = userTrends.keys.map((topicCode) {
          return topicCodesToNamesMapping[topicCode] ?? topicCode;
        }).toList();
      }

      print('returning now: $userTopics');
      return userTopics;
    }).catchError((error) {
      print('Error occurred: $error');
      return userTopics;
    });
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
    Future<Map<String, String>> topicNamesToCodesMapping = TopicsService().getTopicNamesToCodesMapping();
    return FutureBuilder<Map<String, String>>(
      future: topicNamesToCodesMapping,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          Map<String, String> actualTopicNamesToCodesMapping = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Trend Insights',
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
                    labelStyle: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (bool selected) {
                      print(option);
                      print(actualTopicNamesToCodesMapping[option]!);
                      setState(() {
                        selectedTopic = option;
                        _currentTopicScreen = UserTrendDataChart.getSelectedTopicTrend(
                            context,
                            selectedTopic,
                            _alternativeTrendType,
                            actualTopicNamesToCodesMapping,
                            _trendType,
                            closeButtonFunctionality,
                                (newScreen) {
                              setState(() {
                                _currentTopicScreen = newScreen;
                              });
                            });
                      });
                    },
                    selectedColor: CustomColors.mainThemeColor,
                    checkmarkColor: Colors.white,
                    backgroundColor: Colors.grey.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
            ],
          );
        } else {
          return Center(child: Text('No mappings available'));
        }
      },
    );
  }


  closeButtonFunctionality() {
    setState(() {
      _currentTopicScreen = _getUserTopicsForTrends();
    });
  }
}