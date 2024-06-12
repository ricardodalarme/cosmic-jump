import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/features/jetpack/jetpack_component.dart';
import 'package:flame/components.dart';

class JetpackEnergyHud extends SpriteComponent
    with HasGameReference<CosmicJump> {
  JetpackEnergyHud(this.jetpack) : super(position: _position);

  final JetpackComponent jetpack;

  static final Vector2 _position = Vector2(53, 14);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(
      'HUD/Energy.png',
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    final spriteWidth = sprite!.srcSize.x;

    // reduces the size of the sprite based on the player's health
    width = spriteWidth * (jetpack.remainingTime / JetpackComponent.duration);
  }
}
