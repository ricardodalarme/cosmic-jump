import 'dart:math';

import 'package:cosmic_jump/game/components/meteor/meteor_component.dart';
import 'package:flame/components.dart';

class MeteorManager extends Component with HasGameRef {
  MeteorManager() : super(priority: 99);

  final Random _random = Random();
  static const double _spawnInterval = 1; // Seconds

  double _spawnTimer = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer += dt;
    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      _spawnMeteor();
    }
  }

  void _spawnMeteor() {
    final meteorPosition = Vector2(
      _random.nextDouble() * gameRef.camera.viewport.size.x,
      0,
    );
    final meteor = MeteorComponent()..position = meteorPosition;
    add(meteor);
  }
}
