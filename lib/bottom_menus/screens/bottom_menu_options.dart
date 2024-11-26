import 'package:flutter/material.dart';
import 'package:nerd_nudge/explore_menu/screens/explore_home_page.dart';
import 'package:nerd_nudge/menus/screens/favorites/favorites_main_page.dart';

import '../../user_home_page/screens/home_page.dart';
import '../../user_profile/dto/user_profile_entity.dart';
import '../../utilities/colors.dart';
import '../../insights/screens/user_insights_main_page.dart';

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
        getBottomNavigationMenu(Icons.explore, 'Explore'),
        //getBottomNavigationMenu(Icons.school_rounded, 'Quiz'),
        //getBottomNavigationMenu(Icons.lightbulb, 'Shots'),
        //getBottomNavigationMenu(Icons.emoji_events, 'Challenges'),
        getBottomNavigationMenu(Icons.equalizer, 'Insights'),
        getBottomNavigationMenu(Icons.favorite_rounded, 'Favorites'),
        //getBottomNavigationMenu(Icons.person, 'Profile'),
      ],
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    setState(() {
      BottomMenu.selectedIndex = index;
    });

    StatefulWidget navigateScreen;
    switch (index) {
      case 0:
        UserProfileEntity userProfileEntity = UserProfileEntity();
        navigateScreen = HomePage(userFullName: userProfileEntity.getUserFullName(), userEmail: userProfileEntity.getUserEmail(),);
        break;
      case 1:
        navigateScreen = const ExplorePage();
        break;
      case 2:
        navigateScreen = const UserInsights();
        break;
      case 3:
        navigateScreen = const Favorites();
        break;
      /*case 4:
        navigateScreen = ProfileHome();
        break;*/
      case 4:
        //TODO: Replace with the Leaderboard page
        navigateScreen = const UserInsights();
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
