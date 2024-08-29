import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:leap/leap.dart';

class PlayerDeathBehavior extends PhysicalBehavior<PlayerComponent> {
  @override
  void update(double dt) {
    if (parent.isDead) {
      // Set zero on velocity again in case player died this tick
      parent.velocity.setZero();

      if (parent.animationGroup.animationTicker?.done() == true) {
        parent.respawn();
      }
    }

    if (parent.wasAlive && !parent.isAlive) {
      parent.position.y += 48;
    }
  }
}
