import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LightSource {
  Vector2 position;
  final double radius;

  LightSource({
    required this.position,
    required this.radius,
  });
}

class LightAndDarknessComponent extends PositionComponent {
  final List<LightSource> lightSources;
  final Paint _darknessPaint;
  final Paint _lightPaint;
  PositionComponent? player;

  LightAndDarknessComponent({
    required Vector2 size,
    required this.lightSources,
    double visibility = 1,
    this.player,
  })  : _darknessPaint = Paint()
          ..color = const Color(0xFF000000).withOpacity(1 - visibility)
          ..blendMode = BlendMode.srcOver,
        _lightPaint = Paint()
          ..color = const Color(0xFFFFFFFF)
          ..blendMode = BlendMode.clear,
        super(
          size: size,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Save the current canvas state
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.x, size.y), Paint());

    // Draw the darkness overlay
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      _darknessPaint,
    );

    // Draw each light source
    for (final lightSource in lightSources) {
      canvas.drawCircle(
        Offset(lightSource.position.x, lightSource.position.y),
        lightSource.radius,
        _lightPaint,
      );
    }

    // Restore the canvas state
    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the position of the light source to follow the player
    if (player != null) {
      lightSources[0].position = player!.center;
    }
  }
}
