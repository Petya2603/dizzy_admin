import 'package:dizzy_admin/Config/theme/theme.dart';
import 'package:flutter/material.dart';

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
        style: TextStyle(color: isSelected ? white : Colors.black),
      ),
      tileColor: isSelected ? orange : white,
      onTap: onTap,
    );
  }
}
