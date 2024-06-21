import 'package:cosmic_jump/features/item/item_model.dart';

const List<ItemModel> items = [
  JetpackItemModel(
    name: 'Jetpack',
    imagePath: 'Items/Jetpack.png',
    description: 'Permite voar por um curto período de tempo.',
  ),
  EquipmentItemModel(
    name: 'Máscara de Gás',
    imagePath: 'Items/AntiPoisonMask.png',
    poisonResistance: 1,
    description: 'Aumenta a resistência a gases tóxicos.',
  ),
  VisibilityItemModel(
    name: 'Óculos de Visão Noturna',
    imagePath: 'Items/Glasses.png',
    description: 'Aumenta a visibilidade em ambientes escuros.',
  ),
];
