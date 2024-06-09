class Item {
  final String name;
  final String imagePath;
  final String description;

  const Item({
    required this.name,
    required this.imagePath,
    required this.description,
  });
}

final class EquipmentItem extends Item {
  final double poisonResistance;

  const EquipmentItem({
    required super.name,
    required super.imagePath,
    required super.description,
    this.poisonResistance = 0,
  });
}

final class JetpackItem extends EquipmentItem {
  const JetpackItem({
    required super.name,
    required super.imagePath,
    required super.description,
  });
}
