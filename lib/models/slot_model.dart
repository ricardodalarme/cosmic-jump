final class SlotModel<T> {
  final T value;
  int quantity;

  SlotModel({
    required this.value,
    this.quantity = 1,
  });
}
