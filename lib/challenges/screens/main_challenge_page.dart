import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';

import '../../../utilities/styles.dart';
import '../../menus/screens/menu_options.dart';
import '../../utilities/colors.dart';
import '../../bottom_menus/screens/bottom_menu_options.dart';
import 'explore_challenges/explore_challenges.dart';
import 'my_challenges/my_challenges.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('Nerd Challenges'),
        drawer: MenuOptions.getMenuDrawer(context),
        body: _getBody(),
        bottomNavigationBar: const BottomMenu(),
      ),
    );
  }

  _getBody() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: Styles.getBackgroundBoxDecoration(),/*BoxDecoration(
              color: Colors.black, // Background color of the box
              borderRadius: BorderRadius.circular(0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
            ),*/
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SegmentedTabControl(
                    controller: _tabController,
                    tabTextColor: Colors.white,
                    selectedTabTextColor: CustomColors.purpleButtonColor,
                    indicatorPadding: const EdgeInsets.all(4),
                    squeezeIntensity: 2,
                    tabPadding: const EdgeInsets.symmetric(horizontal: 8),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    tabs: [
                      SegmentTab(
                        label: 'Explore Challenges',
                        backgroundColor: Colors.black,
                        color: Colors.black,
                      ),
                      SegmentTab(
                        label: 'My Challenges',
                        color: Colors.black,
                        backgroundColor: Colors.black,
                      ),
                    ],
                    indicatorDecoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: CustomColors.purpleButtonColor, width: 2),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                        ),
                        child: ExploreChallenges(),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                        ),
                        child: MyChallenges(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
