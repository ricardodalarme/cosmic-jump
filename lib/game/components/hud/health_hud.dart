import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:cosmic_jump/game/cosmic_jump.dart';
import 'package:flame/components.dart';

class HealthHud extends SpriteComponent with HasGameReference<CosmicJump> {
  HealthHud() : super(position: _position);

  static final Vector2 _position = Vector2(53, 4);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(
      'HUD/Health.png',
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    final spriteWidth = sprite!.srcSize.x;

    // reduces the size of the sprite based on the player's health
    width = spriteWidth * (game.player.health / PlayerComponent.maxHealth);
  }
}
