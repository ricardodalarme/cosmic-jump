class ItemModel {
  final String name;
  final String imagePath;
  final String description;
  final int animationFrames;

  const ItemModel({
    required this.name,
    required this.imagePath,
    required this.description,
    this.animationFrames = 1,
  });
}

final class EquipmentItemModel extends ItemModel {
  final double poisonResistance;

  const EquipmentItemModel({
    required super.name,
    required super.imagePath,
    required super.description,
    this.poisonResistance = 0,
    super.animationFrames,
  });
}

final class JetpackItemModel extends EquipmentItemModel {
  const JetpackItemModel({
    required super.name,
    required super.imagePath,
    required super.description,
    super.animationFrames,
  });
}
