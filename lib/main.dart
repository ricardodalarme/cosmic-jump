import 'dart:io';

import 'package:cosmic_jump/app/pages/splash/view/splash_page.dart';
import 'package:cosmic_jump/utils/screen_size.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortraitUpOnly();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowTitle('Cosmic Jump');

    setWindowMaxSize(screenSize);
    setWindowMinSize(screenSize);
  }

  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}
