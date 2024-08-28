import 'dart:async';

import 'package:cosmic_jump/game/components/hud/character_preview_hud.dart';
import 'package:cosmic_jump/game/components/hud/health_hud.dart';
import 'package:cosmic_jump/game/components/hud/jetpack_energy_hud.dart';
import 'package:cosmic_jump/game/cosmic_jump.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class MainHud extends SpriteComponent
    with HasGameRef<CosmicJump>, TapCallbacks {
  MainHud();

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/Main.png'));
    position = Vector2.all(8);
    priority = 10;

    addAll([
      HealthHud(),
      JetpackEnergyHud(game.player.jetpack),
      CharacterPreviewHud(),
    ]);
    super.onLoad();
  }
}
