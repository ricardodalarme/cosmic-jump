import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class FallingPlatformComponent extends PhysicalEntity {
  FallingPlatformComponent(TiledObject object)
      : super(
          position: Vector2(object.x, object.y),
          size: Vector2(object.width, object.height),
        ) {
    tags.add(CommonTags.ground);
  }

  static final Vector2 _textureSize = Vector2(48, 9);
  static const double _initialFallSpeed = 100;
  static const double _fallAcceleration = 50;
  static const int _fallAfterInMs = 800;
  static const double _shakeDuration = 0.8;
  static const double _shakeIntensity = 2;

  Vector2 _originalPosition = Vector2.zero();
  double _fallSpeed = _initialFallSpeed;
  bool _falling = false;
  double _fallingTime = 0;
  bool _shaking = false;
  double _shakeTime = 0;

  final Random _random = Random();

  @override
  void onLoad() {
    super.onLoad();

    size = _textureSize;
    _originalPosition = position.clone();

    final image = leapGame.images.fromCache('Platforms/Falling.png');
    final spriteComponent = SpriteComponent(
      sprite: Sprite(image),
      size: size,
    );

    add(spriteComponent);
  }

  @override
  void updateAfter(double dt) {
    super.updateAfter(dt);

    if (_shaking) {
      _shakeTime += dt;
      if (_shakeTime >= _shakeDuration) {
        _shaking = false;
        _shakeTime = 0;
        position = _originalPosition;
      } else {
        final double shakeOffsetX =
            (_shakeIntensity * (1 - _shakeTime / _shakeDuration)) *
                (_random.nextBool() ? 1 : -1);
        position.x = _originalPosition.x + shakeOffsetX;
      }
    }

    if (_falling) {
      _fallingTime += dt * 10;

      _fallSpeed = _initialFallSpeed + _fallAcceleration * _fallingTime;

      position.y += _fallSpeed * dt;

      if (position.y > leapMap.size.y) {
        removeFromParent();
      }

      // Update the position of anything on top of this platform
      leapWorld.physicals
          .where((other) => other.collisionInfo.downCollision == this)
          .forEach((element) {
        element.y += _fallSpeed * dt;
      });
    }
  }

  void startFalling() {
    if (!_falling) {
      _shaking = true;

      Future.delayed(const Duration(milliseconds: _fallAfterInMs), () {
        _falling = true;
        _shaking = false;
      });
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
