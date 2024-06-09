import 'dart:ui';

import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/features/jetpack/jetpack_component.dart';
import 'package:flame/components.dart';

class JetpackEnergyHud extends PositionComponent with HasGameRef<CosmicJump> {
  JetpackEnergyHud(this.jetpack) : super(priority: 100);

  final JetpackComponent jetpack;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()..color = const Color(0xFF000000).withOpacity(0.35);

    final barSize = Vector2(200, 20);

    canvas.drawRect(
      Rect.fromLTWH(
        20,
        100,
        barSize.x,
        barSize.y,
      ),
      paint,
    );

    final jetpackRemainingTime = jetpack.remainingTime;
    const jetpackLimitInMs = JetpackComponent.duration;

    final remainingPercentage = jetpackRemainingTime / jetpackLimitInMs;

    final barWidth = barSize.x * remainingPercentage;

    final barPaint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        20,
        100,
        barWidth,
        barSize.y,
      ),
      barPaint,
    );
  }
}
