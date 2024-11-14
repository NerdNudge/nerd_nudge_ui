import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_question/services/start_quiz.dart';
import 'package:nerd_nudge/topics/screens/explore_topic_selection_home_page.dart';
import 'package:nerd_nudge/topics/screens/subtopic_selection.dart';
import 'package:nerd_nudge/topics/services/topics_service.dart';
import 'package:nerd_nudge/utilities/quiz_topics.dart';
import '../../../../utilities/styles.dart';
import '../../../bottom_menus/screens/bottom_menu_options.dart';
import '../../../menus/screens/menu_options.dart';

class TopicSelection {
  static String selectedTopic = '';
  static String selectedSubtopic = '';
}

class TopicSelectionHomePage extends StatefulWidget {
  TopicSelectionHomePage({super.key, required this.title, required this.showShotsOrQuiz, required this.page});

  String title;
  Function showShotsOrQuiz;
  String page;

  @override
  State<TopicSelectionHomePage> createState() => _TopicSelectionHomePageState();

  static getSelectedOptions() {
    return '_selectedOptions';
  }
}

class _TopicSelectionHomePageState extends State<TopicSelectionHomePage> {
  late List<dynamic> topics = [];

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    print('Topic selection home for $title');
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar(widget.title),
        drawer: MenuOptions.getMenuDrawer(context),
        body: _getBody(),
        bottomNavigationBar: const BottomMenu(),
      ),
    );
  }

  Future<void> _loadTopics() async {
    try {
      final result = await TopicsService().getTopics();
      if (result is Map<String, dynamic> && result.containsKey('data')) {
        final data = result['data'];
        final topicsData = data['topics'] as Map<String, dynamic>;
        final userStats = data['userStats'] as Map<String, dynamic>;

        setState(() {
          topics = topicsData.entries.map((entry) {
            final topicCode = entry.key;
            final topicDetails = entry.value;
            final topicName = topicDetails['topicName'];
            final numPeopleTaken = topicDetails['numPeopleTaken'];
            final userScoreIndicator = userStats[topicCode]?['personalScoreIndicator'] ?? 0.0;
            final lastTakenByUser = userStats[topicCode]?['lastTaken'] ?? 'Never';

            return {
              'topicCode': topicCode,
              'topicName': topicName,
              'numPeopleTaken': numPeopleTaken,
              'userScoreIndicator': userScoreIndicator,
              'lastTakenByUser': lastTakenByUser,
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Error loading topics: $e');
    }
  }

  Widget _getBody() {
    String title = widget.title;
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: Styles.getBackgroundBoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      '$title Topics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: topics.length,
                      itemBuilder: (BuildContext context, int index) {
                        final topic = topics[index];
                        final topicName = topic['topicName'];
                        final numPeople = topic['numPeopleTaken'];
                        final scoreIndicator = topic['userScoreIndicator'];
                        final lastTakenByUser = topic['lastTakenByUser'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              print('selected topic: $topicName');
                              TopicSelection.selectedTopic = topicName;
                              ExploreTopicSelection.selectedTopic = topicName;
                              ExploreTopicSelection.selectedTopicCode = topic['topicCode'];
                              QuizService.resetCurrentQuizzes();
                            });
                            showSubtopics(context);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const SizedBox(width: 5),
                                  Icon(
                                    Topics.getIconForTopics(topicName),
                                    size: 40,
                                    color: const Color(0xFF6A69EB),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          topicName,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.people, size: 16, color: Colors.black54),
                                            SizedBox(width: 5),
                                            Text(_getNumPeopleText(numPeople), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(Icons.speed, size: 16, color: Colors.black54),
                                            SizedBox(width: 5),
                                            Text("Personal Score Indicator: $scoreIndicator%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(Icons.timer, size: 16, color: Colors.black54),
                                            SizedBox(width: 5),
                                            Text("Last Taken: $lastTakenByUser", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getNumPeopleText(int num) {
    return (num == 1) ? '$num person took this.' : '$num people took this.';
  }

  void showSubtopics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubtopicSelectionPage(title: widget.title, showShotsOrQuiz: widget.showShotsOrQuiz, isPaywallOpen: false, page: widget.page,),
      ),
    );
  }

  void startQuiz(BuildContext ctx) {
    if (TopicSelection.selectedTopic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No Topic Selected',
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizService(),
        ),
      );
    }
  }
}