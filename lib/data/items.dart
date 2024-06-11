import 'package:cosmic_jump/features/item/item_model.dart';

const List<ItemModel> items = [
  EquipmentItemModel(
    name: 'Gravity Boots',
    imagePath: 'Items/GravityBoots.png',
    description: 'Increase jump height',
  ),
  JetpackItemModel(
    name: 'Jetpack',
    imagePath: 'Items/Jetpack.png',
    description: 'Fly',
  ),
  EquipmentItemModel(
    name: 'AntiPoisonMask',
    imagePath: 'Items/AntiPoisonMask.png',
    poisonResistance: 1,
    description: 'Resist poison',
  ),
  VisibilityItemModel(
    name: 'Glasses',
    imagePath: 'Items/Glasses.png',
    description: 'Increase visibility during the night',
  ),
];
