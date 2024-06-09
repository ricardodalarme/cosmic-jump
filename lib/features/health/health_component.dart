import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/features/health/heart_state.dart';
import 'package:flame/components.dart';

class HealthComponent extends SpriteGroupComponent<HeartState>
    with HasGameReference<CosmicJump> {
  final int heartNumber;

  HealthComponent({
    required this.heartNumber,
    required super.position,
    required super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
  });

  @override
  Future<void> onLoad() async {
    final availableSprite = await game.loadSprite(
      'HUD/health.png',
      srcSize: Vector2.all(32),
    );

    final unavailableSprite = await game.loadSprite(
      'HUD/unhealth.png',
      srcSize: Vector2.all(32),
    );

    sprites = {
      HeartState.available: availableSprite,
      HeartState.unavailable: unavailableSprite,
    };

    current = HeartState.available;
  }

  @override
  void update(double dt) {
    if (game.player.health <= heartNumber) {
      current = HeartState.unavailable;
    } else {
      current = HeartState.available;
    }
    super.update(dt);
  }
}
