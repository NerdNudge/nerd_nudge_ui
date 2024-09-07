import 'package:flutter/material.dart';
import 'package:nerd_nudge/topics/screens/topic_selection_home_page.dart';

import '../../../../utilities/styles.dart';
import '../../../bottom_menus/screens/bottom_menu_options.dart';
import '../../../menus/screens/menu_options.dart';
import '../services/topics_service.dart';

class SubtopicSelectionPage extends StatefulWidget {
  const SubtopicSelectionPage({super.key, required this.title, required this.showShotsOrQuiz});
  final String title;
  final Function showShotsOrQuiz;

  @override
  State<SubtopicSelectionPage> createState() => _SubtopicSelectionPageState();
}

class _SubtopicSelectionPageState extends State<SubtopicSelectionPage> {
  late List<Map<String, String>> subtopics = [];
  bool isLoading = true; // Add a loading state flag

  _getSubtopics() async {
    try {
      final result = await TopicsService().getSubtopics(TopicSelection.selectedTopic);
      setState(() {
        subtopics = result;
        isLoading = false; // Set loading to false once data is fetched
      });
    } catch (e) {
      print('Error loading topics: $e');
      setState(() {
        isLoading = false; // Ensure loading is set to false even on error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getSubtopics();  // Load subtopics when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    String topicsel = TopicSelection.selectedTopic;
    print('Subtopics called for topic: $topicsel');

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
      // Show a CircularProgressIndicator while loading
      return Center(child: CircularProgressIndicator());
    }

    if (subtopics.isEmpty) {
      return Center(child: Text('No subtopics available.'));
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
                          TopicSelection.selectedSubtopic = 'Random';
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
                                        backgroundColor: Color(0xFF6A69EB),
                                        minimumSize: Size(15, 35),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          TopicSelection.selectedSubtopic = key;
                                          String ts = TopicSelection.selectedTopic;
                                          print('Selected subtopic: $key for topic: $ts');
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
      ],
    );
  }
}