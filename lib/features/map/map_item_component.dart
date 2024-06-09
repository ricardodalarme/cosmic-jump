import 'dart:async';

import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/utils/custom_hitbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class MapItemComponent extends SpriteAnimationComponent
    with HasGameRef<CosmicJump>, CollisionCallbacks {
  final String item;
  MapItemComponent({
    required this.item,
    super.position,
    super.size,
  });

  final double stepTime = 0.05;
  static const hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = -1;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$item.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    return super.onLoad();
  }

  Future<void> collidedWithPlayer() async {
    if (!collected) {
      collected = true;
      if (game.playSounds) {
        await FlameAudio.play('collect_fruit.wav', volume: game.soundVolume);
      }
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
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
}
