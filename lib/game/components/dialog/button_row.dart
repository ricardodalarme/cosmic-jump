import 'package:cosmic_jump/game/components/dialog/dialogue_button.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:jenny/jenny.dart';

class ButtonRow extends PositionComponent {
  ButtonRow({required super.size}) : super(position: Vector2(0, 145));

  void removeButtons() {
    final buttonList = children.query<DialogueButton>();
    if (buttonList.isNotEmpty) {
      for (final dialogueButton in buttonList) {
        if (dialogueButton.parent != null) {
          dialogueButton.removeFromParent();
        }
      }
    }
  }

  void showNextButton(VoidCallback onNextButtonPressed) {
    removeButtons();
    final nextButton = DialogueButton(
      assetPath: 'HUD/green_button_sqr.png',
      text: 'Próximo',
      position: Vector2(size.x / 2, 0),
      onPressed: () {
        onNextButtonPressed();
        removeButtons();
      },
    );
    add(nextButton);
  }

  void showOptionButtons({
    required void Function(int optionNumber) onChoice,
    required DialogueOption option1,
    required DialogueOption option2,
  }) {
    removeButtons();
    final optionButtons = <DialogueButton>[
      DialogueButton(
        assetPath: 'HUD/green_button_sqr.png',
        text: option1.text,
        position: Vector2(size.x / 4, 0),
        onPressed: () {
          onChoice(0);
          removeButtons();
        },
      ),
      DialogueButton(
        assetPath: 'HUD/red_button_sqr.png',
        text: option2.text,
        position: Vector2(size.x * 3 / 4, 0),
        onPressed: () {
          onChoice(1);
          removeButtons();
        },
      ),
    ];
    addAll(optionButtons);
  }

  void showCloseButton(VoidCallback onClose) {
    final closeButton = DialogueButton(
      assetPath: 'HUD/green_button_sqr.png',
      text: 'Fechar',
      onPressed: () => onClose(),
      position: Vector2(size.x / 2, 0),
    );
    add(closeButton);
  }
}
