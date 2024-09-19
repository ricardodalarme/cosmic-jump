import 'package:cosmic_jump/app/pages/home/widgets/header_widget.dart';
import 'package:cosmic_jump/app/pages/home/widgets/planets_widget.dart';
import 'package:cosmic_jump/constants/app_colors.dart';
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
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(),
            SizedBox(height: 20),
            Expanded(child: PlanetsWidget()),
          ],
        ),
      ),
    );
  }
}
