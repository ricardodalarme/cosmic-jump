import 'package:cosmic_jump/models/fog_model.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class FogComponent extends PositionComponent {
  late Sprite fogSprite;
  final Paint _paint = Paint()..blendMode = BlendMode.srcOver;

  final FogModel fog;

  FogComponent(this.fog);

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('Fogs/Fog.png');

    fogSprite = Sprite(image);
  }

  @override
  void update(double dt) {
    position.add(Vector2(fog.speed * dt, 0));
    if (position.x > size.x) {
      position.x = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    _paint.colorFilter = ColorFilter.mode(fog.color, BlendMode.modulate);
    _paint.color = Colors.white.withAlpha(100);

    for (double x = position.x - size.x;
        x < size.x * 20;
        x += fogSprite.srcSize.x) {
      for (double y = 0; y < size.y; y += fogSprite.srcSize.y) {
        fogSprite.render(
          canvas,
          position: Vector2(x, y),
          size: Vector2(fogSprite.srcSize.x, fogSprite.srcSize.y),
          overridePaint: _paint,
        );
      }
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }
}
