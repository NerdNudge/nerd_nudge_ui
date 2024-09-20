import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nerd_nudge/insights/screens/topics_insights/topic_drill_down_insights.dart';
import 'package:nerd_nudge/insights/screens/topics_insights/topics_summary_insights.dart';
import '../../../../utilities/styles.dart';
import '../../../topics/services/topics_service.dart';
import '../../../utilities/colors.dart';
import '../../services/insights_duration_state.dart';
import '../Utilities/PeerComparisonInsights.dart';

class TopicsInsights extends StatefulWidget {
  TopicsInsights({super.key, required this.userInsights});

  final Map<String, dynamic> userInsights;

  @override
  State<TopicsInsights> createState() => _TopicsInsightsState();

  static Map<String, dynamic> userTopicsInsightsObject = {};

  static late String selectedTopic;
  static late var summaryToDisplay;

  static late Map<String, String> topicCodesToNamesMap;
  static late Map<String, String> topicNamesToCodesMap;

  static late List<String> topicsToDisplay;

  static Future<void> updateTopics(Map<String, dynamic> userInsights) async {
    userTopicsInsightsObject = userInsights['topicSummary'];
    if (userTopicsInsightsObject == null) {
      print('userTopicsInsightsObject is null');
    } else {

      print('user insights: $userInsights');
      print('user topics insights: $userTopicsInsightsObject');

      topicsToDisplay = [];
      topicCodesToNamesMap = await _getTopicCodesToNamesMap();
      topicNamesToCodesMap = await _getTopicNamesToCodesMap();

      print('topic codes to names mapping: $topicCodesToNamesMap');
      print('topic names to codes mapping: $topicNamesToCodesMap');

      summaryToDisplay = InsightsDurationState.last30DaysFlag ? userTopicsInsightsObject['last30Days'] : userTopicsInsightsObject['lifetime'];

      if (summaryToDisplay != null) {
        summaryToDisplay.forEach((topicName, topicDetails) {
          topicsToDisplay.add(topicCodesToNamesMap[topicName] ?? topicName);
        });
      }
    }
  }

  static Future<Map<String, String>> _getTopicCodesToNamesMap() async {
    return TopicsService().getTopicCodesToNamesMapping().then((topicCodesToNamesMapping) {
      return topicCodesToNamesMapping;
    }).catchError((error) {
      print('Error occurred: $error');
      return <String, String>{};
    });
  }

  static Future<Map<String, String>> _getTopicNamesToCodesMap() async {
    return TopicsService().getTopicNamesToCodesMapping().then((topicNamesToCodesMapping) {
      return topicNamesToCodesMapping;
    }).catchError((error) {
      print('Error occurred: $error');
      return <String, String>{};
    });
  }
}

class _TopicsInsightsState extends State<TopicsInsights> {
  var peerComparisonData = json.decode('{"Easy":[85.0,70.0,96.0],"Medium":[75.0,65.0,88.0],"Hard":[85.0,95.0,99.0],"userAvg":"85%","peersAvg":"78%","topAvg":"96%"}');
  late Widget _currentTopicScreen = _getUserTopicsSummary();

  @override
  initState() {
    super.initState();
    _fetchAndSetTopics();
  }

  Future<void> _fetchAndSetTopics() async {
    await TopicsInsights.updateTopics(widget.userInsights);
    setState(() {
      _currentTopicScreen = _getUserTopicsSummary();
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

  _getUserTopicsSummary() {
    print('Topics under summary(): ${TopicsInsights.topicsToDisplay}');
    print('Topics summary under summary(): ${TopicsInsights.summaryToDisplay}');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            'Topic Insights',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Styles.getSizedHeightBox(20),
        Styles.getTitleDescriptionWidgetWithSoftWrap(
          'Strongest Topic: ',
          'System Design',
          Colors.green,
          Colors.black,
          15,
          15,
        ),
        Styles.getSizedHeightBox(5),
        Styles.getTitleDescriptionWidgetWithSoftWrap(
          'Weakest Topic: ',
          'Data Structures and Algorithms',
          Colors.red,
          Colors.black,
          15,
          15,
        ),
        Styles.getSizedHeightBox(20),
        Text(
          'Select a Topic: ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Styles.getSizedHeightBox(13),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: TopicsInsights.topicsToDisplay.map((String option) {
            print('topic in card: $option');
            return FilterChip(
              label: Text(option),
              labelStyle: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              onSelected: (bool selected) {
                print(option);
                setState(() {
                  TopicsInsights.selectedTopic = option;
                  String? topicCode = TopicsInsights.topicNamesToCodesMap[option];
                  int topicRank = widget.userInsights['rankings']?[topicCode] ?? 0;
                  print('Topic rank: $topicRank');
                  _currentTopicScreen = TopicSummaryInsights.getSelectedTopicSummary(context, TopicsInsights.summaryToDisplay[topicCode], TopicsInsights.selectedTopic, topicsDrillDown, getPeerComparison, closeButtonToTopicInsightsMainPage, topicRank);
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
        Styles.getSizedHeightBox(10),
      ],
    );
  }

  getPeerComparison() async {
    String? topicCode = TopicsInsights.topicNamesToCodesMap[TopicsInsights.selectedTopic];
    print('Selected topic: ${TopicsInsights.selectedTopic}, topic code: $topicCode');
    var topicSummary = TopicsInsights.summaryToDisplay[topicCode];

    if (topicSummary == null) {
      print('No data available for the selected topic.');
      return;
    }

    var peerComparison = topicSummary['peerComparison'];

    if (peerComparison == null) {
      print('No peer comparison data available for the selected topic.');
      return;
    }

    print('Peer comparison called.');
    peerComparisonData = peerComparison;
    print('Peer comparison data for topic: $peerComparisonData');
    setState(() {
      _currentTopicScreen = PeerComparisonInsights(
        closeButton: closeButtonToTopicInsightsSummaryPage,
        peerComparisonData: peerComparisonData,
        topic: TopicsInsights.selectedTopic,
      );
    });
  }

  topicsDrillDown() {
    print('details clicked.');
    setState(() {
      String? topicCode = TopicsInsights.topicNamesToCodesMap[TopicsInsights.selectedTopic];
      _currentTopicScreen = TopicDrillDown.getTopicDrillDown(TopicsInsights.summaryToDisplay, topicCode, closeButtonToTopicInsightsSummaryPage);
    });
  }

  closeButtonToTopicInsightsMainPage() {
    setState(() {
      _currentTopicScreen = _getUserTopicsSummary();
    });
  }

  closeButtonToTopicInsightsSummaryPage() {
    print('Close button clicked.');
    setState(() {
      String? topicCode = TopicsInsights.topicNamesToCodesMap[TopicsInsights.selectedTopic];
      int topicRank = widget.userInsights['rankings']?[topicCode] ?? 0;
      print('Topic rank: $topicRank');
      _currentTopicScreen = TopicSummaryInsights.getSelectedTopicSummary(context, TopicsInsights.summaryToDisplay[topicCode], TopicsInsights.selectedTopic, topicsDrillDown, getPeerComparison, closeButtonToTopicInsightsMainPage, topicRank);
    });
  }
}
