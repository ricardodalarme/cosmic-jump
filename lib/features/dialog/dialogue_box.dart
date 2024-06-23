import 'package:cosmic_jump/features/dialog/button_row.dart';
import 'package:cosmic_jump/features/dialog/dialogue_text_box.dart';
import 'package:flame/components.dart';
import 'package:jenny/jenny.dart';

class DialogueBoxComponent extends SpriteComponent with HasGameReference {
  DialogueTextBox textBox = DialogueTextBox(text: '');
  final Vector2 spriteSize = Vector2(736, 128);
  late final ButtonRow buttonRow;

  @override
  Future<void> onLoad() async {
    position = Vector2(game.size.x / 2, game.size.y - 77);
    anchor = Anchor.bottomCenter;
    sprite = await Sprite.load(
      'HUD/Dialog.png',
      srcSize: spriteSize,
    );
    size = Vector2(game.size.x - 10, 155);
    buttonRow = ButtonRow(size: size);
    await addAll([buttonRow, textBox]);
    return super.onLoad();
  }

  void changeText(String newText, void Function() goNextLine) {
    textBox.text = newText;
    buttonRow.showNextButton(goNextLine);
  }

  void showOptions({
    required void Function(int optionNumber) onChoice,
    required DialogueOption option1,
    required DialogueOption option2,
  }) {
    buttonRow.showOptionButtons(
      onChoice: onChoice,
      option1: option1,
      option2: option2,
    );
  }

  void showCloseButton(void Function() onClose) {
    buttonRow.showCloseButton(onClose);
  }
}
