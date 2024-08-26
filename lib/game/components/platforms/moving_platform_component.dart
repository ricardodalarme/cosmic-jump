import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class MovingPlatformComponent extends MovingPlatform with HasGameRef {
  MovingPlatformComponent.fromTiledObject(super.tiledObject)
      : spriteName = tiledObject.properties['Sprite']! as StringProperty,
        super.fromTiledObject();

  final StringProperty spriteName;

  static const double _stepTime = 0.5;

  @override
  void onLoad() {
    super.onLoad();

    size = Vector2.all(32);
    final animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Platforms/${spriteName.value}.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: _stepTime,
        textureSize: Vector2(32, 8),
      ),
    );

    add(
      SpriteAnimationComponent(
        animation: animation,
      ),
    );
  }
}

class MovingPlatformFactory implements TiledObjectHandler {
  const MovingPlatformFactory();

  @override
  void handleObject(TiledObject object, Layer layer, LeapMap map) {
    final component = MovingPlatformComponent.fromTiledObject(object);
    map.add(component);
  }
}
