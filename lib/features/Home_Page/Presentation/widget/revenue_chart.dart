import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

BarChartData buildBarChartData(Map<String, double> data) {
  final labels = data.keys.toList();
  final values = data.values.toList();
  final double maxY =
      values.isNotEmpty ? (values.reduce((a, b) => a > b ? a : b) * 1.2) : 100;

  return BarChartData(
    alignment: BarChartAlignment.spaceBetween,
    maxY: maxY,
    barTouchData: BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => Colors.black87,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            '₹${rod.toY.toStringAsFixed(0)}',
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          );
        },
      ),
    ),
    titlesData: FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          interval: (maxY / 4).clamp(1, double.infinity),
          getTitlesWidget:
              (value, _) => Text(
                "₹${value.toInt()}",
                style: const TextStyle(fontSize: 9, color: Colors.white),
              ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (index, _) {
            final int i = index.toInt();
            if (i >= 0 && i < labels.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  labels[i],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    gridData: FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: (maxY / 4).clamp(1, double.infinity),
      getDrawingHorizontalLine:
          (value) => FlLine(color: Colors.grey.shade300, strokeWidth: 1),
    ),
    borderData: FlBorderData(show: false),
    barGroups: List.generate(values.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
            width: 12,
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [Colors.tealAccent.shade200, Colors.blueAccent.shade100],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ],
      );
    }),
  );
}
