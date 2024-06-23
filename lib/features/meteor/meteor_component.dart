import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/cosmic_world.dart';
import 'package:cosmic_jump/utils/check_collision.dart';
import 'package:cosmic_jump/utils/custom_hitbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class MeteorComponent extends SpriteAnimationComponent
    with HasGameRef<CosmicJump>, CollisionCallbacks {
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

  CosmicWorld worldd;

  MeteorComponent(this.worldd) {
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

    position.y += fallSpeed * dt;
    position.x -= 50 * dt;
    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  Future<void> onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) async {
    await _explode();
    super.onCollisionStart(intersectionPoints, other);
  }

  Future<void> _checkVerticalCollisions() async {
    for (final block in worldd.collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, hitbox, block)) {
          //await _explode();
        }
      }
    }
  }

  Future<void> _explode() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Collected.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
    await animationTicker?.completed;
    removeFromParent();
  }
}
