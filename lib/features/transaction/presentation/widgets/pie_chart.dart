import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AdvancedPieChart extends StatefulWidget {
  const AdvancedPieChart({super.key});

  @override
  State<AdvancedPieChart> createState() => _AdvancedPieChartState();
}

class _AdvancedPieChartState extends State<AdvancedPieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 50,
          sectionsSpace: 2,
          borderData: FlBorderData(show: false),
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              setState(() {
                if (!event.isInterestedForInteractions || response == null || response.touchedSection == null) {
                  touchedIndex = null;
                  return;
                }
                touchedIndex = response.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          sections: _generateSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    final data = [
      {'value': 40.0, 'color': Colors.blue, 'label': 'Blue'},
      {'value': 30.0, 'color': Colors.green, 'label': 'Green'},
      {'value': 20.0, 'color': Colors.orange, 'label': 'Orange'},
      {'value': 10.0, 'color': Colors.red, 'label': 'Red'},
    ];

    return List.generate(data.length, (index) {
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 22 : 16;
      final double radius = isTouched ? 70 : 60;

      return PieChartSectionData(
        color: data[index]['color'] as Color,
        value: data[index]['value'] as double,
        title: '${data[index]['value']}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}
