import 'package:cosmic_jump/features/dialog/common.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DialogueTextBox extends TextBoxComponent {
  DialogueTextBox({required super.text})
      : super(
          position: Vector2(16, 16),
          size: Vector2(380, 96),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: fontSize,
              color: Colors.black,
            ),
          ),
        );
}