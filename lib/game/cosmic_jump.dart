import 'dart:async';

import 'package:cosmic_jump/game/components/hud/jetpack_button.dart';
import 'package:cosmic_jump/game/components/hud/jump_button.dart';
import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:cosmic_jump/game/cosmic_world.dart';
import 'package:cosmic_jump/game/utils/screen_size.dart';
import 'package:cosmic_jump/main.dart';
import 'package:cosmic_jump/models/planet_model.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';

class CosmicJump extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF0d0814);
  late CameraComponent cam;

  // final AccountModel account = AccountModel();
  PlayerComponent player = PlayerComponent();
  late JoystickComponent joystick;
  bool showControls = false;
  bool playSounds = false;
  double soundVolume = 1;

  int starsCollected = 0;

  static const double maxHealth = 5;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    if (showControls) {
      addJoystick();
      await addAll([
        JumpButton(),
        JetpackButton(),
      ]);
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
      default:
        player.horizontalMovement = 0;
    }
  }

  void loadNextLevel() {
    unloadCurrentLevel();
    navigatorKey.currentState?.pop();
  }

  void loadLevel(PlanetModel planet) {
    removeWhere((component) => component is CosmicWorld);

    final CosmicWorld world = CosmicWorld(
      planet: planet,
    );
    cam = CameraComponent.withFixedResolution(
      world: world,
      width: screenWidth,
      height: screenHeight,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
  }

  void unloadCurrentLevel() {
    removeWhere((component) => component is CosmicWorld);
  }
}
