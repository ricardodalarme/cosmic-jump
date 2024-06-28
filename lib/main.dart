import 'dart:io';

import 'package:cosmic_jump/cosmic_jump.dart';
import 'package:cosmic_jump/utils/screen_size.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortraitUpOnly();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowTitle('Cosmic Jump');

    setWindowMaxSize(screenSize);
    setWindowMinSize(screenSize);
  }

  final game = CosmicJump();
  runApp(
    GameWidget(game: kDebugMode ? CosmicJump() : game),
  );
}
