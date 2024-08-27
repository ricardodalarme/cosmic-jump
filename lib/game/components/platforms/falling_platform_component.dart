import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class FallingPlatformComponent extends PhysicalEntity {
  FallingPlatformComponent(TiledObject object)
      : spriteName = object.properties['Sprite']! as StringProperty,
        super(
          position: Vector2(object.x, object.y),
          size: Vector2(object.width, object.height),
        ) {
    tags.add(CommonTags.ground);
  }

  final StringProperty spriteName;

  static const double _stepTime = 0.5;
  static const double initialFallSpeed = 100;
  static const double fallAcceleration = 25; // Fator de aceleração
  double fallSpeed = initialFallSpeed;
  bool _falling = false;
  double fallingTime = 0;
  late SpriteAnimationComponent animationComponent;

  @override
  void onLoad() {
    super.onLoad();

    size = Vector2.all(32);
    final animation = SpriteAnimation.fromFrameData(
      leapGame.images.fromCache('Platforms/${spriteName.value}.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: _stepTime,
        textureSize: Vector2(32, 8),
        loop: false,
      ),
    );

    animationComponent = SpriteAnimationComponent(
      animation: animation,
      size: size,
      playing: false,
    );

    add(animationComponent);
  }

  @override
  void updateAfter(double dt) {
    if (_falling) {
      fallingTime += dt * 10;

      fallSpeed = initialFallSpeed + fallAcceleration * fallingTime;

      position.y += fallSpeed * dt;

      if (position.y > leapMap.size.y) {
        removeFromParent();
      }

      // Update the position of anything on top of this platform. Ideally
      // this happens before the other entity's collision logic
      leapWorld.physicals
          .where((other) => other.collisionInfo.downCollision == this)
          .forEach((element) {
        element.y += fallSpeed * dt;
      });
    }

    super.updateAfter(dt);
  }

  void startFalling() {
    animationComponent.animationTicker?.onComplete = () {
      _falling = true;
    };
    if (!animationComponent.playing) {
      animationComponent.animationTicker?.reset();
      animationComponent.playing = true;
    }
  }
}

class FallingPlatformFactory implements TiledObjectHandler {
  const FallingPlatformFactory();

  @override
  void handleObject(TiledObject object, Layer layer, LeapMap map) {
    final component = FallingPlatformComponent(object);
    map.add(component);
  }
}
