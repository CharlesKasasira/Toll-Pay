import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tollpay/utils/price_point.dart';

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key, required this.points}) : super(key: key);

  final List<PricePoint> points;

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState(points: this.points);
}

class _BarChartWidgetState extends State<BarChartWidget> {
  final List<PricePoint> points;

  _BarChartWidgetState({required this.points});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
            barGroups: _chartGroups(),
            borderData: FlBorderData(
                border: const Border(bottom: BorderSide(), left: BorderSide())),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: _bottomTitles),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 2,
                  ),
                ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
      ),
    );
  }

  List<BarChartGroupData> _chartGroups() {
    return points.map((point) =>
      BarChartGroupData(
        x: point.x.toInt(),
        barRods: [
          BarChartRodData(
            borderRadius: BorderRadius.circular(0),
            width: 18,
            color: const Color(0xff1a1a1a),
            toY: point.y,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              color: const Color.fromARGB(255, 237, 237, 237),
              toY: 15
              )
          )
          
        ]
      )

    ).toList();
  }

  SideTitles get _bottomTitles => SideTitles(
    showTitles: true,
    getTitlesWidget: (value, meta) {
      String text = '';
      switch (value.toInt()) {
        case 0:
          text = 'M';
          break;
        case 1:
          text = 'T';
          break;
        case 2:
          text = 'W';
          break;
        case 3:
          text = 'T';
          break;
        case 4:
          text = 'F';
          break;
        case 5:
          text = 'S';
          break;
        case 6:
          text = 'S';
          break;
      }

      return Text(text);
    },
  );
}

