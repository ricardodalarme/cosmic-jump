import 'package:cosmic_jump/features/item/item.dart';

final class InventoryItemModel {
  final Item item;
  int quantity;

  InventoryItemModel({
    required this.item,
    this.quantity = 1,
  });
}
