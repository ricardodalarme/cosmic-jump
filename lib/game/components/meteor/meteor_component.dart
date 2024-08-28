import 'dart:math';
import 'dart:ui';

import 'package:cosmic_jump/game/components/meteor/behaviours/meteor_collision_behaviour.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:leap/leap.dart';

class MeteorComponent extends PhysicalEntity {
  static final Vector2 _textureSize = Vector2(32, 56);
  static final Vector2 _hitbox = Vector2(28, 54);
  static const double _stepTime = 0.05;
  static const double _baseFallSpeed = 220;
  static const double _baseHorizontalSpeed = 60;
  static final _random = Random();

  bool isExploding = false;

  MeteorComponent() {
    _setupSolidProperties();
    _initializeRandomMovement();
    size = _hitbox;
  }

  @override
  void onLoad() {
    super.onLoad();
    _setupSpriteAnimation();
    _setupBehaviors();
    _updateAngle();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isExploding) {
      _updatePosition(dt);
      _updateAngle();
    }
    _checkBoundsAndRemoveIfNecessary();
  }

  void explode() {
    isExploding = true;
    _createExplosionParticles();
    removeFromParent();
  }

  void _setupSolidProperties() {
    isSolidFromTop = false;
    isSolidFromLeft = false;
    isSolidFromRight = false;
    isSolidFromBottom = false;
    solidTags.addAll([CommonTags.ground]);
  }

  void _initializeRandomMovement() {
    final fallSpeedMultiplier =
        _random.nextDouble() * 0.5 + 0.75; // 0.75x to 1.25x
    final horizontalSpeedMultiplier = _random.nextDouble() * 2 - 1; // -1x to 1x
    final direction = _random.nextBool() ? 1.0 : -1.0;

    velocity.xy = Vector2(
      direction * _baseHorizontalSpeed * horizontalSpeedMultiplier,
      _baseFallSpeed * fallSpeedMultiplier,
    );
  }

  void _setupSpriteAnimation() {
    final animation = SpriteAnimation.fromFrameData(
      leapGame.images.fromCache('Asteroids/Asteroid.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: _stepTime,
        textureSize: _textureSize,
      ),
    );

    add(SpriteAnimationComponent(animation: animation));
  }

  void _setupBehaviors() {
    addAll([
      CollisionDetectionBehavior(),
      MeteorCollisionBehavior(),
    ]);
  }

  void _updatePosition(double dt) {
    position += velocity * dt;
  }

  void _updateAngle() {
    double angle = velocity.angleTo(Vector2(0, 1));
    if (velocity.x > 0) {
      angle = -angle;
    }
    this.angle = angle;
  }

  void _checkBoundsAndRemoveIfNecessary() {
    final mapBounds = Rect.fromLTWH(0, 0, leapMap.size.x, leapMap.size.y);
    if (!mapBounds.overlaps(toRect())) {
      removeFromParent();
    }
  }

  void _createExplosionParticles() {
    final bottomCenter = Vector2(_hitbox.x / 2, _hitbox.y);
    final rotatedBottomCenter = bottomCenter.clone()
      ..rotate(angle)
      ..add(position);

    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 50,
        lifespan: 0.35,
        generator: (i) => AcceleratedParticle(
          acceleration: _getRandomVector() * 0.5,
          speed: _getRandomVector() * 2,
          child: CircleParticle(
            radius: _random.nextDouble() * 1.5,
            paint: Paint()
              ..color = Color.lerp(
                const Color(0xFFFFA500),
                const Color(0xFFFF4500),
                _random.nextDouble(),
              )!, // Gradient from orange to red
          ),
        ),
      ),
      position: rotatedBottomCenter,
    );

    leapWorld.add(particleComponent);
  }

  static Vector2 _getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 300;
  }
}
