import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class SpikeEntity extends PhysicalEntity with HasGameRef {
  SpikeEntity(TiledObject tiledObject) : super(static: true) {
    size = tiledObject.size;
    position = tiledObject.position;
    position = Vector2(tiledObject.x, tiledObject.y);
    priority = 2;
  }

  @override
  void onLoad() {
    super.onLoad();

    final sprite =
        game.images.fromCache('Traps/Spikes/Idle.png');

    add(
      SpriteComponent(
        sprite: Sprite(sprite),
        size: size,
      ),
    );
  }
}

class TrapFactory implements TiledObjectHandler {
  const TrapFactory();

  @override
  void handleObject(TiledObject object, Layer layer, LeapMap map) {
    final spike = SpikeEntity(object);
    map.add(spike);
  }
}
