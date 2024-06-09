import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortraitUpOnly();

  final game = CosmicJump();
  runApp(
    GameWidget(game: kDebugMode ? CosmicJump() : game),
  );
}
