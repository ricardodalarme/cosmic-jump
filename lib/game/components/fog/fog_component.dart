import 'package:cosmic_jump/data/models/fog_model.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FogComponent extends PositionComponent with HasGameRef {
  FogComponent(this.fog);

  final FogModel fog;

  late final Sprite fogSprite;
  final Paint _paint = Paint()..blendMode = BlendMode.srcOver;
  final List<Vector2> _fogPositions = [];

  int get _fogCountX => (size.x / fogSprite.srcSize.x).ceil() + 1;
  int get _fogCountY => (size.y / fogSprite.srcSize.y).ceil() + 1;

  @override
  void onLoad() {
    _loadFogSprite();
    _initializeFogPositions();
  }

  @override
  void update(double dt) {
    _updateFogPositions(dt);
  }

  @override
  void render(Canvas canvas) {
    _applyFogColorFilter();
    _renderFog(canvas);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    _initializeFogPositions();
  }

  void _loadFogSprite() {
    final image = game.images.fromCache('Fogs/Fog.png');
    fogSprite = Sprite(image);
  }

  void _initializeFogPositions() {
    _fogPositions.clear();
    for (int x = 0; x < _fogCountX; x++) {
      for (int y = 0; y < _fogCountY; y++) {
        _fogPositions
            .add(Vector2(x * fogSprite.srcSize.x, y * fogSprite.srcSize.y));
      }
    }
  }

  void _updateFogPositions(double dt) {
    for (final position in _fogPositions) {
      position.x += fog.speed * dt;

      if (position.x >= size.x) {
        position.x -= fogSprite.srcSize.x * _fogCountX;
      }
    }
  }

  void _applyFogColorFilter() {
    _paint.colorFilter = ColorFilter.mode(fog.color, BlendMode.modulate);
    _paint.color = Colors.white.withAlpha(100);
  }

  void _renderFog(Canvas canvas) {
    for (final position in _fogPositions) {
      fogSprite.render(
        canvas,
        position: position,
        size: Vector2(fogSprite.srcSize.x, fogSprite.srcSize.y),
        overridePaint: _paint,
      );
    }
  }
}
