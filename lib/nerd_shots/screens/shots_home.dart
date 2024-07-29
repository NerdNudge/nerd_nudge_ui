import 'package:flutter/material.dart';
import 'package:nerd_nudge/nerd_shots/screens/nerd_shots_swiped.dart';
import 'package:nerd_nudge/topics/screens/topic_selection_home_page.dart';

class NerdShotsSelectedTopics {
  static final Set<String> selectedOptions = {};
}

class NerdShotsHome extends StatefulWidget {
  const NerdShotsHome({super.key});

  @override
  State<NerdShotsHome> createState() => _NerdShotsHomeState();

  static getSelectedOptions() {
    return '_selectedOptions';
  }
}

class _NerdShotsHomeState extends State<NerdShotsHome> {
  @override
  Widget build(BuildContext context) {
    return TopicSelectionHomePage(title: 'Nerd Shots', showShotsOrQuiz: startShots,);
  }

  startShots() {
    print('Start Shots home');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NerdShotsSwiped(),
        ),
      );
  }
}
