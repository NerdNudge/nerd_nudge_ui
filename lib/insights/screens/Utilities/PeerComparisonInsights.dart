import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nerd_nudge/utilities/styles.dart';
import '../../../utilities/colors.dart';

class PeerComparisonInsights extends StatelessWidget {
  const PeerComparisonInsights({
    super.key,
    required this.closeButton,
    required this.peerComparisonData,
    required this.topic,
  });

  final Function closeButton;
  final Map<String, dynamic> peerComparisonData;
  final String topic;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Peer Comparison',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: CustomColors.mainThemeColor,
                  ),
                ),
                Styles.getSizedHeightBox(8),
                Text(
                  'Topic: $topic',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                Styles.getSizedHeightBox(20),
                _buildComparisonChart(),
                Styles.getSizedHeightBox(20),
                _buildStatistics(),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: CustomColors.mainThemeColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => closeButton(),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonChart() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
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
                        return Text(
                          'Easy',
                          style: TextStyle(
                            color: CustomColors.purpleButtonColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      case 1:
                        return Text(
                          'Medium',
                          style: TextStyle(
                            color: CustomColors.purpleButtonColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      case 2:
                        return Text(
                          'Hard',
                          style: TextStyle(
                            color: CustomColors.purpleButtonColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
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
      if (key != 'userAverage' && key != 'peersAverage') {
        int index = key == 'easy' ? 0 : key == 'medium' ? 1 : 2;
        barGroups.add(_getBar(index, values[0].toDouble(), values[1].toDouble()));
      }
    });
    return barGroups;
  }

  BarChartGroupData _getBar(int x, double userValue, double peerValue) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: userValue,
          color: Colors.green,
          width: 10,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: peerValue,
          color: Colors.orange,
          width: 10,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
      barsSpace: 12,
    );
  }

  Widget _buildStatistics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatisticCard(
          'You',
          peerComparisonData['userAverage'].toString(),
          Icons.person,
          Colors.green,
        ),
        Styles.getSizedWidthBox(20),
        _buildStatisticCard(
          'Peers',
          peerComparisonData['peersAverage'].toString(),
          Icons.group,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatisticCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 120,  // Adjust this width as needed to match the bar chart's width
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 36),
              //SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              //SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}