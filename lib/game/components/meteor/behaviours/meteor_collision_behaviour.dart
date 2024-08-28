import 'package:cosmic_jump/game/components/meteor/meteor_component.dart';
import 'package:leap/leap.dart';

class MeteorCollisionBehavior extends PhysicalBehavior<MeteorComponent> {
  @override
  void update(double dt) {
    for (final other in collisionInfo.allCollisions) {
      switch (other) {
        case MeteorComponent():
          parent.explode();
          other.explode();
        case LeapMapGroundTile(:final tile) when tile.class_ == 'TheGround':
          parent.explode();
        default:
          break;
      }
    }
  }
}
