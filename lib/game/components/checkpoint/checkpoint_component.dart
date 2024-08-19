import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CheckpointComponent extends SpriteComponent
    with HasGameRef, CollisionCallbacks {
  CheckpointComponent({
    super.position,
    super.size,
  });

  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
        position: Vector2(0, 0),
        size: size,
        collisionType: CollisionType.passive,
      ),
    );

    sprite = Sprite(
      game.images.fromCache('Items/Checkpoints/Checkpoint/Rocket.png'),
    );
    return super.onLoad();
  }
}
