import 'package:cosmic_jump/game/utils/collision_block.dart';
import 'package:cosmic_jump/game/utils/custom_hitbox.dart';
import 'package:flame/components.dart';

bool checkCollision(
  PositionComponent component,
  CustomHitbox hitbox,
  CollisionBlock block,
) {
  final playerX = component.position.x + hitbox.offsetX;
  final playerY = component.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = component.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX;
}
