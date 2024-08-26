import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:flame/components.dart';
import 'package:leap/leap.dart';

class PlayerDeathBehavior extends PhysicalBehavior<PlayerComponent> {
  @override
  void update(double dt) {
    if (parent.isDead) {
      if (parent.deadTime == 0) {
        parent.position -= Vector2.all(32);
      }

      parent.deadTime += dt;
      // Set zero on velocity again in case player died this tick
      parent.velocity.setZero();
    }

    if (leapWorld.isOutside(parent) || (parent.isDead && parent.deadTime > 3)) {
      parent.health = parent.initialHealth;
      parent.deadTime = 0;
      parent.reespawn();
    }

    if (parent.wasAlive && !parent.isAlive) {
      // FlameAudio.play('die.wav');
    }
  }
}
