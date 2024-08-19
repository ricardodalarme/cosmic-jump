import 'package:cosmic_jump/data/account.dart';
import 'package:cosmic_jump/game/components/item/item_component.dart';
import 'package:flame/components.dart';

class EquipmentsHud extends PositionComponent with HasGameRef {
  EquipmentsHud() : super(position: _position);

  static final Vector2 _position = Vector2(0, 54);
  static const double _padding = 5;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final backgroundSprite = Sprite(game.images.fromCache('HUD/Equipment.png'));

    final equippedItems = account.equipments.equippedItems;
    for (var i = 0; i < equippedItems.length; i++) {
      final backgroundPosition =
          Vector2(i * (backgroundSprite.src.width + _padding), 0);
      final backgroundComponent = SpriteComponent(
        sprite: backgroundSprite,
        position: backgroundPosition,
      );

      add(backgroundComponent);

      if (equippedItems[i] != null) {
        final itemComponent = ItemComponent(
          item: equippedItems[i]!,
        );

        final itemPosition = Vector2(
          (backgroundSprite.src.width - ItemComponent.textureSize.x) / 2,
          (backgroundSprite.src.height - ItemComponent.textureSize.y) / 2,
        );

        itemComponent.position = itemPosition;

        backgroundComponent.add(itemComponent);
      }
    }
  }
}
