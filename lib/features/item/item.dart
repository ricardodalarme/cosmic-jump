class Item {
  final String name;
  final String imagePath;

  const Item({
    required this.name,
    required this.imagePath,
  });
}

final class EquipmentItem extends Item {
  final double poisonResistance;

  const EquipmentItem({
    required super.name,
    required super.imagePath,
    this.poisonResistance = 0,
  });
}

final class JetpackItem extends EquipmentItem {
  const JetpackItem({
    required super.name,
    required super.imagePath,
  });
}
