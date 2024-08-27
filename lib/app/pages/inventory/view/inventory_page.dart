import 'package:cosmic_jump/constants/colors.dart';
import 'package:cosmic_jump/data/items.dart';
import 'package:cosmic_jump/game/components/inventory/hud/inventory_hud.dart';
import 'package:cosmic_jump/models/inventory_manager.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late final InventoryGame _game;

  @override
  void initState() {
    super.initState();
    _game = InventoryGame();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GameWidget(
        game: _game,
      ),
    );
  }
}

class InventoryGame extends FlameGame {
  final InventoryManager inventory = InventoryManager();

  @override
  Color backgroundColor() => darkBlue;

  @override
  Future<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();
    inventory.addItem(items[0]);
    inventory.addItem(items[1]);
    inventory.addItem(items[2]);
    add(InventoryComponent(inventory));
  }
}
