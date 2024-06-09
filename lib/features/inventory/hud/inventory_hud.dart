import 'dart:ui';

import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/features/inventory/inventory_item_model.dart';
import 'package:cosmic_jump/features/inventory/inventory_manager.dart';
import 'package:cosmic_jump/features/item/item.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/image_composition.dart';

class DraggableInventoryItem extends Component with HasGameRef<CosmicJump> {
  InventoryItemModel? item;
  Vector2 position = Vector2.zero();

  DraggableInventoryItem() : super(priority: 100);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (item == null) {
      return;
    }
    final imagePath = item!.item.imagePath;
    final Image image = game.images.fromCache(imagePath);
    canvas.drawImage(image, position.toOffset(), Paint());
  }
}

class InventoryEquipmentHUD extends PositionComponent
    with HasGameRef<CosmicJump>, TapCallbacks {
  InventoryEquipmentHUD({
    required super.position,
  }) : super(priority: 10);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(50, 150);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    // get equipment item and equip it
    final slotIndex = getSlotIndex(event.localPosition);
    if (slotIndex != -1) {
      game.account.equipments.unequip(slotIndex);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()..color = const Color(0xFF000000).withOpacity(0.35);

    final paint2 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255).withBlue(255)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final itemSize = Vector2(50, 50);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    final equipments = game.account.equipments.equippedItems;

    for (int i = 0; i < equipments.length; i++) {
      final itemPosition = Vector2(
        0,
        i * itemSize.y,
      );

      final itemRect = itemPosition & itemSize;
      canvas.drawRect(itemRect, paint2);

      final equipment = equipments[i];

      if (equipment != null) {
        final image = game.images.fromCache(equipment.imagePath);
        canvas.drawImage(
          image,
          itemPosition.toOffset() + const Offset(10, 10),
          Paint(),
        );
      }
    }
  }

  int getSlotIndex(Vector2 position) {
    if (position.y < 0 || position.y >= size.y) {
      return -1;
    }

    return position.y ~/ 50;
  }
}

class InventoryComponent extends PositionComponent
    with HasGameRef<CosmicJump>, HasVisibility, DragCallbacks {
  final InventoryManager inventory;
  int? draggedItemIndex;
  Vector2? lastDragPosition;

  late DraggableInventoryItem _draggableInventoryItem;
  late InventoryEquipmentHUD _inventoryEquipmentHUD;

  InventoryComponent(this.inventory);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(315, 375);
    position = Vector2(0, 70);

    _draggableInventoryItem = DraggableInventoryItem();
    _inventoryEquipmentHUD = InventoryEquipmentHUD(position: Vector2(330, 0));

    await addAll(
      [
        _draggableInventoryItem,
        _inventoryEquipmentHUD,
      ],
    );
  }

  // render as a grid of items
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color(0xFF000000).withOpacity(0.5);
    canvas.drawRect(size.toRect(), paint);
    final itemSize = Vector2(50, 50);
    const margin = 10;
    const rows = 5;
    const cols = 5;
    final items = inventory.items;
    for (var i = 0; i < items.length; i++) {
      final row = i ~/ rows;
      final col = i % cols;
      final item = items[i];

      final itemPosition = Vector2(
        col * (itemSize.x + margin) + margin,
        row * (itemSize.y + margin) + margin,
      );

      final itemRect = itemPosition & itemSize;

      // if item is equipped, draw a border around it
      if (item != null &&
          game.account.equipments.equippedItems.contains(item.item)) {
        final paint2 = Paint()
          ..color = const Color.fromARGB(255, 255, 255, 255).withBlue(255)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
        canvas.drawRect(itemRect, paint2);
      }
      canvas.drawRect(itemRect, paint);

      if (item != null) {
        final imagePath = item.item.imagePath;
        final Image image = game.images.fromCache(imagePath);
        canvas.drawImage(image, itemPosition.toOffset(), Paint());
      }
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    final items = inventory.items;
    final itemSize = Vector2(50, 50);
    const margin = 10;
    const rows = 5;
    const cols = 5;

    final localPosition = event.localPosition;
    for (var i = 0; i < items.length; i++) {
      final row = i ~/ rows;
      final col = i % cols;
      final itemPosition = Vector2(
        col * (itemSize.x + margin) + margin,
        row * (itemSize.y + margin) + margin,
      );

      final itemRect = itemPosition & itemSize;
      if (itemRect.contains(localPosition.toOffset())) {
        draggedItemIndex = i;
        break;
      }
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (draggedItemIndex != null) {
      lastDragPosition = event.localStartPosition;
      final localPosition = lastDragPosition!;
      final item = inventory.items[draggedItemIndex!];
      if (item != null) {
        final itemSize = Vector2(50, 50);
        final newPosition = localPosition - itemSize / 2 + position;

        _draggableInventoryItem.position = newPosition;
        _draggableInventoryItem.item = item;
      }
    }
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (draggedItemIndex != null && lastDragPosition != null) {
      final itemSize = Vector2(50, 50);
      const margin = 10;
      const rows = 5;
      const cols = 5;

      final localPosition = lastDragPosition!;
      int newSlot = -1;

      final currentItem = inventory.items[draggedItemIndex!]?.item;

      if (currentItem is EquipmentItem) {
        // check if we are dropping on the equipment HUD and equip the item
        final equipmentHudRect = _inventoryEquipmentHUD.toRect();
        if (equipmentHudRect.contains(localPosition.toOffset())) {
          if (!game.account.equipments.equippedItems.contains(currentItem)) {
            final slotIndex =
                _inventoryEquipmentHUD.getSlotIndex(localPosition);
            game.account.equipments.equip(currentItem, slotIndex);
          }

          draggedItemIndex = null;
          lastDragPosition = null;
          _draggableInventoryItem.item = null;
          return;
        }
      }

      for (var i = 0; i < inventory.items.length; i++) {
        final row = i ~/ rows;
        final col = i % cols;
        final itemPosition = Vector2(
          col * (itemSize.x + margin) + margin,
          row * (itemSize.y + margin) + margin,
        );

        final itemRect = itemPosition & itemSize;
        if (itemRect.contains(localPosition.toOffset())) {
          newSlot = i;
          break;
        }
      }

      if (newSlot != -1 && newSlot != draggedItemIndex) {
        final draggedItem = inventory.items[draggedItemIndex!];
        inventory.items[draggedItemIndex!] = inventory.items[newSlot];
        inventory.items[newSlot] = draggedItem;
      }
    }

    draggedItemIndex = null;
    lastDragPosition = null;
    _draggableInventoryItem.item = null;
    super.onDragEnd(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    draggedItemIndex = null;
    lastDragPosition = null;
    _draggableInventoryItem.item = null;
    super.onDragCancel(event);
  }
}
