import 'package:cosmic_jump/features/item/item.dart';

const List<Item> items = [
  EquipmentItem(name: 'Gravity Boots', imagePath: 'Items/GravityBoots.png'),
  JetpackItem(name: 'Jetpack', imagePath: 'Items/Jetpack.png'),
  EquipmentItem(
    name: 'AntiPoisonMask',
    imagePath: 'Items/AntiPoisonMask.png',
    poisonResistance: 1,
  ),
];
