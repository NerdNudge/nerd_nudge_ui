import 'package:flutter/material.dart';
import 'package:nerd_nudge/topics/screens/explore_topic_selection_home_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../utilities/styles.dart';
import '../../../bottom_menus/screens/bottom_menu_options.dart';
import '../../../menus/screens/menu_options.dart';
import '../../subscriptions/screens/paywall_panel_screen.dart';
import '../../utilities/logger.dart';
import '../services/topics_service.dart';

class SubtopicSelectionPage extends StatefulWidget {
  SubtopicSelectionPage({
    super.key,
    required this.title,
    required this.showShotsOrQuiz,
    required this.isPaywallOpen,
    required this.page,
  });

  final String title;
  final Function showShotsOrQuiz;
  bool isPaywallOpen;
  final String page;

  @override
  State<SubtopicSelectionPage> createState() => _SubtopicSelectionPageState();
}

class _SubtopicSelectionPageState extends State<SubtopicSelectionPage> {
  late List<Map<String, String>> subtopics = [];
  bool isLoading = true;
  bool isError = false; // Flag to check if there's an error
  final PanelController _panelController = PanelController();

  _getSubtopics() async {
    try {
      final result = await TopicsService().getSubtopics(ExploreTopicSelection.selectedTopic);
      if (result == null || result.isEmpty) {
        throw Exception('No subtopics found'); // Handling the case where the result is empty
      }
      setState(() {
        subtopics = result;
        isLoading = false;
        isError = false; // Reset error state on success
      });
    } catch (e) {
      NerdLogger.logger.e('Error loading topics: $e'); // Logs error
      setState(() {
        isLoading = false;
        isError = true; // Set error state to true
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getSubtopics(); // Load subtopics when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    String topicsel = ExploreTopicSelection.selectedTopic;
    NerdLogger.logger.d('Subtopics called for topic: $topicsel');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_panelController.isAttached) {
        if (widget.isPaywallOpen) {
          _panelController.open(); // Open the paywall if still mounted
        } else {
          _panelController.close(); // Close the panel if still mounted
        }
      }
    });

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

  Widget _getBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Error loading subtopics. Please try again.'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  _getSubtopics(); // Retry fetching subtopics
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (subtopics.isEmpty) {
      return const Center(child: Text('No subtopics available.'));
    }

    List<String> keys = subtopics.map((e) => e['name'] ?? 'Unnamed').toList();
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
                      '${widget.title} Sub-topics',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        if (keys.isNotEmpty) {
                          ExploreTopicSelection.selectedSubtopic = 'Random';
                        }
                      });
                      widget.showShotsOrQuiz();
                    },
                    child: const Text(
                      'Randomize Sub-topics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: subtopics.length,
                      itemBuilder: (context, index) {
                        String? key = subtopics[index]['subtopicName'];
                        String value = subtopics[index]['description'] ?? 'No description available';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        key!,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6A69EB),
                                        ),
                                        overflow: TextOverflow.ellipsis, // Handle overflow
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF6A69EB),
                                        minimumSize: const Size(15, 35),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          ExploreTopicSelection.selectedSubtopic = key;
                                          String ts = ExploreTopicSelection.selectedTopic;
                                          NerdLogger.logger.i('Selected subtopic: $key for topic: $ts');
                                        });
                                        widget.showShotsOrQuiz();
                                      },
                                      child: const Text(
                                        '>',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Styles.getTitleDescriptionWidget(
                                  'Desc: ',
                                  value,
                                  const Color(0xFF6A69EB),
                                  Colors.black54,
                                  16,
                                  15,
                                ),
                                const SizedBox(height: 8.0),
                              ],
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
        PaywallPanel.getSlidingPanel(context, _panelController, widget.page),
      ],
    );
  }
}