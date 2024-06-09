import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/widgets/simple_button.dart';
import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';

class PauseButton extends SimpleButton with HasGameReference<CosmicJump> {
  PauseButton()
      : super(
          Path()
            ..moveTo(14, 10)
            ..lineTo(14, 30)
            ..moveTo(26, 10)
            ..lineTo(26, 30),
          position: Vector2(60, 10),
        );
  @override
  void action() => game.router.pushNamed('pause');
}
