import 'dart:async';

import 'package:cosmic_jump/game/cosmic_jump.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class JetpackButton extends SpriteComponent
    with HasGameRef<CosmicJump>, TapCallbacks {
  JetpackButton();

  final margin = 32;
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/Knob.png'));
    position = Vector2(
      game.size.x - margin - buttonSize - buttonSize - 10,
      game.size.y - 16 - buttonSize,
    );
    priority = 10;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasUsedJetpack = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasUsedJetpack = false;
    super.onTapUp(event);
  }
}
