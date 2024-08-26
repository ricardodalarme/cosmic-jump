import 'package:cosmic_jump/models/item_model.dart';
import 'package:cosmic_jump/models/slot_model.dart';

class InventoryManager {
  final List<SlotModel<ItemModel>?> _items = List.filled(_maxItems, null);

  List<SlotModel<ItemModel>?> get items => _items;

  static const _maxItems = 30;

  void addItem(ItemModel item, [int quantity = 1]) {
    final existingItem = _items.firstWhere(
      (element) => element?.value == item,
      orElse: () => null,
    );

    if (existingItem != null) {
      existingItem.quantity += quantity;
      return;
    }

    final slot = _items.indexOf(null);
    if (slot != -1) {
      _items[slot] = SlotModel(value: item, quantity: quantity);
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
