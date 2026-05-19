import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ArtStudioScreen extends StatefulWidget {
  const ArtStudioScreen({super.key});

  @override
  State<ArtStudioScreen> createState() => _ArtStudioScreenState();
}

class _ArtStudioScreenState extends State<ArtStudioScreen> {
  List<DrawingPoint?> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;

  final List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '🎨 Art Studio',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        color: AppTheme.bgDark,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => setState(() => points.clear()),
                  ),
                ],
              ),
            ),
            
            // Canvas
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject() as RenderBox;
                        points.add(DrawingPoint(
                          point: details.localPosition,
                          paint: Paint()
                            ..strokeCap = StrokeCap.round
                            ..isAntiAlias = true
                            ..color = selectedColor
                            ..strokeWidth = strokeWidth,
                        ));
                      });
                    },
                    onPanStart: (details) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject() as RenderBox;
                        points.add(DrawingPoint(
                          point: details.localPosition,
                          paint: Paint()
                            ..strokeCap = StrokeCap.round
                            ..isAntiAlias = true
                            ..color = selectedColor
                            ..strokeWidth = strokeWidth,
                        ));
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        points.add(null);
                      });
                    },
                    child: CustomPaint(
                      painter: _DrawingPainter(points: points),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
            ),
            
            // Toolbar
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: colors.map((color) {
                        return GestureDetector(
                          onTap: () => setState(() => selectedColor = color),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedColor == color ? Colors.black : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: strokeWidth,
                    min: 1.0,
                    max: 20.0,
                    activeColor: selectedColor,
                    onChanged: (val) {
                      setState(() {
                        strokeWidth = val;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawingPoint {
  Offset point;
  Paint paint;
  DrawingPoint({required this.point, required this.paint});
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;
  _DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!.point, points[i + 1]!.point, points[i]!.paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]!.point], points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
