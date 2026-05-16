import 'package:flutter/material.dart';
import '../../data/models/team_model.dart';
import '../../core/constants.dart';

/// A widget that displays a representative flag for a team.
/// Supports 2 or 3 colors and different geometric patterns.
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
    if (colors.isEmpty) return const SizedBox.shrink();

    // Map hex strings to Flutter Color objects
    final List<Color> paintColors = colors.map((c) => TeamConstants.hexToColor(c)).toList();

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
      ), // end of BoxDecoration (Flag container styling)
      clipBehavior: Clip.antiAlias,
      child: CustomPaint(
        painter: FlagPainter(
          colors: paintColors,
          pattern: pattern,
        ),
      ), // end of CustomPaint (Flag drawing)
    ); // end of Container (Flag root)
  }
}

/// Custom painter to draw team flags with multiple colors and patterns.
class FlagPainter extends CustomPainter {
  final List<Color> colors;
  final TeamPattern pattern;

  FlagPainter({
    required this.colors,
    required this.pattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty) return;

    if (colors.length == 1) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = colors[0]);
      return;
    }

    final int count = colors.length;

    switch (pattern) {
      case TeamPattern.vertical:
        final double stripeWidth = size.width / count;
        for (int i = 0; i < count; i++) {
          canvas.drawRect(
            Rect.fromLTWH(i * stripeWidth, 0, stripeWidth, size.height),
            Paint()..color = colors[i],
          );
        }
        break;

      case TeamPattern.horizontal:
        final double stripeHeight = size.height / count;
        for (int i = 0; i < count; i++) {
          canvas.drawRect(
            Rect.fromLTWH(0, i * stripeHeight, size.width, stripeHeight),
            Paint()..color = colors[i],
          );
        }
        break;

      case TeamPattern.diagonal:
        if (count == 2) {
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
          canvas.drawPath(path1, Paint()..color = colors[0]);
          canvas.drawPath(path2, Paint()..color = colors[1]);
        } else {
          // For 3 or more colors in diagonal, we fallback to vertical for simplicity 
          // or we can implement a more complex path logic.
          // Let's do a simple 3-way split for diagonal.
          final double segment = (size.width + size.height) / count;
          
          for (int i = 0; i < count; i++) {
            
            final path = Path();
            if (i == 0) {
              path.moveTo(0, 0);
              path.lineTo(segment, 0);
              path.lineTo(0, segment);
            } else if (i == count - 1) {
              path.moveTo(size.width, size.height);
              path.lineTo(size.width - segment, size.height);
              path.lineTo(size.width, size.height - segment);
            } else {
              // Middle stripe
              path.moveTo(segment, 0);
              path.lineTo(size.width, size.height - segment);
              path.lineTo(size.width, size.height);
              path.lineTo(0, segment);
            }
            path.close();
            // This logic is flawed for generic rectangles, sticking to vertical/horizontal for 3 colors 
            // is safer or we use simple vertical stripes if count > 2 for diagonal.
            
            // Reverting to simple vertical for 3+ colors on diagonal for now to avoid weird artifacts
            final double stripeWidth = size.width / count;
            canvas.drawRect(
              Rect.fromLTWH(i * stripeWidth, 0, stripeWidth, size.height),
              Paint()..color = colors[i],
            );
          }
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
