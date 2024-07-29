import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import '../../services/summary_insights_service.dart';


class HeatmapsMainPage extends StatefulWidget {
  const HeatmapsMainPage({super.key});

  @override
  State<HeatmapsMainPage> createState() => _HeatmapsMainPageState();
}

class _HeatmapsMainPageState extends State<HeatmapsMainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var summaryInsights = SummaryInsightsService().getUserSummaryInsights();
    var heatmapData = summaryInsights['heatmap'];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Activity Heatmap',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Flexible(
              fit: FlexFit.loose,
              child: _getPerformanceHeatMap(heatmapData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPerformanceHeatMap(var heatmapData) {
    DateTime now = DateTime.now();
    DateTime sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);

    Map<DateTime, int> datasets = {};
    heatmapData.forEach((key, value) {
      datasets[DateTime.parse(key)] = value;
    });

    return HeatMap(
      datasets: datasets,
      colorMode: ColorMode.color,
      showText: false,
      scrollable: true,
      colorsets: _getColorSets(),
      startDate: sixMonthsAgo,
      onClick: (date) {
        int? count = datasets[date];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Date: ${date.toLocal().toIso8601String().split('T').first}\nCount: $count'),
          ),
        );
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