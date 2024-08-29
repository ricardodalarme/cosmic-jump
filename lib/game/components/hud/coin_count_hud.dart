import 'package:cosmic_jump/game/cosmic_jump.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class CoinCountHud extends PositionComponent with HasGameRef<CosmicJump> {
  CoinCountHud({super.position});

  late final TextComponent _coinCount;
  late final SpriteComponent _coinIcon;

  static final Vector2 _textureSize = Vector2.all(32);
  static final Vector2 _textureSrcPosition = Vector2(96, 0);
  static final Vector2 _offset = Vector2(-10, 0);

  @override
  void onLoad() {
    final image = game.images.fromCache('Items/Coin.png');
    final sprite = Sprite(
      image,
      srcPosition: _textureSrcPosition,
      srcSize: _textureSize,
    );
    _coinIcon = SpriteComponent(
      sprite: sprite,
      position: _offset,
    );

    _coinCount = TextComponent(
      position: Vector2(25, 3),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    addAll([_coinCount, _coinIcon]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _coinCount.text = game.player.coins.toString();
  }
}
