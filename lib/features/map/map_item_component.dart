import 'dart:async';

import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/features/item/item_component.dart';
import 'package:cosmic_jump/features/item/item_model.dart';
import 'package:cosmic_jump/utils/custom_hitbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class MapItemComponent extends PositionComponent
    with HasGameRef<CosmicJump>, CollisionCallbacks {
  final ItemModel item;
  late final ItemComponent _itemComponent;

  MapItemComponent({
    required this.item,
    super.position,
    super.size,
  }) : super(priority: -1);

  static const _hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );

  bool _collected = false;

  static const double _collectStepTime = 0.05;
  static const int _collectAnimationFrames = 6;
  static final Vector2 _collectTextureSize = Vector2.all(32);

  @override
  FutureOr<void> onLoad() {
    _itemComponent = ItemComponent(item: item);

    addAll([
      RectangleHitbox(
        position: Vector2(_hitbox.offsetX, _hitbox.offsetY),
        size: Vector2(_hitbox.width, _hitbox.height),
        collisionType: CollisionType.passive,
      ),
      _itemComponent,
    ]);

    super.onLoad();
  }

  Future<void> collidedWithPlayer() async {
    if (!_collected) {
      _collected = true;
      if (game.playSounds) {
        await FlameAudio.play('collect_item.wav', volume: game.soundVolume);
      }
      _itemComponent.animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: _collectAnimationFrames,
          stepTime: _collectStepTime,
          textureSize: _collectTextureSize,
          loop: false,
        ),
      );

      await _itemComponent.animationTicker?.completed;
      removeFromParent();
    }
  }
}
