import 'package:cosmic_jump/services/sound_service.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class CoinComponent extends PhysicalEntity with HasGameRef {
  CoinComponent(TiledObject tiledObject)
      : super(
          static: true,
          size: _size,
          position: tiledObject.position + _positionOffset,
        );

  static final Vector2 _size = Vector2.all(16);
  static final Vector2 _positionOffset = Vector2(0, -6);
  static final Vector2 _textureSize = Vector2.all(32);
  static const double _stepTime = 0.1;

  @override
  void onLoad() {
    super.onLoad();

    final image = game.images.fromCache('Items/Coin.png');
    final spriteAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: _stepTime,
        textureSize: _textureSize,
      ),
    );

    final animationPosition = position - center;
    add(
      SpriteAnimationComponent(
        animation: spriteAnimation,
        position: animationPosition,
      ),
    );
  }

  void collect() {
    removeFromParent();
    SoundService.instance.play('collect_item.wav');
  }
}

class CoinFactory implements TiledObjectHandler {
  const CoinFactory();

  @override
  void handleObject(TiledObject object, Layer layer, LeapMap map) {
    final coin = CoinComponent(object);
    map.add(coin);
  }
}
