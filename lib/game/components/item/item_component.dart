import 'dart:async';

import 'package:cosmic_jump/models/item_model.dart';
import 'package:flame/components.dart';

class ItemComponent extends SpriteAnimationComponent with HasGameRef {
  final ItemModel item;

  ItemComponent({
    required this.item,
    super.position,
    super.size,
  });

  static const double _stepTime = 0.05;
  static final Vector2 textureSize = Vector2.all(32);

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(item.imagePath),
      SpriteAnimationData.sequenced(
        amount: item.animationFrames,
        stepTime: _stepTime,
        textureSize: textureSize,
      ),
    );
    super.onLoad();
  }
}
