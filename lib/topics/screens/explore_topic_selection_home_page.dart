import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_question/services/start_quiz.dart';
import 'package:nerd_nudge/subscriptions/screens/paywall_panel_screen.dart';
import 'package:nerd_nudge/topics/screens/subtopic_selection.dart';
import 'package:nerd_nudge/topics/screens/topic_selection_home_page.dart';
import 'package:nerd_nudge/topics/services/topics_service.dart';
import 'package:nerd_nudge/utilities/quiz_topics.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../../utilities/styles.dart';
import '../../../bottom_menus/screens/bottom_menu_options.dart';
import '../../../menus/screens/menu_options.dart';
import '../../nerd_shots/screens/nerd_shots_swiped.dart';
import '../../subscriptions/services/purchase_api.dart';
import '../../utilities/constants.dart';
import '../../utilities/logger.dart';

class ExploreTopicSelection {
  static String selectedTopic = '';
  static String selectedTopicCode = '';
  static String selectedSubtopic = '';
}

class ExploreTopicSelectionHomePage extends StatefulWidget {
  ExploreTopicSelectionHomePage({super.key});

  @override
  State<ExploreTopicSelectionHomePage> createState() =>
      _ExploreTopicSelectionHomePageState();

  String title = 'Nerd Topics';
}

