import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:leap/leap.dart';

class MeteorComponent extends PhysicalEntity
    with HasGameRef, CollisionCallbacks {
  final double fallSpeed = 200;
  static const double _stepTime = 0.05;

  late final SpriteAnimation animation;

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  bool isExploding = false;

  MeteorComponent() {
    size = Vector2.all(38);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Asteroids/Asteroid.png'),
      SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: _stepTime,
        textureSize: Vector2.all(48),
      ),
    );

    add(
      SpriteAnimationComponent(
        animation: animation,
        size: Vector2.all(48),
      ),
    );
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
      position.y += fallSpeed * dt;
      position.x -= 50 * dt;
    }
    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
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
    // final world = findParent<World>()!;
    // for (final block in world.collisionBlocks) {
    //   if (block.isGround) {
    //     if (checkCollision(this, hitbox, block)) {
    //       await explode();
    //     }
    //   }
    // }
  }

  Future<void> explode() async {
    isExploding = true;

    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 35,
        lifespan: 0.4,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: position.clone(),
          child: CircleParticle(
            radius: 1.5,
            paint: Paint()..color = const Color(0xFFFFA500),
          ),
        ),
      ),
    );

    game.world.add(particleComponent);

    removeFromParent();
  }
}

final _random = Random();

Vector2 getRandomVector() {
  return (Vector2.random(_random) - Vector2.random(_random)) * 300;
}

// Returns a random direction vector with slight angle to +ve y axis.
Vector2 getRandomDirection() {
  return (Vector2.random(_random) - Vector2(0.5, -1)).normalized();
}
