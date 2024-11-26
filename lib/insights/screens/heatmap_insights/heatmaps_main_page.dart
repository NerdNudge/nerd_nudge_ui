import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:nerd_nudge/user_profile/dto/user_profile_entity.dart';
import 'package:nerd_nudge/utilities/logger.dart';
import 'package:nerd_nudge/utilities/styles.dart';

class HeatmapsMainPage extends StatefulWidget {
  const HeatmapsMainPage({super.key, required this.userInsights});

  final Map<String, dynamic> userInsights;

  @override
  State<HeatmapsMainPage> createState() => _HeatmapsMainPageState();
}

class _HeatmapsMainPageState extends State<HeatmapsMainPage> {
  @override
  void initState() {
    super.initState();
    UserProfileEntity userProfileEntity = UserProfileEntity();
    NerdLogger.logger.d('User fullName: ${userProfileEntity.getUserFullName()}, User Email: ${userProfileEntity.getUserEmail()}');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Activity Heatmap',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              fit: FlexFit.loose,
              child: _getPerformanceHeatMap(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPerformanceHeatMap() {
    var heatmapData = widget.userInsights['heatMap'];

    DateTime now = DateTime.now();
    DateTime sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);

    Map<DateTime, List<int>> datasets = {};
    heatmapData.forEach((key, value) {
      datasets[DateTime.parse(key)] =
          List<int>.from(value);
    });

    return HeatMap(
      datasets:
          datasets.map((key, value) => MapEntry(key, value[0] + value[1])),
      colorMode: ColorMode.color,
      showText: false,
      scrollable: true,
      colorsets: _getColorSets(),
      startDate: sixMonthsAgo,
      onClick: (date) {
        List<int>? values = datasets[date];
        if (values != null) {
          Styles.showGlobalSnackbarMessage(
            'Date: ${date.toLocal().toIso8601String().split('T').first}\nQuizflex Count: ${values[0]}\nShots Count: ${values[1]}',
          );
        }
      },
    );
  }

  _getColorSets() {
    return {
      1: Colors.green[100]!,
      3: Colors.green[200]!,
      5: Colors.green[300]!,
      8: Colors.green[400]!,
      12: Colors.green[500]!,
      16: Colors.green[600]!,
      20: Colors.green[700]!,
      25: Colors.green[800]!,
      30: Colors.green[900]!,
    };
  }
}
