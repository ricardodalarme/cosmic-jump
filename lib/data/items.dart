import 'package:cosmic_jump/features/item/item.dart';

const List<Item> items = [
  EquipmentItem(
    name: 'Gravity Boots',
    imagePath: 'Items/GravityBoots.png',
    description: 'Increase jump height',
  ),
  JetpackItem(
    name: 'Jetpack',
    imagePath: 'Items/Jetpack.png',
    description: 'Fly',
  ),
  EquipmentItem(
    name: 'AntiPoisonMask',
    imagePath: 'Items/AntiPoisonMask.png',
    poisonResistance: 1,
    description: 'Resist poison',
  ),
];
