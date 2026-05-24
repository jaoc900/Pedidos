import 'package:pedidos/enums/chart_type_model.dart';
import 'package:flutter/material.dart';

class DonutChartPainter extends CustomPainter {
  final List<double> percentages;
  final List<Color> colors;
  final ChartType chartType;
  final double strokeWidth;

  DonutChartPainter({
    required this.percentages,
    required this.colors,
    this.chartType = ChartType.donut,
    this.strokeWidth = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = chartType == ChartType.pie ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    double startAngle = -90;

    for (int i = 0; i < percentages.length; i++) {
      final sweepAngle = (percentages[i] / 100) * 360;
      paint.color = colors[i];
      final useCenter = chartType == ChartType.pie;

      canvas.drawArc(
        rect,
        startAngle * (3.14159 / 180),
        sweepAngle * (3.14159 / 180),
        useCenter,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  // Método de fábrica para segmento único (reemplaza DonutSegmentPainter)
  factory DonutChartPainter.single({
    required double percentage,
    required Color color,
    double strokeWidth = 12,
  }) {
    return DonutChartPainter(
      percentages: [percentage, 100 - percentage],
      colors: [color, Colors.transparent],
      chartType: ChartType.donut,
      strokeWidth: strokeWidth,
    );
  }
}
