import 'dart:math';

import 'package:cosmic_jump/game/cosmic_world.dart';
import 'package:cosmic_jump/game/utils/check_collision.dart';
import 'package:cosmic_jump/game/utils/custom_hitbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class MeteorComponent extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  final double fallSpeed = 200;
  static const double stepTime = 0.05;

  static const CustomHitbox hitbox = CustomHitbox(
    offsetX: 0,
    offsetY: 10,
    width: 38,
    height: 38,
  );

  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  bool isExploding = false;

  MeteorComponent() {
    size = Vector2.all(48);
  }

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Asteroids/Asteroid.png'),
      SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: stepTime,
        textureSize: Vector2.all(48),
      ),
    );

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
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
    final world = findParent<CosmicWorld>()!;
    for (final block in world.collisionBlocks) {
      if (block.isGround) {
        if (checkCollision(this, hitbox, block)) {
          await explode();
        }
      }
    }
  }

  Future<void> explode() async {
    isExploding = true;

    // Generate 20 white circle particles with random speed and acceleration,
    // at current position of this enemy. Each particles lives for exactly
    // 0.1 seconds and will get removed from the game world after that.
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
            paint: Paint()..color = Colors.orange[100]!,
          ),
        ),
      ),
    );

    final world = findParent<CosmicWorld>()!;

    world.add(particleComponent);

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
