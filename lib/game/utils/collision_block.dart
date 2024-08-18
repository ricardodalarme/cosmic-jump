import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  final bool isPlatform;
  final bool isGround;

  CollisionBlock({
    super.position,
    super.size,
    this.isPlatform = false,
    this.isGround = false,
  });
}
