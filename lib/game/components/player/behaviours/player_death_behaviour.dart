import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:cosmic_jump/game/cosmic_jump.dart';
import 'package:flame/components.dart';
import 'package:leap/leap.dart';

class PlayerDeathBehavior extends PhysicalBehavior<PlayerComponent>
    with HasGameRef<CosmicJump> {
  @override
  Future<void> update(double dt) async {
    if (parent.wasAlive && !parent.isAlive) {
      parent.position.y += 48;
    }

    if (parent.isDead) {
      // Set zero on velocity again in case player died this tick
      parent.velocity.setZero();

      if (parent.animationGroup.animationTicker?.done() == true) {
        await game.loadLevel();
      }
    }
  }
}
