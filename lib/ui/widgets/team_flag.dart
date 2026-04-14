import 'package:flutter/material.dart';
import '../../data/models/team_model.dart';
import '../../core/constants.dart';

class TeamFlag extends StatelessWidget {
  final List<String> colors;
  final TeamPattern pattern;
  final double width;
  final double height;

  const TeamFlag({
    super.key,
    required this.colors,
    required this.pattern,
    this.width = 48,
    this.height = 36,
  });

  @override
  Widget build(BuildContext context) {
    if (colors.length < 2) return const SizedBox.shrink();

    final color1 = TeamConstants.hexToColor(colors[0]);
    final color2 = TeamConstants.hexToColor(colors[1]);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: FlagPainter(
          color1: color1,
          color2: color2,
          pattern: pattern,
        ),
      ),
    );
  }
}

class FlagPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final TeamPattern pattern;

  FlagPainter({
    required this.color1,
    required this.color2,
    required this.pattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = color1;
    final paint2 = Paint()..color = color2;

    switch (pattern) {
      case TeamPattern.vertical:
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width / 2, size.height), paint1);
        canvas.drawRect(Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height), paint2);
        break;
      case TeamPattern.horizontal:
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height / 2), paint1);
        canvas.drawRect(Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2), paint2);
        break;
      case TeamPattern.diagonal:
        final path1 = Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(0, size.height)
          ..close();
        final path2 = Path()
          ..moveTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path1, paint1);
        canvas.drawPath(path2, paint2);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
