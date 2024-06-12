import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:flame/components.dart';

class CharacterPreviewHud extends SpriteComponent
    with HasGameReference<CosmicJump> {
  CharacterPreviewHud();

  static const double _boxSize = 44;
  static const double _boxPadding = 4;

  static const double _verticalAdjustment = 6;

  static final Vector2 _spriteSize = Vector2.all(32);

  @override
  Future<void> onLoad() async {
    final character = game.player.character;
    sprite = Sprite(
      game.images.fromCache('Main Characters/$character/Idle (32x32).png'),
      srcSize: _spriteSize,
    );

    position = Vector2(
      _boxPadding + (_boxSize - sprite!.srcSize.x) / 2,
      _boxPadding + (_boxSize - sprite!.srcSize.y) / 2 - _verticalAdjustment,
    );
  }
}
