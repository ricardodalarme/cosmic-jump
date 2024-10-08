import 'package:cosmic_jump/app/pages/details/widgets/planet_distance.dart';
import 'package:cosmic_jump/app/widgets/fade_in_animation.dart';
import 'package:cosmic_jump/constants/app_colors.dart';
import 'package:cosmic_jump/data/models/planet_model.dart';
import 'package:flutter/material.dart';

class PlanetOverview extends StatelessWidget {
  const PlanetOverview({
    required this.planet,
    super.key,
  });

  final PlanetModel planet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PlanetHeader(planet: planet),
        const SizedBox(height: 24),
        Expanded(child: _PlanetImage(planet: planet)),
        const SizedBox(height: 24),
        PlanetDistance(planet: planet),
      ],
    );
  }
}

class _PlanetHeader extends StatelessWidget {
  const _PlanetHeader({
    required this.planet,
  });

  final PlanetModel planet;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          planet.name.toUpperCase(),
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 42,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          planet.title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 14,
            letterSpacing: 1.2,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _PlanetImage extends StatelessWidget {
  const _PlanetImage({
    required this.planet,
  });

  final PlanetModel planet;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Hero(
          tag: planet.id,
          child: Image.asset(
            'assets/images/Planets/Pictures/${planet.id}.png',
          ),
        ),
        _TemperatureOverlay(temperature: planet.temperature),
      ],
    );
  }
}

class _TemperatureOverlay extends StatelessWidget {
  const _TemperatureOverlay({
    required this.temperature,
  });

  final int temperature;

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      position: const MyAnimation(
        rightAfter: 100,
        rightBefore: -70,
        topAfter: 5,
        topBefore: 5,
      ),
      delayInMs: 500,
      durationInMs: 250,
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.thermostat_rounded,
              color: AppColors.white,
            ),
            Text(
              temperature.toString(),
              style: const TextStyle(
                letterSpacing: 1.2,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
