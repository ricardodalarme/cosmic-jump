import 'dart:async';

import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/features/checkpoint/checkpoint_component.dart';
import 'package:cosmic_jump/features/equipment/hud/equipment_hud.dart';
import 'package:cosmic_jump/features/fog/fog_component.dart';
import 'package:cosmic_jump/features/health/hud/health_hud.dart';
import 'package:cosmic_jump/features/jetpack/hud/jetpack_energy_hud.dart';
import 'package:cosmic_jump/features/map/map_item_component.dart';
import 'package:cosmic_jump/features/meteor/meteor_manager.dart';
import 'package:cosmic_jump/features/planet/planet_model.dart';
import 'package:cosmic_jump/features/player/player_component.dart';
import 'package:cosmic_jump/features/trap/saw_component.dart';
import 'package:cosmic_jump/pages/game/hud/back_button.dart';
import 'package:cosmic_jump/pages/game/hud/pause_button.dart';
import 'package:cosmic_jump/utils/collision_block.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class CosmicWorld extends World with HasGameRef<CosmicJump> {
  CosmicWorld({
    required this.planet,
  }) : super(priority: 1);

  final PlanetModel planet;

  late final TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

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

    _addHud();
    return super.onLoad();
  }

  void _addHud() {
    addAll([
      if (game.player.jetpack != null) JetpackEnergyHud(game.player.jetpack!),
      BackButton(),
      PauseButton(),
      EquipmentHud(
        playerEquipment: game.account.equipments,
        position: Vector2(300, 10),
      ),
      HealthHud(position: Vector2(30, 55)),
    ]);
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            game.player = PlayerComponent()
              ..position = Vector2(spawnPoint.x, spawnPoint.y)
              ..scale.x = 1;

            add(game.player);
          case 'Fruit':
            final fruit = MapItemComponent(
              item: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
          case 'Saw':
            final isVertical =
                spawnPoint.properties.getValue<bool>('isVertical')!;
            final offNeg = spawnPoint.properties.getValue<double>('offNeg')!;
            final offPos = spawnPoint.properties.getValue<double>('offPos')!;
            final saw = SawComponent(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
          case 'Checkpoint':
            final checkpoint = CheckpointComponent(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
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
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    game.player.collisionBlocks = collisionBlocks;
  }
}
