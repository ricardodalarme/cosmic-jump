import 'package:cosmic_jump/app/pages/inventory/view/inventory_page.dart';
import 'package:cosmic_jump/app/pages/planets/view/planets_page.dart';
import 'package:cosmic_jump/app/widgets/toggle_button.dart';
import 'package:cosmic_jump/constants/colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const HomePage(),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: Column(
        children: [
          SafeArea(
            child: AnimatedToggle(
              currentIndex: _currentPage,
              values: const ['Planetas', 'Inventário'],
              onChanged: (index) => setState(() => _currentPage = index!),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentPage,
              children: const [
                PlanetsPage(),
                InventoryPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
