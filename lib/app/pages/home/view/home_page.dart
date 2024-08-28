import 'package:cosmic_jump/app/pages/home/widgets/planets_widget.dart';
import 'package:cosmic_jump/constants/colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: darkBlue,
      body: SafeArea(child: PlanetsWidget()),
    );
  }
}
