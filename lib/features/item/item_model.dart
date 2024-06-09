class ItemModel {
  final String name;
  final String imagePath;
  final String description;

  const ItemModel({
    required this.name,
    required this.imagePath,
    required this.description,
  });
}

final class EquipmentItemModel extends ItemModel {
  final double poisonResistance;

  const EquipmentItemModel({
    required super.name,
    required super.imagePath,
    required super.description,
    this.poisonResistance = 0,
  });
}

final class JetpackItemModel extends EquipmentItemModel {
  const JetpackItemModel({
    required super.name,
    required super.imagePath,
    required super.description,
  });
}
