import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class CheckpointComponent extends PhysicalEntity with HasGameRef {
  CheckpointComponent(TiledObject tiledObject) : super(static: true) {
    size = tiledObject.size;
    position = tiledObject.position;
    position = Vector2(tiledObject.x, tiledObject.y);
    priority = 2;
  }

  @override
  void onLoad() {
    super.onLoad();

    final sprite =
        game.images.fromCache('Items/Checkpoints/Checkpoint/Rocket.png');

    add(
      SpriteComponent(
        sprite: Sprite(sprite),
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
