import 'dart:async';

import 'package:cosmic_jump/cosmic_world.dart';
import 'package:cosmic_jump/data/items.dart';
import 'package:cosmic_jump/data/planets.dart';
import 'package:cosmic_jump/features/account/account_model.dart';
import 'package:cosmic_jump/features/player/player_component.dart';
import 'package:cosmic_jump/pages/game/hud/jetpack_button.dart';
import 'package:cosmic_jump/pages/game/hud/jump_button.dart';
import 'package:cosmic_jump/pages/inventory/inventory_page.dart';
import 'package:cosmic_jump/pages/menu/menu_page.dart';
import 'package:cosmic_jump/pages/pause/pause_page.dart';
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

  final AccountModel account = AccountModel();
  PlayerComponent player = PlayerComponent();
  late JoystickComponent joystick;
  bool showControls = false;
  bool playSounds = false;
  double soundVolume = 1;
  int currentLevelIndex = -1;

  int starsCollected = 0;

  static const double maxHealth = 5;

  late final RouterComponent router;

  @override
  FutureOr<void> onLoad() async {
    add(
      router = RouterComponent(
        routes: {
          'home': Route(MenuPage.new),
          'pause': PauseRoute(),
          'inventory': Route(InventoryPage.new),
        },
        initialRoute: 'home',
      ),
    );
    // Load all images into cache
    await images.loadAllImages();

    if (showControls) {
      addJoystick();
      await addAll([
        JumpButton(),
        JetpackButton(),
      ]);
    }

    // Add initial items for demonstration
    account.inventory.addItem(items[0]);
    account.inventory.addItem(items[1]);
    account.inventory.addItem(items[2]);

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
    if (currentLevelIndex < planets.length) {
      loadLevel(currentLevelIndex + 1);
    } else {
      loadLevel(0);
    }
  }

  void loadLevel(int index) {
    removeWhere((component) => component is CosmicWorld);

    currentLevelIndex = index;
    final CosmicWorld world = CosmicWorld(
      planet: planets[index],
    );
    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 360,
      height: 640,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
  }

  void unloadCurrentLevel() {
    removeWhere((component) => component is CosmicWorld);
  }
}
