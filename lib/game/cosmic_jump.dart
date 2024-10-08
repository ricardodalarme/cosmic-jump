import 'package:cosmic_jump/constants/screen_size.dart';
import 'package:cosmic_jump/data/models/planet_model.dart';
import 'package:cosmic_jump/data/repositories/account_repository.dart';
import 'package:cosmic_jump/data/repositories/settings_repository.dart';
import 'package:cosmic_jump/data/resources/account.dart';
import 'package:cosmic_jump/data/resources/planets.dart';
import 'package:cosmic_jump/data/resources/settings.dart';
import 'package:cosmic_jump/game/components/block/block_component.dart';
import 'package:cosmic_jump/game/components/checkpoint/checkpoint_component.dart';
import 'package:cosmic_jump/game/components/coin/coin_component.dart';
import 'package:cosmic_jump/game/components/dialog/dialogue_controller_component.dart';
import 'package:cosmic_jump/game/components/fog/fog_component.dart';
import 'package:cosmic_jump/game/components/hud/back_button.dart';
import 'package:cosmic_jump/game/components/hud/main_hud.dart';
import 'package:cosmic_jump/game/components/input/input_component.dart';
import 'package:cosmic_jump/game/components/light/lighting_component.dart';
import 'package:cosmic_jump/game/components/meteor/meteor_manager.dart';
import 'package:cosmic_jump/game/components/platforms/falling_platform_component.dart';
import 'package:cosmic_jump/game/components/platforms/moving_platform_component.dart';
import 'package:cosmic_jump/game/components/player/player_component.dart';
import 'package:cosmic_jump/game/components/traps/spike_component.dart';
import 'package:cosmic_jump/main.dart';
import 'package:flame/camera.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:jenny/jenny.dart';
import 'package:leap/leap.dart';

class CosmicJump extends LeapGame with SingleGameInstance {
  CosmicJump(this.planet) : super(tileSize: _tileSize, world: LeapWorld());

  final PlanetModel planet;
  final yarnProject = YarnProject();
  late PlayerComponent player;
  late final InputComponent input;

  static const double _tileSize = 16;

  Future<void> loadLevel() async {
    final groundTileHandlers = {
      'OneWayTopPlatform': OneWayTopPlatformHandler(),
    };

    const tiledObjectHandlers = {
      'Coin': CoinFactory(),
      'Checkpoint': CheckpointFactory(),
      'Block': BlockFactory(),
      'MovingPlatform': MovingPlatformFactory(),
      'FallingPlatform': FallingPlatformFactory(),
      'Trap': TrapFactory(),
    };

    world.removeAll(world.children);

    return loadWorldAndMap(
      tiledMapPath: '${planet.id}.tmx',
      groundTileHandlers: groundTileHandlers,
      tiledObjectHandlers: tiledObjectHandlers,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Default the camera size to the bounds of the Tiled map.
    camera = CameraComponent.withFixedResolution(
      world: world,
      width: screenWidth,
      height: screenHeight,
    );

    // Load all images into cache
    await images.loadAllImages();
    await _loadDialogs();
  }

  @override
  Future<void> onMount() async {
    super.onMount();
    await loadLevel();

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

    _addInput();
    _addHud();
  }

  @override
  void onMapUnload(LeapMap map) {
    player.removeFromParent();
  }

  @override
  Future<void> onMapLoaded(LeapMap map) async {
    _createPlayer();
    _spawnMap();
    await _startDialogue();
    _spawnPlayer();
  }

  Future<void> completeLevel() async {
    final nextLevel = _getNextLevel();
    if (nextLevel != null) {
      account.unlockedPlanets.add(nextLevel.id);
      await AccountRepository.instance.save(account);
    }

    account.coins += player.coins;
    await AccountRepository.instance.save(account);

    final transition = LeapMapTransition.defaultFactory(this);
    camera.viewport.add(transition);
    await transition.introFinished;

    await navigatorKey.currentState?.maybePop(nextLevel);
  }

  PlanetModel? _getNextLevel() {
    final index = planets.indexOf(planet);

    for (int i = index + 1; i < planets.length; i++) {
      if (planets[i].isPlayable) {
        return planets[i];
      }
    }
    return null;
  }

  void _spawnMap() {
    _spawnFog();
    _spawnLighting();
    _spawnMeteors();

    camera.moveTo(leapMap.playerSpawn);
  }

  void _spawnLighting() {
    final playerLightSource = LightSource(
      position: player.position,
      radius: 40,
    );
    final lightSources = [playerLightSource];
    final lightingComponent = LightingComponent(
      size: world.map.size,
      lightSources: lightSources,
      player: player,
    );

    world.add(lightingComponent);
  }

  void _spawnFog() {
    if (planet.fog != null) {
      world.add(FogComponent(planet.fog!));
    }
  }

  void _createPlayer() {
    player = PlayerComponent(character: account.currentCharacter);
  }

  void _spawnPlayer() {
    world.add(player);
    camera.follow(player);
  }

  void _spawnMeteors() {
    if (planet.hasMeteorShower) {
      world.add(MeteorManager());
    }
  }

  void _addInput() {
    input = InputComponent();
    camera.viewport.add(input);
  }

  void _addHud() {
    camera.viewport.addAll([
      MainHud(),
      BackButton(),
    ]);
  }

  Future<void> _loadDialogs() async {
    await _loadDialog('Welcome');
    await _loadDialog(planet.id);
  }

  Future<void> _loadDialog(String name) async {
    final asset = await rootBundle.loadString('assets/yarn/$name.yarn');
    yarnProject.parse(asset);
  }

  Future<void> _startDialogue() async {
    final dialogueControllerComponent = DialogueControllerComponent();
    camera.viewport.add(dialogueControllerComponent);

    final dialogueRunner = DialogueRunner(
      yarnProject: yarnProject,
      dialogueViews: [dialogueControllerComponent],
    );

    if (settings.showTutorial) {
      await dialogueRunner.startDialogue('Welcome');
      settings.showTutorial = false;
      await SettingsRepository.instance.save(settings);
    }

    await dialogueRunner.startDialogue(planet.id);
  }
}