class _ExploreTopicSelectionHomePageState
    extends State<ExploreTopicSelectionHomePage> {
  late List<dynamic> topics = [];
  static PanelController _topicSelectionPanelController = PanelController();
  static PanelController _challengesPaywallPanelController = PanelController();
  late Map<String, dynamic> userStats = {};
  static late Map<String, dynamic> topicsConfig = {'rwcDailyQuizLimit': '10', 'rwcDailyQuizTime': '8'};

  static List<Map<String, dynamic>> topicSelectionActions = [
    {
      'id': 'NQ',
      'icon': Icons.school_rounded,
      'title': 'Nerd Quiz',
      'subtitle':
          'Test your knowledge with curated quizzes on various sub-topics.',
    },
    {
      'id': 'NS',
      'icon': Icons.lightbulb,
      'title': 'Nerd Shots',
      'subtitle': 'Swipe through quick, byte-sized, digestible tech insights and facts.',
    },
    {
      'id': 'RWC',
      'icon': Icons.emoji_events,
      'title': 'Real-World Challenges',
      'subtitle':
          'Daily challenges: Tackle practical, real-world scenarios to boost your problem-solving skills.',
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  @override
  Widget build(BuildContext context) {
    NerdLogger.logger.d('Topic selection home for Explore Topics');
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
        userStats = data['userStats'] as Map<String, dynamic>;

        setState(() {
          topicsConfig = data['config'] as Map<String, dynamic>;
          NerdLogger.logger.d('topics Config: $topicsConfig');
          topics = topicsData.entries.map((entry) {
            final topicCode = entry.key;
            final topicDetails = entry.value;
            final topicName = topicDetails['topicName'];
            final numPeopleTaken = topicDetails['numPeopleTaken'];
            final userScoreIndicator =
                userStats[topicCode]?['personalScoreIndicator'] ?? 0.0;
            final lastTakenByUser =
                userStats[topicCode]?['lastTaken'] ?? 'Never';

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
      NerdLogger.logger.e('Error loading topics: $e');
      Styles.showGlobalSnackbarMessage('Failed to load topics. Please try again.');
    }
  }

  Widget _getBody() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: Styles.getBackgroundBoxDecoration(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                              NerdLogger.logger.d('selected topic: $topicName');
                              ExploreTopicSelection.selectedTopic = topicName;
                              ExploreTopicSelection.selectedTopicCode = topic['topicCode'];
                              TopicSelection.selectedTopic = topicName;
                              QuizService.resetCurrentQuizzes();
                            });
                            showTopicsSelectionPaywall(context);
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            const Icon(Icons.people,
                                                size: 16,
                                                color: Colors.black54),
                                            const SizedBox(width: 5),
                                            Text(_getNumPeopleText(numPeople),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54)),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(Icons.speed,
                                                size: 16,
                                                color: Colors.black54),
                                            const SizedBox(width: 5),
                                            Text(
                                                "Personal Score Indicator: $scoreIndicator%",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54)),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(Icons.timer,
                                                size: 16,
                                                color: Colors.black54),
                                            const SizedBox(width: 5),
                                            Text("Last Taken: $lastTakenByUser",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black54)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
        getSlidingPanel(context, _topicSelectionPanelController),
        getSlidingPanel(context, _challengesPaywallPanelController),
      ],
    );
  }

  Widget getSlidingPanel(
      BuildContext context, PanelController panelController) {
    return SlidingUpPanel(
      controller: panelController,
      color: Colors.grey.shade900,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.55,
      panel: Container(
        decoration: Styles.getBoxDecorationForPaywall(),
        child: _getPaywallPanel(context, panelController),
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      backdropEnabled: true,
      backdropTapClosesPanel: true,
    );
  }

  Widget _getPaywallPanel(BuildContext context, PanelController panelController) {
    if(panelController == _topicSelectionPanelController) {
      return _buildTopicSelectionActionsPaywallPanel(context);
    }
    else {
      //return PaywallPanel.buildDailyChallengePaywallPanel(context, ExploreTopicSelection.selectedTopic, ExploreTopicSelection.selectedTopicCode, userStats, int.parse(topicsConfig['rwcDailyQuizLimit']), int.parse(topicsConfig['rwcDailyQuizTime']));
      if (PurchaseAPI.userCurrentOffering == Constants.FREEMIUM) {
        return PaywallPanel.buildUpgradeAccountPaywallPanel(context,
            'Upgrade your account to enjoy daily real-world challenges across topics.');
      }
      else {
        return PaywallPanel.buildDailyChallengePaywallPanel(context, ExploreTopicSelection.selectedTopic, ExploreTopicSelection.selectedTopicCode, userStats, int.parse(topicsConfig['rwcDailyQuizLimit']), int.parse(topicsConfig['rwcDailyQuizTime']));
      }
    }
  }

  Widget _buildTopicSelectionActionsPaywallPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Styles.getSizedHeightBox(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Center(
            child: Text(
              ExploreTopicSelection.selectedTopic,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Styles.getSizedHeightBox(20),
        Expanded(
          // Ensures the ListView takes remaining space
          child: ListView.builder(
            itemCount: topicSelectionActions.length,
            itemBuilder: (context, index) {
              final transaction = topicSelectionActions[index];
              return GestureDetector(
                onTap: () {
                  handleTopicAction(context, transaction['id'] ?? 'NS');
                },
                child: Card(
                  elevation: 4,
                  color: Colors.white38,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Container(
                            color: Colors.white24,
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              transaction['icon']!,
                              size: 40, // Icon size
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction['title']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                transaction['subtitle']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  handleTopicAction(BuildContext context, String id) {
    if(id == 'NQ') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubtopicSelectionPage(title: 'Nerd Quiz', showShotsOrQuiz: startQuiz, isPaywallOpen: false, page: 'Quizflex',),
        ),
      );
    }
    else if(id == 'NS') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubtopicSelectionPage(title: 'Nerd Shots', showShotsOrQuiz: startShots, isPaywallOpen: false, page: 'Shots',),
        ),
      );
    }
    else {
      _challengesPaywallPanelController.open();
    }
  }

  startShots() {
    Styles.showGlobalSnackbarMessageAndIcon('Swipe Right for the next shot!', Icons.swipe, Colors.black);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NerdShotsSwiped(),
      ),
    );
  }

  String _getNumPeopleText(int num) {
    return (num == 1) ? '$num person took this.' : '$num people took this.';
  }

  void showTopicsSelectionPaywall(BuildContext context) {
    _topicSelectionPanelController.open();
  }

  void startQuiz() {
    if (ExploreTopicSelection.selectedTopic.isEmpty) {
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
          builder: (context) => const QuizService(),
        ),
      );
    }
  }
}
