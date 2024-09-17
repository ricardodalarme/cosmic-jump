import 'dart:io';

import 'package:cosmic_jump/app/pages/home/view/home_page.dart';
import 'package:cosmic_jump/app/pages/splash/view/splash_page.dart';
import 'package:cosmic_jump/constants/screen_size.dart';
import 'package:cosmic_jump/data/repositories/account_repository.dart';
import 'package:cosmic_jump/data/repositories/settings_repository.dart';
import 'package:cosmic_jump/data/resources/account.dart';
import 'package:cosmic_jump/data/resources/settings.dart';
import 'package:cosmic_jump/services/storage_service.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    Flame.device.fullScreen(),
    Flame.device.setPortraitUpOnly(),
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []),
    StorageService.instance.initialize(),
  ]);

  account = AccountRepository.instance.get();
  settings = SettingsRepository.instance.get();

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
      home: settings.isFirstTime ? const SplashPage() : const HomePage(),
    );
  }
}
