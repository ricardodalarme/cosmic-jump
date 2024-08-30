import 'package:cosmic_jump/game/cosmic_jump.dart';
import 'package:cosmic_jump/models/planet_model.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({required this.planet, super.key});

  final PlanetModel planet;

  static Route<PlanetModel> route(PlanetModel planet) {
    return PageRouteBuilder<PlanetModel>(
      pageBuilder: (context, animation, secondaryAnimation) => GamePage(
        planet: planet,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final CosmicJump _game;

  @override
  void initState() {
    super.initState();
    _game = CosmicJump(widget.planet);
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _game);
  }
}
