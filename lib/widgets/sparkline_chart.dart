import 'package:flutter/material.dart';

class SparklineChart extends StatelessWidget {
  final List<double> values;
  final Color lineColor;
  final Color fillColor;
  final double height;

  const SparklineChart({
    super.key,
    required this.values,
    required this.lineColor,
    required this.fillColor,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(values, lineColor, fillColor),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color lineColor;
  final Color fillColor;

  _SparklinePainter(this.values, this.lineColor, this.fillColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final double minY = values.reduce((a, b) => a < b ? a : b);
    final double maxY = values.reduce((a, b) => a > b ? a : b);
    final double range = (maxY - minY).clamp(1e-6, double.infinity);

    final Path path = Path();
    final Path fillPath = Path();

    for (int i = 0; i < values.length; i++) {
      final double t = i / (values.length - 1);
      final double x = t * size.width;
      final double normalized = (values[i] - minY) / range;
      final double y = size.height - normalized * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}
