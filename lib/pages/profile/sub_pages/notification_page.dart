import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularSegmentedProgress extends StatelessWidget {
  final int totalNumber;
  final List<SegmentData> segments;
  final double size;
  final double strokeWidth;

  const CircularSegmentedProgress({
    Key? key,
    required this.totalNumber,
    required this.segments,
    this.size = 200.0,
    this.strokeWidth = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background circle
          CustomPaint(
            size: Size(size, size),
            painter: BackgroundCirclePainter(strokeWidth: strokeWidth),
          ),
          // Segments
          CustomPaint(
            size: Size(size, size),
            painter: SegmentedCirclePainter(
              segments: segments,
              strokeWidth: strokeWidth,
            ),
          ),
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total number',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '$totalNumber',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SegmentData {
  final double percentage;
  final Color color;

  SegmentData({required this.percentage, required this.color});
}

class BackgroundCirclePainter extends CustomPainter {
  final double strokeWidth;

  BackgroundCirclePainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SegmentedCirclePainter extends CustomPainter {
  final List<SegmentData> segments;
  final double strokeWidth;

  SegmentedCirclePainter({required this.segments, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2; // Start from top

    for (final segment in segments) {
      final sweepAngle = (segment.percentage / 100) * 2 * math.pi;

      final paint = Paint()
        ..color = segment.color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Example usage widget
class CircularProgressExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Circular Progress UI'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: CircularSegmentedProgress(
          totalNumber: 356,
          size: 220,
          strokeWidth: 12,
          segments: [
            SegmentData(percentage: 35, color: Color(0xFF4A90E2)), // Blue
            SegmentData(percentage: 15, color: Color(0xFF7B68EE)), // Purple
            SegmentData(percentage: 20, color: Color(0xFF50E3C2)), // Teal
            SegmentData(percentage: 15, color: Color(0xFFFFB84D)), // Orange
            // Remaining 15% will be the background gray
          ],
        ),
      ),
    );
  }
}