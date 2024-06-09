import 'dart:async';

import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/features/equipment/hud/equipment_hud.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class GamePage extends Component with HasGameReference<CosmicJump> {
  late EquipmentHud equipmentHud;

  GamePage({required this.levelIndex});

  final int levelIndex;

  static Route route(int levelIndex) {
    return Route(
      () => GamePage(levelIndex: levelIndex),
    );
  }

  @override
  FutureOr<void> onLoad() async {
    game.loadLevel(levelIndex);

    return super.onLoad();
  }

  @override
  void onRemove() {
    game.unloadCurrentLevel();
    super.onRemove();
  }
}
