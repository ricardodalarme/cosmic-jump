import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class CheckpointComponent extends PhysicalEntity {
  CheckpointComponent(TiledObject tiledObject)
      : super(
          position: tiledObject.position,
          priority: 2,
          size: tiledObject.size,
          static: true,
        );

  @override
  void onLoad() {
    super.onLoad();

    final image =
        leapGame.images.fromCache('Items/Checkpoints/Checkpoint/Rocket.png');

    add(
      SpriteComponent(
        sprite: Sprite(image),
        size: size,
      ),
    );
  }
}

class CheckpointFactory implements TiledObjectHandler {
  const CheckpointFactory();

  @override
  void handleObject(TiledObject object, Layer layer, LeapMap map) {
    final checkpoint = CheckpointComponent(object);
    map.add(checkpoint);
  }
}
