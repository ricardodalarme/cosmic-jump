import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/widgets/simple_button.dart';
import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';

class BackButton extends SimpleButton with HasGameReference<CosmicJump> {
  BackButton()
      : super(
          Path()
            ..moveTo(22, 8)
            ..lineTo(10, 20)
            ..lineTo(22, 32)
            ..moveTo(12, 20)
            ..lineTo(34, 20),
          position: Vector2.all(10),
        );

  @override
  void action() => game.router.pop();
}
