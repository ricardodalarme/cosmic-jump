import 'package:cosmic_jump/game/components/meteor/meteor_component.dart';
import 'package:leap/leap.dart';

class MeteorCollisionBehavior extends PhysicalBehavior<MeteorComponent> {
  @override
  void update(double dt) {
    for (final other in collisionInfo.downCollisions) {
      switch (other) {
        case LeapMapGroundTile(:final tile) when tile.class_ == 'TheGround':
          parent.explode();
        default:
          break;
      }
    }
  }
}
