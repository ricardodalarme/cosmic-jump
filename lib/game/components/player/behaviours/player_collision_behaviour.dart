import 'package:cosmic_jump/game/components/checkpoint/checkpoint_component.dart';
import 'package:cosmic_jump/game/components/coin/coin_component.dart';
import 'package:cosmic_jump/game/components/meteor/meteor_component.dart';
import 'package:cosmic_jump/game/components/platforms/falling_platform_component.dart';
import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:leap/leap.dart';

class PlayerCollisionBehavior extends PhysicalBehavior<PlayerComponent> {
  @override
  void update(double dt) {
    if (parent.isDead) {
      return;
    }

    if (parent.didEnemyBop) {
      parent.didEnemyBop = false;
      velocity.y = -parent.minJumpImpulse;
    }

    for (final other in collisionInfo.allCollisions) {
      switch (other) {
        case CheckpointComponent():
          parent.hasReachedCheckpoint = true;
        case MeteorComponent():
          parent.health = 0;
          other.explode();
        case CoinComponent():
          other.collect();
          parent.coins++;
        case FallingPlatformComponent():
          if (collisionInfo.down) other.startFalling();
      }
    }
  }
}
