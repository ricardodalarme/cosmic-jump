import 'package:cosmic_jump/game/components/block/block_component.dart';
import 'package:cosmic_jump/game/components/checkpoint/checkpoint_component.dart';
import 'package:cosmic_jump/game/components/coin/coin_component.dart';
import 'package:cosmic_jump/game/components/fog/fog_component.dart';
import 'package:cosmic_jump/game/components/hud/back_button.dart';
import 'package:cosmic_jump/game/components/hud/main_hud.dart';
import 'package:cosmic_jump/game/components/light/light_component.dart';
import 'package:cosmic_jump/game/components/meteor/meteor_manager.dart';
import 'package:cosmic_jump/game/components/platforms/moving_platform_component.dart';
import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:cosmic_jump/models/planet_model.dart';
import 'package:cosmic_jump/utils/screen_size.dart';
import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:leap/leap.dart';

class CosmicJump extends LeapGame
    with SingleGameInstance, TapCallbacks, HasKeyboardHandlerComponents {
  CosmicJump(this.planet) : super(tileSize: _tileSize, world: LeapWorld());

  final PlanetModel planet;
  final PlayerComponent player = PlayerComponent();
  late final FourButtonInput input;

  bool playSounds = false;
  double soundVolume = 1;

  static const double _tileSize = 16;

  Future<void> _loadLevel() async {
    final groundTileHandlers = {
      'OneWayTopPlatform': OneWayTopPlatformHandler(),
    };

    const tiledObjectHandlers = {
      'Coin': CoinFactory(),
      'Checkpoint': CheckpointFactory(),
      'Block': BlockFactory(),
      'MovingPlatform': MovingPlatformFactory(),
    };

    return loadWorldAndMap(
      tiledMapPath: '${planet.id}.tmx',
      groundTileHandlers: groundTileHandlers,
      tiledObjectHandlers: tiledObjectHandlers,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load all images into cache
    await images.loadAllImages();

    // Default the camera size to the bounds of the Tiled map.
    camera = CameraComponent.withFixedResolution(
      world: world,
      width: screenWidth,
      height: screenHeight,
    );

    _addInput();
  }

  @override
  Future<void> onMount() async {
    super.onMount();
    await _loadLevel();

    // Don't let the camera move outside the bounds of the map, inset
    // by half the viewport size to the edge of the camera if flush with the
    // edge of the map.
    final inset = camera.viewport.virtualSize;
    camera.setBounds(
      Rectangle.fromLTWH(
        inset.x / 2,
        inset.y / 2,
        leapMap.width - inset.x,
        leapMap.height - inset.y,
      ),
    );

    _addHud();
  }

  @override
  void onMapUnload(LeapMap map) {
    player.removeFromParent();
  }

  @override
  void onMapLoaded(LeapMap map) {
    _spawnPlayer();
    _spawnMap();
    _spawnAfterDialogue();
  }

  void _spawnMap() {
    double radius = 40;

    if (planet.fog != null) {
      world.add(FogComponent(planet.fog!));
    }

    if (player.hasNightVision) {
      radius = 100;
    }

    final lightSources = [
      LightSource(position: Vector2(0, 0), radius: radius),
    ];
    final lightAndDarknessComponent = LightAndDarknessComponent(
      size: size + Vector2(0, 50),
      lightSources: lightSources,
      player: player,
      visibility: planet.visibility,
    );

    world.add(lightAndDarknessComponent);
  }

  void _spawnPlayer() {
    world.add(player);
    camera.follow(player);
  }

  void _spawnAfterDialogue() {
    if (planet.hasMeteorShower) {
      world.add(MeteorManager());
    }
  }

  void _addInput() {
    input = FourButtonInput(
      keyboardInput: FourButtonKeyboardInput(
        upKeys: {PhysicalKeyboardKey.space},
        downKeys: {PhysicalKeyboardKey.keyX},
      ),
    );
    add(input);
  }

  void _addHud() {
    camera.viewport.addAll([
      MainHud(),
      BackButton(),
    ]);
  }
}
