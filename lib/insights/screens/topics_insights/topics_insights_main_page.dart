import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nerd_nudge/insights/screens/topics_insights/topic_drill_down_insights.dart';
import 'package:nerd_nudge/insights/screens/topics_insights/topics_summary_insights.dart';
import '../../../../utilities/styles.dart';
import '../Utilities/PeerComparisonInsights.dart';

class TopicsInsights extends StatefulWidget {
  const TopicsInsights({super.key});

  @override
  State<TopicsInsights> createState() => _TopicsInsightsState();
}

class _TopicsInsightsState extends State<TopicsInsights> {
  dynamic userSummary = json.decode(
      '{"overall":{"System Design":{"easy":7,"medium":11,"hard":3,"topics":[{"id":"Replication","questions_attempted":21,"percentage_correct":59},{"id":"Load Balancer","questions_attempted":19,"percentage_correct":71},{"id":"Caching","questions_attempted":11,"percentage_correct":88}]},"Java":{"easy":70,"medium":51,"hard":32,"topics":[{"id":"Multi-threading","questions_attempted":13,"percentage_correct":66},{"id":"OOPs Concepts","questions_attempted":26,"percentage_correct":88},{"id":"Data Structures","questions_attempted":31,"percentage_correct":77}]}},"last30days":{"System Design":{"easy":4,"medium":7,"hard":1,"topics":[{"id":"Replication","questions_attempted":11,"percentage_correct":76},{"id":"Caching","questions_attempted":5,"percentage_correct":96}]},"Java":{"easy":40,"medium":31,"hard":12,"topics":[{"id":"Multi-threading","questions_attempted":23,"percentage_correct":71},{"id":"Data Structures","questions_attempted":17,"percentage_correct":92}]}}}');

  final peerComparisonData = json.decode('{"Easy":[85.0,70.0,96.0],"Medium":[75.0,65.0,88.0],"Hard":[85.0,95.0,99.0],"userAvg":"85%","peersAvg":"78%","topAvg":"96%"}');

  late String selectedTopic;
  late Widget _currentTopicScreen = _getUserTopicsSummary();
  late var lifetimeSummary;
  late var last30DaysSummary;

  late List<String> lifetimeTopics;
  late List<String> last30DaysTopics;

  @override
  void initState() {
    super.initState();

    lifetimeSummary = userSummary['overall'];
    last30DaysSummary = userSummary['last30days'];

    updateTopics();
  }

  void updateTopics() {
    lifetimeTopics = [];
    last30DaysTopics = [];

    lifetimeSummary.forEach((topicName, topicDetails) {
      lifetimeTopics.add(topicName);
    });

    last30DaysSummary.forEach((topicName, topicDetails) {
      last30DaysTopics.add(topicName);
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
        SizedBox(height: 20),
        Styles.getTitleDescriptionWidgetWithSoftWrap(
          'Strongest Topic: ',
          'System Design',
          Colors.green,
          Colors.black,
          15,
          15,
        ),
        SizedBox(height: 5),
        Styles.getTitleDescriptionWidgetWithSoftWrap(
          'Weakest Topic: ',
          'Data Structures and Algorithms',
          Colors.red,
          Colors.black,
          15,
          15,
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
          children: lifetimeTopics.map((String option) {
            return FilterChip(
              label: Text(option),
              onSelected: (bool selected) {
                print(option);
                setState(() {
                  selectedTopic = option;
                  _currentTopicScreen = TopicSummaryInsights.getSelectedTopicSummary(context, selectedTopic, topicsDrillDown, getPeerComparison, closeButtonToTopicInsightsMainPage);
                });
              },
              selectedColor: Colors.white,
              checkmarkColor: Colors.green,
              backgroundColor: Colors.grey.shade500,
            );
          }).toList(),
        ),
      ],
    );
  }

  getPeerComparison() {
    print('Peer comparison called.');
    setState(() {
      _currentTopicScreen = PeerComparisonInsights(closeButton: closeButtonToTopicInsightsSummaryPage,
        peerComparisonData: peerComparisonData,
        topic: selectedTopic,);
    });
  }

  topicsDrillDown() {
    print('details clicked.');
    setState(() {
      _currentTopicScreen = TopicDrillDown.getTopicDrillDown(lifetimeSummary, selectedTopic, closeButtonToTopicInsightsSummaryPage);
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
      //_currentTopicScreen = _getUserTopicsSummary();
      _currentTopicScreen = TopicSummaryInsights.getSelectedTopicSummary(context, selectedTopic, topicsDrillDown, getPeerComparison, closeButtonToTopicInsightsMainPage);
    });
  }
}
