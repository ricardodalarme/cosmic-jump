import 'package:cosmic_jump/constants/app_colors.dart';
import 'package:cosmic_jump/game/components/dialog/common.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';

class DialogueButton extends SpriteComponent with HasGameRef, TapCallbacks {
  DialogueButton({
    required super.position,
    required this.assetPath,
    required this.text,
    required this.onPressed,
    super.anchor = Anchor.center,
  });

  final String text;
  final String assetPath;
  final void Function() onPressed;

  @override
  Future<void> onLoad() async {
    final image = game.images.fromCache(assetPath);
    sprite = Sprite(image);
    add(
      TextComponent(
        text: text,
        position: Vector2(48, 16),
        anchor: Anchor.center,
        size: Vector2(88, 28),
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: fontSize,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    onPressed.call();
  }
}
