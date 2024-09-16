import 'package:cosmic_jump/game/components/input/hud/jetpack_button.dart';
import 'package:cosmic_jump/game/components/input/input.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';

class TapInputComponent extends PositionComponent
    with HasGameRef, TapCallbacks, Input {
  late final JoystickComponent _joystick;
  late final JetpackButton _jetpackButton;

  bool _isPressing = false;

  static final Set<JoystickDirection> _leftJoystickDirections = {
    JoystickDirection.left,
    JoystickDirection.upLeft,
    JoystickDirection.downLeft,
  };

  static final Set<JoystickDirection> _rightJoystickDirections = {
    JoystickDirection.right,
    JoystickDirection.upRight,
    JoystickDirection.downRight,
  };

  static const double _buttonMargin = 16;

  @override
  void onLoad() {
    super.onLoad();
    _addJoystick();
    _addJetpackButton();
  }

  void _addJoystick() {
    final knob = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('HUD/Knob.png'),
      ),
    );

    final background = SpriteComponent(
      sprite: Sprite(
        game.images.fromCache('HUD/Joystick.png'),
      ),
    );

    _joystick = JoystickComponent(
      knob: knob,
      background: background,
      margin: const EdgeInsets.only(left: _buttonMargin, bottom: _buttonMargin),
    );

    game.camera.viewport.add(_joystick);
  }

  void _addJetpackButton() {
    _jetpackButton = JetpackButton(
      margin:
          const EdgeInsets.only(right: _buttonMargin, bottom: _buttonMargin),
    );
    game.camera.viewport.add(_jetpackButton);
  }

  @override
  bool get isPressedLeft =>
      _leftJoystickDirections.contains(_joystick.direction);

  @override
  bool get isPressedUp => _isPressing;

  @override
  bool get isPressedDown => _jetpackButton.isPressed;

  @override
  bool get isPressedRight =>
      _rightJoystickDirections.contains(_joystick.direction);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size.setFrom(size);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_isPositionOnControls(event.localPosition)) return;

    _isPressing = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    _isPressing = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    reset();
  }

  @override
  void reset() {
    _isPressing = false;
  }

  bool _isPositionOnControls(Vector2 position) {
    final positionOffset = position.toOffset();
    final joystickRect = _joystick.toRect();
    final jetpackButtonRect = _jetpackButton.toRect();

    return joystickRect.contains(positionOffset) ||
        jetpackButtonRect.contains(positionOffset);
  }
}
