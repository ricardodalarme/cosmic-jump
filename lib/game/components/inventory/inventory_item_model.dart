import 'package:cosmic_jump/models/item_model.dart';

final class InventoryItemModel {
  final ItemModel item;
  int quantity;

  InventoryItemModel({
    required this.item,
    this.quantity = 1,
  });
}
