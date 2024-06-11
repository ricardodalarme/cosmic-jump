import 'dart:math';

import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/cosmic_world.dart';
import 'package:cosmic_jump/features/meteor/meteor_component.dart';
import 'package:flame/components.dart';

class MeteorManager extends Component with HasGameRef<CosmicJump> {
  final Random _random = Random();
  static const double _spawnInterval = 2; // Seconds
  double _spawnTimer = 0;

  CosmicWorld worldd;

  MeteorManager(this.worldd);

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer += dt;
    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      spawnMeteor();
    }
  }

  void spawnMeteor() {
    final meteor = MeteorComponent(worldd)
      ..position =
          Vector2(_random.nextDouble() * gameRef.cam.viewport.size.x, 0);
    add(meteor);
  }
}
