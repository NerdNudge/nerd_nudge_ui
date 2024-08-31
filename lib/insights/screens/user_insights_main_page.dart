import 'package:flutter/material.dart';
import 'package:load_switch/load_switch.dart';
import 'package:nerd_nudge/insights/screens/summary_insights/summary_insights.dart';
import 'package:nerd_nudge/insights/screens/trends_insights/user_trend_insights_main_page.dart';
import 'package:nerd_nudge/topics/services/topics_service.dart';
import '../../menus/screens/menu_options.dart';
import '../../utilities/styles.dart';
import '../../bottom_menus/screens/bottom_menu_options.dart';
import '../services/insights_duration_state.dart';
import '../services/user_insights_service.dart';
import 'heatmap_insights/heatmaps_main_page.dart';
import 'topics_insights/topics_insights_main_page.dart';

class UserInsights extends StatefulWidget {
  const UserInsights({super.key});

  @override
  State<UserInsights> createState() => _UserInsightsState();
}

class _UserInsightsState extends State<UserInsights> {
  int touchedIndex = -1;
  Future<Map<String, dynamic>>? userInsightsFuture;

  @override
  void initState() {
    super.initState();
    userInsightsFuture = _fetchUserInsights();
  }

  Future<Map<String, dynamic>> _fetchUserInsights() async {
    try {
      return await UserInsightsService().getUserInsights();
    } catch (e) {
      print('Error fetching user insights: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: Styles.getAppBar('Nerd Insights'),
        drawer: MenuOptions.getMenuDrawer(context),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: userInsightsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Error loading insights.', style: TextStyle(color: Colors.white)));
              } else {
                return _getDashboardBody(snapshot.data!);
              }
            },
          ),
        ),
        bottomNavigationBar: const BottomMenu(),
      ),
    );
  }

  Widget _getDashboardBody(Map<String, dynamic> userInsights) {
    return Container(
      decoration: Styles.getBackgroundBoxDecoration(),
      child: Column(
        children: [
          SizedBox(height: 50.0),
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
                  _getToggleButtonOptions(userInsights),
                  Text(
                    '   Last 30 days',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              SummaryInsights(key: UniqueKey(), userInsights: userInsights,), // Pass the data here
              TopicsInsights(),
              UserTrendsMainPage(key: UniqueKey(), userInsights: userInsights,),
              HeatmapsMainPage(userInsights: userInsights,),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getToggleButtonOptions(Map<String, dynamic> userInsights) {
    Future<bool> _getFuture() async {
      await Future.delayed(const Duration(milliseconds: 200));
      InsightsDurationState.setLast30DaysFlag(!InsightsDurationState.last30DaysFlag);
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
          SummaryInsights.setValues(userInsights);
          //UserTrendsMainPage.setValues(userInsights);
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