import 'package:cosmic_jump/game/components/input/input.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class KeyboardInputComponent extends Component with KeyboardHandler, Input {
  KeyboardInputComponent();

  static final Set<PhysicalKeyboardKey> _leftKeys = {
    PhysicalKeyboardKey.arrowLeft,
    PhysicalKeyboardKey.keyA,
  };

  static final Set<PhysicalKeyboardKey> _rightKeys = {
    PhysicalKeyboardKey.arrowRight,
    PhysicalKeyboardKey.keyD,
    PhysicalKeyboardKey.keyL,
  };

  static final Set<PhysicalKeyboardKey> _upKeys = {
    PhysicalKeyboardKey.space,
  };

  static final Set<PhysicalKeyboardKey> _downKeys = {
    PhysicalKeyboardKey.keyX,
  };

  static final Set<PhysicalKeyboardKey> _relevantKeys = {
    ..._leftKeys,
    ..._rightKeys,
    ..._upKeys,
    ..._downKeys,
  };

  final Set<PhysicalKeyboardKey> _keysDown = {};

  bool get _isPressed => _keysDown.isNotEmpty;

  @override
  bool get isPressedLeft =>
      _isPressed && _keysDown.intersection(_leftKeys).isNotEmpty;

  @override
  bool get isPressedRight =>
      _isPressed && _keysDown.intersection(_rightKeys).isNotEmpty;

  @override
  bool get isPressedUp =>
      _isPressed && _keysDown.intersection(_upKeys).isNotEmpty;

  @override
  bool get isPressedDown =>
      _isPressed && _keysDown.intersection(_downKeys).isNotEmpty;

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Ignore irrelevant keys.
    if (_relevantKeys.contains(event.physicalKey)) {
      if (event is KeyDownEvent) {
        _keysDown.add(event.physicalKey);
      } else if (event is KeyUpEvent) {
        _keysDown.remove(event.physicalKey);
      }
    }
    return true;
  }

  @override
  void reset() {
    _keysDown.clear();
  }
}
