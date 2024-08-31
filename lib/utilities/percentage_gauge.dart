import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PercentageGauge extends StatelessWidget {
  final double percentage;
  final double height;
  final double width;

  PercentageGauge({
    required this.percentage,
    this.height = 80, // Height for the gauge in the topic list
    this.width = 100,  // Width for the gauge in the topic list
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            startAngle: 180,
            endAngle: 360,
            radiusFactor: 0.8,
            axisLineStyle: AxisLineStyle(
              thickness: 0.1,
              cornerStyle: CornerStyle.bothCurve,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 40,
                color: Colors.red,
                startWidth: 0.1,
                endWidth: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
              ),
              GaugeRange(
                startValue: 40,
                endValue: 70,
                color: Colors.orange,
                startWidth: 0.1,
                endWidth: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
              ),
              GaugeRange(
                startValue: 70,
                endValue: 100,
                color: Colors.green,
                startWidth: 0.1,
                endWidth: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: percentage,
                needleColor: Colors.black87,
                needleStartWidth: 0.5,
                needleEndWidth: 2.5,
                needleLength: 0.7,
                knobStyle: KnobStyle(
                  color: Colors.black87,
                  borderColor: Colors.black,
                  borderWidth: 0.02,
                  knobRadius: 0.06,
                ),
                tailStyle: TailStyle(
                  length: 0.1,
                  width: 2,
                  color: Colors.black87,
                ),
                enableAnimation: true,
                animationDuration: 1000,
                animationType: AnimationType.easeOutBack,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                angle: 90,
                positionFactor: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}