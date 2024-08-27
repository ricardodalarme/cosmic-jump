import 'package:cosmic_jump/game/components/jetpack/jetpack_component.dart';
import 'package:cosmic_jump/game/components/jetpack/jetpack_status.dart';
import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:cosmic_jump/game/cosmic_jump.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart' hide PlayerState;
import 'package:leap/leap.dart';

class PlayerInputBehavior extends PhysicalBehavior<PlayerComponent>
    with HasGameRef<CosmicJump> {
  @override
  void update(double dt) {
    if (parent.isDead) {
      parent.jumping = false;
      parent.isWalking = false;
      return;
    }

    _horizontalMovement();
    _jetpack(dt);
    _jump(dt);
  }

  void _horizontalMovement() {
    if (game.input.isPressedLeft) {
      if (!parent.isWalking) {
        parent.airXVelocity = parent.walkSpeed;
      }

      parent.isWalking = true;
      parent.faceLeft = true;
    } else if (game.input.isPressedRight) {
      if (!parent.isWalking) {
        parent.airXVelocity = parent.walkSpeed;
      }
      parent.isWalking = true;
      parent.faceLeft = false;
    } else {
      parent.isWalking = false;
      if (parent.collisionInfo.down) {
        parent.airXVelocity = 0;
      }
    }
  }

  void _jump(double dt) {
    if (parent.hasUsedJetpack) return;

    if (game.input.isPressedUp && parent.collisionInfo.down) {
      parent.jumping = true;
      FlameAudio.play('jump.wav'); // Toca som de pulo
    }

    if (parent.jumping &&
        game.input.isPressedUp &&
        parent.timeHoldingJump < parent.maxJumpHoldTime &&
        !collisionInfo.up) {
      parent.timeHoldingJump += dt;
    } else {
      parent.jumping = false;
      parent.timeHoldingJump = 0;
    }

    parent.wasJumping = parent.jumping;
  }

  void _jetpack(double dt) {
    if (parent.jetpack == null) return;

    parent.hasUsedJetpack = game.input.isPressedDown;

    if (parent.hasUsedJetpack) {
      parent.jetpack?.use();

      if (parent.jetpack?.status == JetpackStaus.using) {
        _playerUseJetpack(dt);
      }
    } else {
      parent.jetpack?.stop();
    }
  }

  void _playerUseJetpack(double dt) {
    velocity.y = -JetpackComponent.force;
    position.y += velocity.y * dt;
  }
}
