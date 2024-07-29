import 'package:flutter/material.dart';
import 'package:nerd_nudge/quiz/quiz_question/services/start_quiz.dart';
import 'package:nerd_nudge/topics/screens/subtopic_selection.dart';
import 'package:nerd_nudge/utilities/quiz_topics.dart';
import '../../../../utilities/styles.dart';
import '../../../bottom_menus/screens/bottom_menu_options.dart';
import '../../../menus/screens/menu_options.dart';

class TopicSelection {
  static String selectedTopic = '';
  static String selectedSubtopic = '';
}

class TopicSelectionHomePage extends StatefulWidget {
  TopicSelectionHomePage({super.key, required this.title, required this.showShotsOrQuiz});

  String title;
  Function showShotsOrQuiz;

  @override
  State<TopicSelectionHomePage> createState() => _TopicSelectionHomePageState();

  static getSelectedOptions() {
    return '_selectedOptions';
  }
}

class _TopicSelectionHomePageState extends State<TopicSelectionHomePage> {
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
                      itemCount: Topics.options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final option = Topics.options[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              TopicSelection.selectedTopic = option;
                            });
                            //startQuiz(context);
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
                                    Topics.getIconForTopics(option),
                                    size: 40,
                                    color: const Color(0xFF6A69EB),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          option,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Row(
                                          children: [
                                            Icon(Icons.people, size: 16, color: Colors.black54),
                                            SizedBox(width: 5),
                                            Text("1234 people took this", style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        const Row(
                                          children: [
                                            Icon(Icons.bar_chart, size: 16, color: Colors.black54),
                                            SizedBox(width: 5),
                                            Text("Average Score: 78%", style: TextStyle(fontSize: 12, color: Colors.black54)),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        const Row(
                                          children: [
                                            Icon(Icons.timer, size: 16, color: Colors.black54),
                                            SizedBox(width: 5),
                                            Text("Last Taken: 2 days ago", style: TextStyle(fontSize: 12, color: Colors.black54)),
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

  showSubtopics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubtopicSelectionPage(title: widget.title, showShotsOrQuiz: widget.showShotsOrQuiz,),
      ),
    );
  }

  startQuiz(BuildContext ctx) {
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