import 'dart:math';

import 'package:cosmic_jump/game/components/meteor/meteor_component.dart';
import 'package:flame/components.dart';

class MeteorManager extends Component with HasGameRef {
  final Random _random = Random();
  static const double _spawnInterval = 1; // Seconds
  double _spawnTimer = 0;

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
    final meteor = MeteorComponent()
      ..position =
          Vector2(_random.nextDouble() * gameRef.camera.viewport.size.x, 0);
    add(meteor);
  }
}
