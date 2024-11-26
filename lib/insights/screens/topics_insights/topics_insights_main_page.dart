import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nerd_nudge/insights/screens/topics_insights/topic_drill_down_insights.dart';
import 'package:nerd_nudge/insights/screens/topics_insights/topics_summary_insights.dart';
import '../../../../utilities/styles.dart';
import '../../../topics/services/topics_service.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/logger.dart';
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
  static late Map<String, String> topicNamesToCodesMap = {};

  static late List<String> topicsToDisplay;

  static Future<void> updateTopics(Map<String, dynamic> userInsights) async {
    userTopicsInsightsObject = userInsights['topicSummary'];
    if (userTopicsInsightsObject == null) {
      NerdLogger.logger.d('userTopicsInsightsObject is null');
    } else {
      topicsToDisplay = [];
      topicCodesToNamesMap = await _getTopicCodesToNamesMap();
      topicNamesToCodesMap = await _getTopicNamesToCodesMap();

      NerdLogger.logger.d('topic codes to names mapping: $topicCodesToNamesMap');
      NerdLogger.logger.d('topic names to codes mapping: $topicNamesToCodesMap');

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
      NerdLogger.logger.e('Error occurred: $error');
      return <String, String>{};
    });
  }

  static Future<Map<String, String>> _getTopicNamesToCodesMap() async {
    return TopicsService().getTopicNamesToCodesMapping().then((topicNamesToCodesMapping) {
      return topicNamesToCodesMapping;
    }).catchError((error) {
      NerdLogger.logger.e('Error occurred: $error');
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
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      color: Colors.white,
      child: ListTile(
        title: _currentTopicScreen,
      ),
    );
  }

  _getUserTopicsSummary() {
    NerdLogger.logger.d('Topics under summary(): ${TopicsInsights.topicsToDisplay}');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Center(
          child: Text(
            'Topic Insights',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Styles.getSizedHeightBoxByScreen(context, 20),
        Styles.getTitleDescriptionWidgetWithSoftWrap(
          'Strongest Topic: ',
          'System Design',
          Colors.green,
          Colors.black,
          15,
          15,
        ),
        Styles.getSizedHeightBoxByScreen(context, 5),
        Styles.getTitleDescriptionWidgetWithSoftWrap(
          'Weakest Topic: ',
          'Data Structures and Algorithms',
          Colors.red,
          Colors.black,
          15,
          15,
        ),
        Styles.getSizedHeightBoxByScreen(context, 20),
        const Text(
          'Select a Topic: ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Styles.getSizedHeightBoxByScreen(context, 13),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: TopicsInsights.topicsToDisplay.map((String option) {
            NerdLogger.logger.d('topic in card: $option');
            return FilterChip(
              label: Text(option),
              labelStyle: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              onSelected: (bool selected) {
                NerdLogger.logger.d(option);
                setState(() {
                  TopicsInsights.selectedTopic = option;
                  String? topicCode = TopicsInsights.topicNamesToCodesMap[option];
                  int topicRank = widget.userInsights['rankings']?[topicCode] ?? 0;
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
        Styles.getSizedHeightBoxByScreen(context, 10),
      ],
    );
  }

  getPeerComparison() async {
    String? topicCode = TopicsInsights.topicNamesToCodesMap[TopicsInsights.selectedTopic];
    var topicSummary = TopicsInsights.summaryToDisplay[topicCode];

    if (topicSummary == null) {
      NerdLogger.logger.d('No data available for the selected topic.');
      return;
    }

    var peerComparison = topicSummary['peerComparison'];

    if (peerComparison == null) {
      NerdLogger.logger.d('No peer comparison data available for the selected topic.');
      return;
    }

    peerComparisonData = peerComparison;
    setState(() {
      _currentTopicScreen = PeerComparisonInsights(
        closeButton: closeButtonToTopicInsightsSummaryPage,
        peerComparisonData: peerComparisonData,
        topic: TopicsInsights.selectedTopic,
      );
    });
  }

  topicsDrillDown() {
    setState(() {
      String? topicCode = TopicsInsights.topicNamesToCodesMap[TopicsInsights.selectedTopic];
      _currentTopicScreen = TopicDrillDown.getTopicDrillDown(context, TopicsInsights.summaryToDisplay, topicCode, closeButtonToTopicInsightsSummaryPage);
    });
  }

  closeButtonToTopicInsightsMainPage() {
    setState(() {
      _currentTopicScreen = _getUserTopicsSummary();
    });
  }

  closeButtonToTopicInsightsSummaryPage() {
    setState(() {
      String? topicCode = TopicsInsights.topicNamesToCodesMap[TopicsInsights.selectedTopic];
      int topicRank = widget.userInsights['rankings']?[topicCode] ?? 0;
      _currentTopicScreen = TopicSummaryInsights.getSelectedTopicSummary(context, TopicsInsights.summaryToDisplay[topicCode], TopicsInsights.selectedTopic, topicsDrillDown, getPeerComparison, closeButtonToTopicInsightsMainPage, topicRank);
    });
  }
}
