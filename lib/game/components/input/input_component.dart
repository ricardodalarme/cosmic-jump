import 'dart:io';
import 'dart:ui';

import 'package:cosmic_jump/game/components/input/input.dart';
import 'package:cosmic_jump/game/components/input/keyboard_input_component.dart';
import 'package:cosmic_jump/game/components/input/tap_input_component.dart';
import 'package:flame/components.dart';
import 'package:leap/leap.dart';

/// Combines touch screen and keyboard input into one API.
class InputComponent extends Component
    with HasGameRef<LeapGame>, AppLifecycleAware {
  late final Input _effectiveInput;

  InputComponent() {
    if (Platform.isAndroid || Platform.isIOS) {
      _effectiveInput = TapInputComponent();
    } else {
      _effectiveInput = KeyboardInputComponent();
    }

    add(_effectiveInput);
  }

  @override
  void appLifecycleStateChanged(
    AppLifecycleState previous,
    AppLifecycleState current,
  ) {
    // When the app is backgrounded or foregrounded, reset inputs to avoid
    // any weirdness with tap/key state getting out of sync.
    _effectiveInput.reset();
  }

  bool get _appFocused =>
      game.appState == AppLifecycleState.resumed ||
      game.appState == AppLifecycleState.detached;

  bool get isPressedLeft => _appFocused && _effectiveInput.isPressedLeft;

  bool get isPressedRight => _appFocused && _effectiveInput.isPressedRight;

  bool get isPressedUp => _appFocused && _effectiveInput.isPressedUp;

  bool get isPressedDown => _appFocused && _effectiveInput.isPressedDown;
}
