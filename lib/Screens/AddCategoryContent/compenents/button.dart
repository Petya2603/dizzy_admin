import 'package:flutter/material.dart';

import '../../../config/constants/constants.dart';

class MenuButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const MenuButton(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: isSelected ? AppColors.white : AppColors.black),
      ),
      tileColor: isSelected ? AppColors.orange : AppColors.white,
      onTap: onTap,
    );
  }
}
