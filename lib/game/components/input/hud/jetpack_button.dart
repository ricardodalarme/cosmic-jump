import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class JetpackButton extends SpriteComponent
    with HasGameReference, ComponentViewportMargin, TapCallbacks {
  JetpackButton({
    EdgeInsets? margin,
  }) : super(priority: 10) {
    this.margin = margin;
  }

  static final Vector2 _buttonSize = Vector2.all(48);

  bool isPressed = false;

  @override
  void onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/JetpackButton.png'));
    size = _buttonSize;
    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    isPressed = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    isPressed = false;
    super.onTapUp(event);
  }
}
