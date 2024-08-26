import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:cosmic_jump/game/components/player/player_state.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:leap/leap.dart';

class PlayerSpriteAnimation
    extends AnchoredAnimationGroup<PlayerState, PlayerComponent>
    with HasGameRef<LeapGame> {
  PlayerSpriteAnimation() : super(scale: Vector2.all(1.5));

  static const double _stepTime = 0.05;

  @override
  Future<void> onLoad() async {
    animations = {
      PlayerState.idle: _spriteAnimation('Idle', 11),
      PlayerState.walk: _spriteAnimation('Run', 12),
      PlayerState.jump: _spriteAnimation('Jump', 1),
      PlayerState.fall: _spriteAnimation('Fall', 1),
      PlayerState.death: _specialSpriteAnimation('Desappearing', 7),
    };

    current = PlayerState.idle;

    return super.onLoad();
  }

  @override
  @mustCallSuper
  void update(double dt) {
    // Default to playing animations
    playing = true;

    if (parent.isDead) {
      current = PlayerState.death;
    } else {
      if (parent.collisionInfo.down) {
        // On the ground.
        if (parent.velocity.x.abs() > 0) {
          current = PlayerState.walk;
        } else {
          current = PlayerState.idle;
        }
      } else {
        // In the air.
        if (parent.velocity.y > (parent.leapWorld.maxGravityVelocity / 4)) {
          current = PlayerState.fall;
        } else if (parent.velocity.y < 0) {
          current = PlayerState.jump;
        }
      }
    }
    super.update(dt);
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Characters/${parent.character}/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: _stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: _stepTime,
        textureSize: Vector2.all(96),
        loop: false,
      ),
    );
  }
}
