import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/features/inventory/hud/inventory_hud.dart';
import 'package:cosmic_jump/pages/game/hud/back_button.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class InventoryPage extends Component with HasGameReference<CosmicJump> {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    await addAll([
      TextComponent(
        text: 'Inventory',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 36,
            color: Color(0xFFC8FFF5),
            fontWeight: FontWeight.w800,
          ),
        ),
        position: Vector2(60, 10),
      ),
      InventoryComponent(game.account.inventory),
      BackButton(),
    ]);
  }
}
