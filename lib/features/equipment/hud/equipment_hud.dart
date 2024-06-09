import 'dart:ui';

import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/features/equipment/equipment_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';

class EquipmentHud extends PositionComponent with HasGameRef<CosmicJump> {
  final EquipmentsManager playerEquipment;

  EquipmentHud({
    required this.playerEquipment,
    required super.position,
  }) : super(priority: 100);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()..color = const Color(0xFF000000).withOpacity(0.35);

    final paint2 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255).withBlue(255)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final itemSize = Vector2(50, 50);

    canvas.drawRect(const Rect.fromLTWH(0, 0, 50, 150), paint);
    final equipments = playerEquipment.equippedItems;

    for (int i = 0; i < equipments.length; i++) {
      final itemPosition = Vector2(
        0,
        i * itemSize.y,
      );

      final itemRect = itemPosition & itemSize;
      canvas.drawRect(itemRect, paint2);

      final equipment = equipments[i];

      if (equipment != null) {
        final image = game.images.fromCache(equipment.imagePath);
        canvas.drawImage(
          image,
          itemPosition.toOffset() + const Offset(10, 10),
          Paint(),
        );
      }
    }
  }
}
