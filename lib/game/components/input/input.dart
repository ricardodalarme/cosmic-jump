import 'package:flame/components.dart';

mixin Input on Component {
  bool get isPressedLeft;

  bool get isPressedRight;

  bool get isPressedUp;

  bool get isPressedDown;

  void reset();
}
