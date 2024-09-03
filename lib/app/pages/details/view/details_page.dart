import 'package:cosmic_jump/app/pages/details/widgets/planet_description.dart';
import 'package:cosmic_jump/app/pages/details/widgets/planet_overview.dart';
import 'package:cosmic_jump/constants/colors.dart';
import 'package:cosmic_jump/data/models/planet_model.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    required this.planet,
    super.key,
  });

  final PlanetModel planet;

  static Route<void> route(PlanetModel planet) {
    return MaterialPageRoute<void>(
      builder: (_) => DetailsPage(
        planet: planet,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: darkBlue,
      body: SafeArea(
        child: Column(
          children: [
            PlanetOverview(planet: planet),
            const SizedBox(height: 24),
            PlanetDescription(planet: planet, size: size),
          ],
        ),
      ),
    );
  }
}
