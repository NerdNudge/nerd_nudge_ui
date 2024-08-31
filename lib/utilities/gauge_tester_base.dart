import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'percentage_gauge.dart';

class GaugeTesterBase extends StatelessWidget {
  const GaugeTesterBase({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Percentage Gauge'),
        ),
        body: Center(
          child: PercentageGauge(percentage: 65),
        ),
      ),
    );
  }
}
