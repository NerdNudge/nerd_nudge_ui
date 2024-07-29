import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../utilities/colors.dart';

class PeerComparisonInsights extends StatelessWidget {
  const PeerComparisonInsights({super.key, required this.closeButton, required this.peerComparisonData, required this.topic});

  final Function closeButton;
  final Map<String, dynamic> peerComparisonData;
  final String topic;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Peer Comparison - Accuracy Insights',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Topic: $topic',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            _buildComparisonChart(),
            SizedBox(height: 20),
            _buildStatistics(),
            SizedBox(height: 20),
            Container(
              width: 40.0, // Adjust the width and height for the desired size
              height: 40.0,
              decoration: BoxDecoration(
                color: CustomColors.mainThemeColor, // Background color of the button
                borderRadius: BorderRadius.circular(8.0), // Adjust the border radius for a square shape
              ),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => closeButton(),
                color: Colors.white, // Foreground color of the X icon
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonChart() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            barGroups: _getBarGroups(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    switch (value.toInt()) {
                      case 0:
                        return Text('Easy',
                            style: TextStyle(
                                color: CustomColors.purpleButtonColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14));
                      case 1:
                        return Text('Medium',
                            style: TextStyle(
                                color: CustomColors.purpleButtonColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14));
                      case 2:
                        return Text('Hard',
                            style: TextStyle(
                                color: CustomColors.purpleButtonColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14));
                      default:
                        return Text('');
                    }
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(enabled: true),
            gridData: FlGridData(show: false),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    List<BarChartGroupData> barGroups = [];
    peerComparisonData.forEach((key, values) {
      if (key != 'userAvg' && key != 'peersAvg' && key != 'topAvg') {
        int index = key == 'Easy' ? 0 : key == 'Medium' ? 1 : 2;
        barGroups.add(_getBar(index, values[0].toDouble(), values[1].toDouble(), values[2].toDouble()));
      }
    });
    return barGroups;
  }

  BarChartGroupData _getBar(int x, double userValue, double peerValue, double topPeerValue) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: userValue,
          color: Colors.green,
          width: 10,
        ),
        BarChartRodData(
          toY: peerValue,
          color: Colors.orange,
          width: 10,
        ),
        BarChartRodData(
          toY: topPeerValue,
          color: Colors.blue,
          width: 10,
        ),
      ],
      barsSpace: 7, // Adjust this value to add more space between bars
    );
  }

  Widget _buildStatistics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatisticCard('You', peerComparisonData['userAvg'], Icons.person, Colors.green),
        _buildStatisticCard('Peers', peerComparisonData['peersAvg'], Icons.group, Colors.orange),
        _buildStatisticCard('Top', peerComparisonData['topAvg'], Icons.star, Colors.blue),
      ],
    );
  }

  Widget _buildStatisticCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}