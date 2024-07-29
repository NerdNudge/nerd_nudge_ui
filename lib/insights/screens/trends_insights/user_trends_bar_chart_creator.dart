import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserTrendsBarChartCreator extends StatefulWidget {
  final Map<String, double> trendsData;
  final bool isScore; // Add a flag to determine if the data is for score or rank

  UserTrendsBarChartCreator({required this.trendsData, required this.isScore});

  @override
  _UserTrendsBarChartCreatorState createState() => _UserTrendsBarChartCreatorState();
}

class _UserTrendsBarChartCreatorState extends State<UserTrendsBarChartCreator> {
  int touchedIndex = -1;
  double maxY = 60; // Default maxY value

  @override
  void initState() {
    super.initState();
    maxY = widget.isScore ? 60 : _calculateMaxY(widget.trendsData); // Update maxY based on the data
  }

  double _calculateMaxY(Map<String, double> data) {
    double maxValue = data.values.reduce((a, b) => a > b ? a : b);
    return maxValue / (widget.isScore ? 1 : 10); // Scale down rank values
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: barGroups,
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    touchTooltipData: BarTouchTooltipData(
      getTooltipItem: (group, groupIndex, rod, rodIndex) {
        String date = widget.trendsData.keys.elementAt(group.x);
        double actualValue = widget.trendsData[date]!;
        return BarTooltipItem(
          '$date\n$actualValue',
          const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
    touchCallback: (FlTouchEvent event, barTouchResponse) {
      if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
        setState(() {
          touchedIndex = -1;
        });
        return;
      }
      setState(() {
        touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
      });
    },
  );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 10, // Reduce font size to help prevent overlap
    );

    String text;
    try {
      // Parse the date and format it as "d MMM"
      DateTime date = DateTime.parse(widget.trendsData.keys.elementAt(value.toInt()));
      text = DateFormat('d MMM').format(date);
    } catch (e) {
      text = '';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 22, // Add more space between the labels and the bars
      child: Transform.rotate(
        angle: -45 * 3.14159 / 180, // Rotate labels by 45 degrees
        child: Text(text, style: style),
      ),
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    int displayValue = widget.isScore ? value.toInt() : (value * 10).toInt();
    return Text(displayValue.toString(), style: style, textAlign: TextAlign.center);
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 50, // Increase reserved size to accommodate rotated labels
        getTitlesWidget: getTitles,
        interval: 1, // Show every label
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40, // Reserve space for the left titles
        getTitlesWidget: getLeftTitles,
        interval: widget.isScore ? 10 : maxY / 5, // Adjust interval based on data type
      ),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      Colors.blue,
      Colors.cyan,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups {
    List<BarChartGroupData> barChartGroups = [];
    int index = 0;

    widget.trendsData.forEach((date, score) {
      double normalizedScore = widget.isScore ? score : score / 10; // Normalize rank values
      barChartGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: normalizedScore,
              gradient: _barsGradient,
              width: 10, // Reduce bar width to preferred size
            )
          ],
          showingTooltipIndicators: touchedIndex == index ? [0] : [],
        ),
      );
      index++;
    });

    return barChartGroups;
  }
}