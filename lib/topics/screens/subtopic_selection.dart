import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/home/screens/quiz_home_page.dart';
import 'package:nerd_nudge/quiz/quiz_question/services/start_quiz.dart';
import 'package:nerd_nudge/topics/screens/topic_selection_home_page.dart';
import 'package:nerd_nudge/utilities/quiz_topics.dart';
import 'dart:math';

import '../../../../utilities/styles.dart';
import '../../../bottom_menus/screens/bottom_menu_options.dart';
import '../../../menus/screens/menu_options.dart';

class SubtopicSelectionPage extends StatefulWidget {
  const SubtopicSelectionPage(
      {super.key, required this.title, required this.showShotsOrQuiz});
  final String title;
  final Function showShotsOrQuiz;

  @override
  State<SubtopicSelectionPage> createState() => _SubtopicSelectionPageState();
}

class _SubtopicSelectionPageState extends State<SubtopicSelectionPage> {
  Map<String, dynamic> subtopics =
      Topics.getSubtopics(TopicSelection.selectedTopic);

  @override
  Widget build(BuildContext context) {
    print('Sub topics called');
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
    List<String> keys = subtopics.keys.toList();
    String title = widget.title;
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
                  Center(
                    child: Text(
                      '$title Sub-topics',
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
                        TopicSelection.selectedSubtopic = 'Random';
                        /*TopicSelection.selectedSubtopic =
                            keys[Random().nextInt(keys.length)];*/
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
                        String key = keys[index];
                        String value = subtopics[key]!;
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      key,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6A69EB),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF6A69EB),
                                        minimumSize: Size(15, 35),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          TopicSelection.selectedSubtopic = key;
                                          print('Selected subtopic: $key');
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
                                    15),
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
