import 'package:cosmic_jump/models/fog_model.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class FogComponent extends PositionComponent {
  late Sprite fogSprite;
  final Paint _paint = Paint()..blendMode = BlendMode.srcOver;

  final FogModel fog;
  final List<Vector2> _fogPositions = [];

  FogComponent(this.fog);

  int get fogCountX => (size.x / fogSprite.srcSize.x).ceil() + 1;
  int get fogCountY => (size.y / fogSprite.srcSize.y).ceil() + 1;

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('Fogs/Fog.png');
    fogSprite = Sprite(image);

    _updatePositions();
  }

  @override
  void update(double dt) {
    for (final position in _fogPositions) {
      position.x += fog.speed * dt;

      if (position.x >= size.x) {
        position.x -= fogSprite.srcSize.x * fogCountX;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    _paint.colorFilter = ColorFilter.mode(fog.color, BlendMode.modulate);
    _paint.color = Colors.white.withAlpha(100);

    for (final position in _fogPositions) {
      fogSprite.render(
        canvas,
        position: position,
        size: Vector2(fogSprite.srcSize.x, fogSprite.srcSize.y),
        overridePaint: _paint,
      );
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    _updatePositions();
  }

  void _updatePositions() {
    _fogPositions.clear();

    for (int x = 0; x < fogCountX; x++) {
      for (int y = 0; y < fogCountY; y++) {
        _fogPositions
            .add(Vector2(x * fogSprite.srcSize.x, y * fogSprite.srcSize.y));
      }
    }
  }
}
