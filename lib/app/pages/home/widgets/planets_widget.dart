import 'dart:async';
import 'dart:math';

import 'package:cosmic_jump/app/pages/details/view/details_page.dart';
import 'package:cosmic_jump/app/pages/game/view/game_page.dart';
import 'package:cosmic_jump/app/pages/home/widgets/circle_indicator.dart';
import 'package:cosmic_jump/app/pages/home/widgets/planet_item.dart';
import 'package:cosmic_jump/app/widgets/app_snackbar.dart';
import 'package:cosmic_jump/app/widgets/button.dart';
import 'package:cosmic_jump/constants/colors.dart';
import 'package:cosmic_jump/data/models/planet_model.dart';
import 'package:cosmic_jump/data/resources/account.dart';
import 'package:cosmic_jump/data/resources/planets.dart';
import 'package:flutter/material.dart';

class PlanetsWidget extends StatefulWidget {
  const PlanetsWidget({super.key});

  @override
  State<PlanetsWidget> createState() => _PlanetsWidgetState();
}

class _PlanetsWidgetState extends State<PlanetsWidget> {
  int currentIndex = 0;
  int angle = 0;
  int planet1 = 0;
  int planet2 = 0;
  int index = 0;
  String direction = '';

  void nextPlanet() {
    updatePlanetsAndDirection('next');
    rotatePlanets(10, 360);
  }

  void prevPlanet() {
    updatePlanetsAndDirection('prev');
    rotatePlanets(-10, 0);
  }

  void updatePlanetsAndDirection(String newDirection) {
    if (direction == newDirection) {
      if ((currentIndex % planets.length).isEven) {
        planet2 = planet2 % planets.length + (newDirection == 'next' ? 2 : -2);
      } else {
        planet1 = planet1 % planets.length + (newDirection == 'next' ? 2 : -2);
      }
    } else {
      resetPlanetIndices();
      if ((currentIndex % planets.length).isEven) {
        planet1 = currentIndex % planets.length;
        planet2 =
            (planet2 + (newDirection == 'next' ? 1 : -1)) % planets.length;
      } else {
        planet1 =
            (planet1 + (newDirection == 'next' ? 1 : -1)) % planets.length;
        planet2 = currentIndex % planets.length;
      }
    }
    setState(() {
      angle = angle.abs() == 360 ? 0 : angle.abs();
      index += (newDirection == 'next' ? 1 : -1);

      if (index < 0) {
        index = planets.length - 1;
      } else if (index >= planets.length) {
        index = 0;
      }

      currentIndex = index % planets.length;
      direction = newDirection;
    });
  }

  void resetPlanetIndices() {
    setState(() {
      planet2 = currentIndex;
      planet1 = currentIndex;
    });
  }

  void rotatePlanets(int step, int stopValue) {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final stop = index.isEven ? stopValue : 180;
      if (angle.abs() == stop) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          angle += step;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final planet = planets[index];

    return GestureDetector(
      onTapUp: (details) {
        final dx = details.localPosition.dx;
        if (dx < size.width / 2) {
          prevPlanet();
        } else {
          nextPlanet();
        }
      },
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          CircleIndicator(
            currentIndex: currentIndex,
            length: planets.length,
          ),
          PlanetName(
            planet: planet,
            angle: angle,
          ),
          PlanetDisplay(
            currentIndex: currentIndex,
            angle: angle,
            planet1: planet1,
            planet2: planet2,
            nextPlanet: nextPlanet,
            prevPlanet: prevPlanet,
          ),
          // play button
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: planet.isPlayable ? 1 : 0,
                child: Button(
                  onPressed: () => Navigator.push(
                    context,
                    GamePage.route(planets[index]),
                  ).then((unlockedPlanet) {
                    if (unlockedPlanet != null) {
                      setState(() {});
                      if (mounted) {
                        AppSnackbar(
                          'Parabéns! Você desbloqueou o planeta ${unlockedPlanet.name}!',
                          // ignore: use_build_context_synchronously
                        ).show(context);
                      }
                    }
                  }),
                  text: 'Jogar',
                  isEnabled: account.unlockedPlanets.contains(planet.id),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanetName extends StatelessWidget {
  const PlanetName({
    required this.planet,
    required this.angle,
    super.key,
  });

  final PlanetModel planet;
  final int angle;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 110,
      child: AnimatedOpacity(
        duration: const Duration(microseconds: 200),
        curve: Curves.easeInOut,
        opacity: angle.abs() <= 180 && angle.abs() > 0
            ? angle.abs() / 180
            : angle.abs() > 180 && angle.abs() <= 360
                ? angle.abs() / 360
                : (180 - angle.abs()) / 180,
        child: Hero(
          tag: planet.name,
          child: Material(
            color: transparent,
            child: Column(
              children: [
                Text(
                  planet.name.toUpperCase(),
                  style: const TextStyle(
                    color: white,
                    letterSpacing: 1.2,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  planet.title,
                  style: const TextStyle(
                    color: white,
                    fontSize: 14,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlanetDisplay extends StatelessWidget {
  const PlanetDisplay({
    required this.currentIndex,
    required this.angle,
    required this.planet1,
    required this.planet2,
    required this.nextPlanet,
    required this.prevPlanet,
    super.key,
  });

  final int currentIndex;
  final int angle;
  final int planet1;
  final int planet2;
  final VoidCallback nextPlanet;
  final VoidCallback prevPlanet;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: 500,
      width: 620,
      bottom: 0,
      child: GestureDetector(
        onLongPress: () => Navigator.push(
          context,
          DetailsPage.route(planets[currentIndex]),
        ),
        child: Hero(
          tag: planets[currentIndex].id,
          child: PlanetRotation(
            angle: angle,
            planet1: planet1,
            planet2: planet2,
          ),
        ),
      ),
    );
  }
}

class PlanetRotation extends StatelessWidget {
  const PlanetRotation({
    required this.angle,
    required this.planet1,
    required this.planet2,
    super.key,
  });

  final int angle;
  final int planet1;
  final int planet2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 620,
      color: transparent,
      child: Transform.rotate(
        angle: -angle * pi / 180,
        alignment: Alignment.bottomCenter,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              width: 620,
              height: 620,
              top: 0,
              child: Transform.rotate(
                angle: -angle * pi / 180,
                child: AnimatedOpacity(
                  opacity: angle.abs() > 180 && angle.abs() <= 360
                      ? angle.abs() / 360
                      : angle.abs() < 180
                          ? (180 - angle.abs()) / 180
                          : 0,
                  duration: const Duration(milliseconds: 900),
                  child: PlanetItem(
                    id: planets[planet1 % planets.length].id,
                  ),
                ),
              ),
            ),
            Positioned(
              width: 620,
              height: 620,
              bottom: -500,
              child: Transform.rotate(
                angle: -angle * pi / 180,
                child: AnimatedOpacity(
                  opacity: angle.abs() > 0 && angle.abs() <= 180
                      ? angle.abs() / 180
                      : 0,
                  duration: const Duration(milliseconds: 900),
                  child: PlanetItem(
                    id: planets[planet2 % planets.length].id,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
