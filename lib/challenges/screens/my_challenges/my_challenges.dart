import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:nerd_nudge/challenges/screens/my_challenges/upcoming_challenges/upcoming_challenges_main_page.dart';

import '../../../utilities/colors.dart';
import 'active_challenges/active_challenges_main_page.dart';
import 'completed_challenges/completed_challenges_main_page.dart';

class MyChallenges extends StatelessWidget {
  const MyChallenges({super.key});

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedTabControl(
              tabTextColor: Colors.white,
              selectedTabTextColor: Colors.black,
              indicatorPadding: const EdgeInsets.all(4),
              squeezeIntensity: 2,
              tabPadding: const EdgeInsets.symmetric(horizontal: 8),
              tabs: [
                SegmentTab(
                  label: 'Active Challenges',
                  backgroundColor: CustomColors.mainThemeColor,
                  color: CustomColors.purpleButtonColor,
                ),
                SegmentTab(
                  label: 'Upcoming Challenges',
                  backgroundColor: CustomColors.mainThemeColor,
                  color: CustomColors.purpleButtonColor,
                ),
                SegmentTab(
                  label: 'Completed Challenges',
                  backgroundColor: CustomColors.mainThemeColor,
                  color: CustomColors.purpleButtonColor,
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(top: 70),
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              children: [
                MyActiveChallenges(),
                MyUpcomingChallenges(),
                MyCompletedChallenges(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
