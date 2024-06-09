import 'package:cosmic_jump/features/inventory/inventory_item_model.dart';
import 'package:cosmic_jump/features/item/item_model.dart';

class InventoryManager {
  final List<InventoryItemModel?> _items = List.filled(_maxItems, null);

  List<InventoryItemModel?> get items => _items;

  static const _maxItems = 30;

  void addItem(ItemModel item, [int quantity = 1]) {
    final existingItem = _items.firstWhere(
      (element) => element?.item == item,
      orElse: () => null,
    );

    if (existingItem != null) {
      existingItem.quantity += quantity;
      return;
    }

    final slot = _items.indexOf(null);
    if (slot != -1) {
      _items[slot] = InventoryItemModel(item: item, quantity: quantity);
    }
  }

  void removeItem(int slotId, [int quantity = -1]) {
    final item = _items[slotId];
    if (item == null) return;

    if (quantity == -1 || item.quantity <= quantity) {
      _items[slotId] = null;
    } else {
      item.quantity -= quantity;
    }
  }
}
