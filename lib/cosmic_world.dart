import 'dart:async';

import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/data/items.dart';
import 'package:cosmic_jump/features/checkpoint/checkpoint_component.dart';
import 'package:cosmic_jump/features/dialog/dialogue_controller_component.dart';
import 'package:cosmic_jump/features/fog/fog_component.dart';
import 'package:cosmic_jump/features/light/light_component.dart';
import 'package:cosmic_jump/features/map/map_item_component.dart';
import 'package:cosmic_jump/features/meteor/meteor_manager.dart';
import 'package:cosmic_jump/features/planet/planet_model.dart';
import 'package:cosmic_jump/features/player/player_component.dart';
import 'package:cosmic_jump/features/trap/saw_component.dart';
import 'package:cosmic_jump/pages/game/hud/back_button.dart';
import 'package:cosmic_jump/pages/game/hud/main_hud.dart';
import 'package:cosmic_jump/utils/collision_block.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import 'package:jenny/jenny.dart';

class CosmicWorld extends World with HasGameRef<CosmicJump> {
  CosmicWorld({
    required this.planet,
  }) : super(priority: 1);

  final PlanetModel planet;

  late final TiledComponent level;
  final List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('${planet.name}.tmx', Vector2.all(16));

    add(level);

    _spawningObjects();
    _addCollisions();

    if (planet.fog != null) {
      add(FogComponent(planet.fog!));
    }

    if (planet.hasMeteorShower) {
      add(MeteorManager(this));
    }

    double radius = 40;

    if (game.player.hasNightVision) {
      radius = 100;
    }

    final lightSources = [
      LightSource(position: Vector2(0, 0), radius: radius),
    ];
    final lightAndDarknessComponent = LightAndDarknessComponent(
      size: game.size + Vector2(0, 50),
      lightSources: lightSources,
      player: game.player,
      visibility: planet.visibility,
    );

    add(lightAndDarknessComponent);

    _addHud();
    await _startDialogue();

    super.onLoad();
  }

  Future<void> _startDialogue() async {
    final image = game.images.fromCache('Planets/Pictures/${planet.name}.png');
    final background = SpriteComponent.fromImage(
      image,
      position: Vector2(
        game.size.x / 2 - image.width / 2,
        game.size.y / 2.5 - image.height / 2,
      ),
    );
    game.camera.viewport.add(background);
    final dialogueControllerComponent = DialogueControllerComponent();
    add(dialogueControllerComponent);

    final yarnProject = YarnProject();
    yarnProject
        .parse(await rootBundle.loadString('assets/yarn/${planet.name}.yarn'));
    final dialogueRunner = DialogueRunner(
      yarnProject: yarnProject,
      dialogueViews: [dialogueControllerComponent],
    );
    await dialogueRunner.startDialogue('Description');
    game.camera.viewport.remove(background);
  }

  void _addHud() {
    addAll([
      MainHud(),
      BackButton(),
      //PauseButton(),
    ]);
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer == null) return;

    for (final spawnPoint in spawnPointsLayer.objects) {
      final position = Vector2(spawnPoint.x, spawnPoint.y);
      final size = Vector2(spawnPoint.width, spawnPoint.height);

      switch (spawnPoint.type) {
        case 'Player':
          game.player = PlayerComponent()
            ..position = position
            ..scale.x = 1;

          add(game.player);
        case 'Fruit':
          final itemIndex = items.indexWhere(
            (item) => item.name == spawnPoint.name,
          );
          if (itemIndex == -1) {
            break;
          }
          final item = items[itemIndex];
          final mapItem = MapItemComponent(
            item: item,
            position: position,
            size: size,
          );
          add(mapItem);
        case 'Saw':
          final isVertical =
              spawnPoint.properties.getValue<bool>('isVertical')!;
          final offNeg = spawnPoint.properties.getValue<double>('offNeg')!;
          final offPos = spawnPoint.properties.getValue<double>('offPos')!;
          final saw = SawComponent(
            isVertical: isVertical,
            offNeg: offNeg,
            offPos: offPos,
            position: position,
            size: size,
          );
          add(saw);
        case 'Checkpoint':
          final checkpoint = CheckpointComponent(
            position: position,
            size: size,
          );
          add(checkpoint);
        default:
          continue;
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer == null) return;

    for (final collision in collisionsLayer.objects) {
      switch (collision.class_) {
        case 'Platform':
          final platform = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
            isPlatform: true,
          );
          collisionBlocks.add(platform);
          add(platform);
        case 'Ground':
          final platform = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
            isGround: true,
          );
          collisionBlocks.add(platform);
          add(platform);
        default:
          final block = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          collisionBlocks.add(block);
          add(block);
      }
    }
    game.player.collisionBlocks = collisionBlocks;
  }
}
