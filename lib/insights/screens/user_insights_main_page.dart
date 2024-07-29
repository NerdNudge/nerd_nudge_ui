import 'package:flutter/material.dart';
import 'package:load_switch/load_switch.dart';
import 'package:nerd_nudge/insights/screens/summary_insights/summary_insights.dart';
import 'package:nerd_nudge/insights/screens/trends_insights/user_trend_insights_main_page.dart';
import '../../menus/screens/menu_options.dart';
import '../../utilities/styles.dart';
import '../../bottom_menus/screens/bottom_menu_options.dart';
import '../services/insights_duration_state.dart';
import 'heatmap_insights/heatmaps_main_page.dart';
import 'topics_insights/topics_insights_main_page.dart';

class UserInsights extends StatefulWidget {
  const UserInsights({super.key});

  @override
  State<UserInsights> createState() => _UserInsightsState();
}

class _UserInsightsState extends State<UserInsights> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('Nerd Insights'),
        drawer: MenuOptions.getMenuDrawer(context),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: _getDashboardBody(),
        ),
        bottomNavigationBar: const BottomMenu(),
      ),
    );
  }

  Widget _getDashboardBody() {
    return Container(
      decoration: Styles.getBackgroundBoxDecoration(),
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lifetime   ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _getToggleButtonOptions(),
                  Text(
                    '   Last 30 days',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              SummaryInsights(key: UniqueKey()),
              TopicsInsights(),
              UserTrendsMainPage(key: UniqueKey()),
              HeatmapsMainPage(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getToggleButtonOptions() {
    Future<bool> _getFuture() async {
      await Future.delayed(const Duration(milliseconds: 200));
      InsightsDurationState.setLast30DaysFlag(
          !InsightsDurationState.last30DaysFlag);
      return InsightsDurationState.last30DaysFlag;
    }

    return LoadSwitch(
      value: InsightsDurationState.last30DaysFlag,
      future: _getFuture,
      style: SpinStyle.material,
      height: 22,
      width: 42,
      onChange: (bool newValue) {
        setState(() {
          InsightsDurationState.setLast30DaysFlag(newValue);
          SummaryInsights.setValues();
          UserTrendsMainPage.setValues();
        });
        bool val = InsightsDurationState.last30DaysFlag;
        print('Value changed to $val');
      },
      onTap: (bool _) {
        bool val = InsightsDurationState.last30DaysFlag;
        print('Tapping while value is $val');
      },
    );
  }
}