import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/features/health/health_component.dart';
import 'package:flame/components.dart';

class HealthHud extends PositionComponent with HasGameReference<CosmicJump> {
  HealthHud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  @override
  Future<void> onLoad() async {
    for (var i = 0; i < CosmicJump.maxHealth; i++) {
      final positionX = 40 * i;
      await add(
        HealthComponent(
          heartNumber: i,
          position: Vector2(positionX.toDouble(), 20),
          size: Vector2.all(32),
          anchor: Anchor.center,
        ),
      );
    }

    return super.onLoad();
  }
}
