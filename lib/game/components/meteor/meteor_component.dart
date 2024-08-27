import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:leap/leap.dart';

class MeteorComponent extends PhysicalEntity with CollisionCallbacks {
  final double baseFallSpeed = 200;
  final double baseHorizontalSpeed = 50;
  static const double _stepTime = 0.05;

  late final SpriteAnimation animation;
  late final SpriteAnimationComponent spriteComponent;

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  bool isExploding = false;

  @override
  // ignore: overridden_fields
  Vector2 velocity = Vector2.zero();

  MeteorComponent() {
    size = Vector2.all(38);
    _initializeRandomMovement();
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

    animation = SpriteAnimation.fromFrameData(
      leapGame.images.fromCache('Asteroids/Asteroid.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: _stepTime,
        textureSize: Vector2(32, 56),
      ),
    );

    spriteComponent = SpriteAnimationComponent(
      animation: animation,
      size: Vector2(32, 56),
      anchor: Anchor.center, // Set anchor to center for proper rotation
    );

    _updateSpriteAngle(); // Set initial angle

    add(spriteComponent);
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
      _updateSpriteAngle(); // Update the sprite angle dynamically based on current velocity
    }

    if (position.y > leapMap.size.y ||
        position.x < 0 ||
        position.x > leapMap.size.x) {
      removeFromParent();
    }
  }

  void _updateSpriteAngle() {
    // Calculate the angle in radians based on the velocity vector
    double angle = velocity.angleTo(Vector2(0, 1));

    // Ensure the sprite is correctly oriented for left-to-right movement
    if (velocity.x > 0) {
      angle = -angle; // Flip the angle for left-to-right movement
    }

    // Rotate the sprite component to match the movement angle
    spriteComponent.angle = angle;
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
