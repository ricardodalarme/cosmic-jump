import 'dart:math';
import 'dart:ui';

import 'package:cosmic_jump/game/components/meteor/behaviours/meteor_collision_behaviour.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:leap/leap.dart';

class MeteorComponent extends PhysicalEntity with CollisionCallbacks {
  final double baseFallSpeed = 220;
  final double baseHorizontalSpeed = 60;
  static const double _stepTime = 0.05;

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  bool isExploding = false;

  static final Vector2 _textureSize = Vector2(32, 56);
  static final Vector2 _hitbox = Vector2(28, 56);

  @override
  // ignore: overridden_fields
  Vector2 velocity = Vector2.zero();

  MeteorComponent() {
    addAll(
      [
        CollisionDetectionBehavior(),
        MeteorCollisionBehavior(),
      ],
    );

    size = _hitbox;
    _initializeRandomMovement();

    solidTags.addAll([CommonTags.ground]);
  }

  void _initializeRandomMovement() {
    // Randomize the fall and horizontal speeds
    final fallSpeedMultiplier =
        _random.nextDouble() * 0.5 + 0.75; // 0.75x to 1.25x
    final horizontalSpeedMultiplier = _random.nextDouble() * 2 - 1; // -1x to 1x

    // Apply random direction to horizontal movement
    final direction = _random.nextBool() ? 1.0 : -1.0;

    velocity = Vector2(
      direction * baseHorizontalSpeed * horizontalSpeedMultiplier,
      baseFallSpeed * fallSpeedMultiplier,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final animation = SpriteAnimation.fromFrameData(
      leapGame.images.fromCache('Asteroids/Asteroid.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: _stepTime,
        textureSize: _textureSize,
      ),
    );

    final spriteComponent = SpriteAnimationComponent(animation: animation);
    add(spriteComponent);

    _updateAngle();
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    accumulatedTime += dt;

    if (isMounted) {
      while (accumulatedTime >= fixedDeltaTime) {
        await _checkVerticalCollisions();
        accumulatedTime -= fixedDeltaTime;
      }
    }

    if (!isExploding) {
      position += velocity * dt;
      _updateAngle(); // Update the sprite angle dynamically based on current velocity
    }

    if (position.y > leapMap.size.y ||
        position.x < 0 ||
        position.x > leapMap.size.x) {
      removeFromParent();
    }
  }

  void _updateAngle() {
    // Calculate the angle in radians based on the velocity vector
    double angle = velocity.angleTo(Vector2(0, 1));

    // Ensure the sprite is correctly oriented for left-to-right movement
    if (velocity.x > 0) {
      angle = -angle; // Flip the angle for left-to-right movement
    }

    // Rotate the sprite component to match the movement angle
    this.angle = angle;
  }

  @override
  Future<void> onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) async {
    await _checkVerticalCollisions();
    super.onCollisionStart(intersectionPoints, other);
  }

  Future<void> _checkVerticalCollisions() async {
    // Collision logic can be implemented here if needed
  }

  Future<void> explode() async {
    isExploding = true;

    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 50,
        lifespan: 0.35,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector() * 0.5,
          speed: getRandomVector() * 2,
          position: position.clone(),
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
    );

    leapWorld.add(particleComponent);

    removeFromParent();
  }
}

final _random = Random();

Vector2 getRandomVector() {
  return (Vector2.random(_random) - Vector2.random(_random)) * 300;
}
