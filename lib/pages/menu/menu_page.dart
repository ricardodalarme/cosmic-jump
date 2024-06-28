import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/pages/game/game_page.dart';
import 'package:cosmic_jump/widgets/rounded_button.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/rendering.dart';

class MenuPage extends Component with HasGameReference<CosmicJump> {
  late final TextComponent _logo;
  late final RoundedButton _button1;
  late final RoundedButton _button2;
  late final RoundedButton _button3;
  late final RoundedButton _inventoryButton;

  @override
  Future<void> onLoad() async {
    await addAll([
      _logo = TextComponent(
        text: 'CosmicJump',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 54,
            color: Color(0xFFC8FFF5),
            fontWeight: FontWeight.w800,
          ),
        ),
        anchor: Anchor.center,
      ),
      _button1 = RoundedButton(
        text: 'Mercúrio',
        action: () => game.router.pushRoute(GamePage.route(0)),
        color: const Color(0xffadde6c),
        borderColor: const Color(0xffedffab),
      ),
      _button2 = RoundedButton(
        text: 'Vênus',
        action: () => game.router.pushRoute(GamePage.route(1)),
        color: const Color(0xffdebe6c),
        borderColor: const Color(0xfffff4c7),
      ),
      _button3 = RoundedButton(
        text: 'Marte',
        action: () => game.router.pushRoute(GamePage.route(2)),
        color: const Color(0xffdebe6c),
        borderColor: const Color(0xfffff4c7),
      ),
      _inventoryButton = RoundedButton(
        text: 'Inventário',
        action: () => game.router.pushNamed('inventory'),
        color: BasicPalette.green.color,
        borderColor: BasicPalette.white.color,
      ),
    ]);
    super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2, size.y / 3);
    _button1.position = Vector2(size.x / 2, _logo.y + 140);
    _button2.position = Vector2(size.x / 2, _logo.y + 190);
    _button3.position = Vector2(size.x / 2, _logo.y + 240);
    _inventoryButton.position = Vector2(size.x / 2, _logo.y + 420);
  }
}
