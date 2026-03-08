import 'package:flutter/material.dart';
import 'dart:math';
import '../styles/app_styles.dart';

class FatigueChart extends StatefulWidget {
  final List<double> data;
  final double height;

  const FatigueChart({
    super.key,
    required this.data,
    this.height = 200,
  });

  @override
  State<FatigueChart> createState() => _FatigueChartState();
}

class _FatigueChartState extends State<FatigueChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: FatigueChartPainter(
              data: widget.data,
              progress: _animation.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class FatigueChartPainter extends CustomPainter {
  final List<double> data;
  final double progress;

  FatigueChartPainter({required this.data, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = kPrimaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          kPrimaryColor.withOpacity(0.3),
          kPrimaryColor.withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Márgenes
    const paddingLeft = 40.0;
    const paddingRight = 20.0;
    const paddingTop = 20.0;
    const paddingBottom = 30.0;

    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;

    // Encontrar valores máximo y mínimo
    final maxValue = data.reduce(max);
    final minValue = data.reduce(min);
    final range = maxValue - minValue;

    // Dibujar líneas de grid
    final gridPaint = Paint()
      ..color = kDividerColor
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = paddingTop + (chartHeight * i / 4);
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );

      // Etiquetas del eje Y
      final value = maxValue - (range * i / 4);
      final textPainter = TextPainter(
        text: TextSpan(
          text: value.toStringAsFixed(0),
          style: kCaptionStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(5, y - textPainter.height / 2),
      );
    }

    // Calcular puntos del gráfico
    final points = <Offset>[];
    final displayDataLength = (data.length * progress).ceil();

    for (int i = 0; i < displayDataLength; i++) {
      final x = paddingLeft + (chartWidth * i / (data.length - 1));
      final normalizedValue = range > 0 ? (data[i] - minValue) / range : 0.5;
      final y = paddingTop + chartHeight - (normalizedValue * chartHeight);
      points.add(Offset(x, y));
    }

    // Dibujar área bajo la curva
    if (points.length > 1) {
      final fillPath = Path();
      fillPath.moveTo(points.first.dx, size.height - paddingBottom);
      fillPath.lineTo(points.first.dx, points.first.dy);

      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final controlPoint = Offset((p0.dx + p1.dx) / 2, p0.dy);
        fillPath.quadraticBezierTo(controlPoint.dx, controlPoint.dy, p1.dx, p1.dy);
      }

      fillPath.lineTo(points.last.dx, size.height - paddingBottom);
      fillPath.close();
      canvas.drawPath(fillPath, fillPaint);
    }

    // Dibujar línea del gráfico
    if (points.length > 1) {
      final linePath = Path();
      linePath.moveTo(points.first.dx, points.first.dy);

      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final controlPoint = Offset((p0.dx + p1.dx) / 2, p0.dy);
        linePath.quadraticBezierTo(controlPoint.dx, controlPoint.dy, p1.dx, p1.dy);
      }

      canvas.drawPath(linePath, paint);
    }

    // Dibujar puntos
    final pointPaint = Paint()
      ..color = kPrimaryColor
      ..style = PaintingStyle.fill;

    for (var point in points) {
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(point, 3, Paint()..color = Colors.white);
    }

    // Etiquetas del eje X
    final labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    for (int i = 0; i < labels.length && i < data.length; i++) {
      final x = paddingLeft + (chartWidth * i / (data.length - 1));
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: kCaptionStyle,
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - paddingBottom + 10),
      );
    }
  }

  @override
  bool shouldRepaint(FatigueChartPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.data != data;
  }
}

