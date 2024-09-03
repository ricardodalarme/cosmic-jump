import 'package:cosmic_jump/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppSnackbar extends StatelessWidget {
  const AppSnackbar(
    this.text, {
    super.key,
  });

  final String text;

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.lightBlue,
        content: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
