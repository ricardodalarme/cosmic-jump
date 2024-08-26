import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:leap/leap.dart';

class PlayerDamageBehavior extends PhysicalBehavior<PlayerComponent> {
  @override
  void update(double dt) {
    parent.wasAlive = parent.isAlive;

    if (collisionInfo.downCollision?.tags.contains('Hazard') ?? false) {
      parent.health -= collisionInfo.downCollision!.hazardDamage;
    }
  }
}
