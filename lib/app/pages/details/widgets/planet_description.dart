import 'package:cosmic_jump/app/pages/details/widgets/description_tile.dart';
import 'package:cosmic_jump/app/theme/colors.dart';
import 'package:cosmic_jump/models/planet_model.dart';
import 'package:flutter/widgets.dart';

class PlanetDescription extends StatelessWidget {
  const PlanetDescription({
    required this.planet,
    required this.size,
    super.key,
  });

  final PlanetModel planet;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [darkBlue, lightBlue],
          end: Alignment.topCenter,
          begin: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          DescriptionTile(
            svg: 'assets/svgs/speed-meter.svg',
            text: 'Velocidade Orbital Média',
            value: planet.orbitalSpeed.toString(),
            unit: 'km/s',
          ),
          const SizedBox(height: 16),
          DescriptionTile(
            svg: 'assets/svgs/planet-satellite.svg',
            text: 'Satélites',
            value: planet.satellites.toString(),
            unit: '',
          ),
          const SizedBox(height: 16),
          DescriptionTile(
            svg: 'assets/svgs/compass.svg',
            text: 'Área de Superfície',
            value: planet.surfaceArea.toStringAsFixed(1),
            unit: 'km2',
          ),
          const SizedBox(height: 16),
          DescriptionTile(
            svg: 'assets/svgs/planet-rotation.svg',
            text: 'Período de Rotação',
            value: planet.rotationPeriod.toString(),
            unit: 'd',
          ),
        ],
      ),
    );
  }
}
