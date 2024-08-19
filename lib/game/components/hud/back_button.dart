import 'dart:async';

import 'package:cosmic_jump/main.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class BackButton extends SpriteComponent with HasGameRef, TapCallbacks {
  BackButton();

  static const margin = 16.0;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/Back.png'));
    position = Vector2(
      game.size.x - margin - sprite!.image.width,
      margin,
    );
    priority = 10;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    navigatorKey.currentState?.pop();
    super.onTapDown(event);
  }
}
