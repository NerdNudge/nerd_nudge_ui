import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class UserTrendsBarChartCreator extends StatefulWidget {
  final Map<String, dynamic> trendsData;
  final bool isScore;

  UserTrendsBarChartCreator({required this.trendsData, required this.isScore});

  @override
  _UserTrendsBarChartCreatorState createState() => _UserTrendsBarChartCreatorState();
}

class _UserTrendsBarChartCreatorState extends State<UserTrendsBarChartCreator> {
  int touchedIndex = -1;
  late double maxY;

  @override
  void initState() {
    super.initState();
    _updateMaxYAndRebuild();
  }

  @override
  void didUpdateWidget(covariant UserTrendsBarChartCreator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trendsData != widget.trendsData || oldWidget.isScore != widget.isScore) {
      _updateMaxYAndRebuild();
    }
  }

  void _updateMaxYAndRebuild() {
    setState(() {
      maxY = _calculateMaxY(widget.trendsData);
    });
  }

  double _calculateMaxY(Map<String, dynamic> data) {
    double maxValue = data.values.map((value) {
      if (value is List && value.length > 1) {
        return value[widget.isScore ? 0 : 1] as double;
      } else if (value is double) {
        return value;
      } else {
        return 0.0;
      }
    }).reduce((a, b) => a > b ? a : b);

    return _roundUpMaxValue(maxValue); // Adjusted max value
  }

  double _roundUpMaxValue(double maxValue) {
    if (maxValue == 0) return 1.0;

    final double magnitude = pow(10, maxValue.floor().toString().length - 1).toDouble();
    return (maxValue / magnitude).ceil() * magnitude;
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
      fontSize: 10,
    );

    String text;
    try {
      DateTime date = DateTime.parse(widget.trendsData.keys.elementAt(value.toInt()));
      text = DateFormat('d MMM').format(date);
    } catch (e) {
      text = '';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 22,
      child: Transform.rotate(
        angle: -45 * 3.14159 / 180,
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

    double interval = maxY / 8;

    if (value % interval != 0) {
      return Container();
    }

    String displayValue;
    if (value >= 1000) {
      displayValue = '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      displayValue = value.toInt().toString();
    }

    return Text(displayValue, style: style, textAlign: TextAlign.center);
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 50,
        getTitlesWidget: getTitles,
        interval: 1,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: getLeftTitles,
        interval: maxY / 8,
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
      double normalizedScore = score / maxY * maxY; // Use maxY to normalize the score
      barChartGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: normalizedScore,
              gradient: _barsGradient,
              width: 10,
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