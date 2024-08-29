import 'package:flame_tiled/flame_tiled.dart';
import 'package:leap/leap.dart';

class BlockComponent extends PhysicalEntity {
  BlockComponent(TiledObject tiledObject)
      : super(
          static: true,
          size: tiledObject.size,
          position: tiledObject.position,
        ) {
    tags.add(tag);
  }

  static const String tag = 'Block';
}

class BlockFactory implements TiledObjectHandler {
  const BlockFactory();

  @override
  void handleObject(TiledObject object, Layer layer, LeapMap map) {
    final component = BlockComponent(object);
    map.add(component);
  }
}
