import 'package:flutter/material.dart';

import '../../home_page/screens/home_page.dart';
import '../../quiz/home/screens/quiz_home_page.dart';
import '../../utilities/colors.dart';
import '../../challenges/screens/main_challenge_page.dart';
import '../../insights/screens/user_insights_main_page.dart';
import '../../nerd_shots/screens/shots_home.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenuState();

  static int selectedIndex = 0;

  static _BottomMenuState? of(BuildContext context) {
    return context.findAncestorStateOfType<_BottomMenuState>();
  }

  static void updateIndex(int index) {
    selectedIndex = index;
  }
}

class _BottomMenuState extends State<BottomMenu> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: BottomMenu.selectedIndex,
      onTap: (int index) {
        _handleNavigation(context, index);
      },
      items: [
        getBottomNavigationMenu(Icons.home, 'Home'),
        getBottomNavigationMenu(Icons.school_rounded, 'Quiz'),
        getBottomNavigationMenu(Icons.lightbulb, 'Shots'),
        getBottomNavigationMenu(Icons.emoji_events, 'Challenges'),
        getBottomNavigationMenu(Icons.equalizer, 'Insights'),
        //getBottomNavigationMenu(Icons.person, 'Profile'),
      ],
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    setState(() {
      BottomMenu.selectedIndex = index;
    });

    var navigateScreen;
    switch (index) {
      case 0:
        navigateScreen = HomePage();
        break;
      case 1:
        navigateScreen = QuizHomePage();
        break;
      case 2:
        navigateScreen = NerdShotsHome();
        break;
      case 3:
        navigateScreen = ChallengesPage();
        break;
      /*case 4:
        navigateScreen = ProfileHome();
        break;*/
      case 4:
        //TODO: Replace with the Leaderboard page
        navigateScreen = UserInsights();
        break;
      /*case 4:
        //TODO: Replace with the Profile page
        navigateScreen = HomePage();
        break;*/
      default:
        throw Exception('Invalid Menu option.');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => navigateScreen,
      ),
    );
  }

  BottomNavigationBarItem getBottomNavigationMenu(
      IconData iconData, String label) {
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: Colors.white,
        size: 25,
      ),
      label: label,
      backgroundColor: CustomColors.mainThemeColor,
    );
  }
}
