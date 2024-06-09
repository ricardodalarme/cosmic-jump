import 'package:cosmic_jump/features/item/item_model.dart';

final class InventoryItemModel {
  final ItemModel item;
  int quantity;

  InventoryItemModel({
    required this.item,
    this.quantity = 1,
  });
}
