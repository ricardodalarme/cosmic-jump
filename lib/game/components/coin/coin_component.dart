import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class CoinComponent extends PhysicalEntity with HasGameRef {
  CoinComponent(TiledObject tiledObject) : super(static: true) {
    size = Vector2.all(18);
    priority = 2;

    // in Tiled we center position the Coins
    // so, we need to offset here for top-left position.
    position = Vector2(tiledObject.x - width / 2, tiledObject.y - height / 2);
  }

  @override
  void onLoad() {
    super.onLoad();

    final tileset = game.images.fromCache('Items/Coin.png');
    final spriteAnimation = SpriteAnimation.fromFrameData(
      tileset,
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.1,
        textureSize: Vector2(32, 32),
      ),
    );

    add(
      SpriteAnimationComponent(
        position: Vector2(0, -6),
        animation: spriteAnimation,
        anchor: Anchor.topLeft,
      ),
    );
  }

  void collect() {
    removeFromParent();
    FlameAudio.play('collect_item.wav');
  }
}

class CoinFactory implements TiledObjectHandler {
  const  CoinFactory();

  @override
  void handleObject(TiledObject object, Layer layer, LeapMap map) {
    final coin = CoinComponent(object);
    map.add(coin);
  }
}
