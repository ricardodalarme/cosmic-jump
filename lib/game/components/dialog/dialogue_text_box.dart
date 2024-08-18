import 'package:cosmic_jump/game/components/dialog/common.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DialogueTextBox extends TextBoxComponent {
  DialogueTextBox({super.text = '', super.size})
      : super(
          position: Vector2(8, 16),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: fontSize,
              color: Colors.black,
            ),
          ),
        );
}
