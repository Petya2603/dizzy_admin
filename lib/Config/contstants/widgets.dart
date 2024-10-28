import 'package:dizzy_admin/Config/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Screens/AddCategoryContent/controller/post_controller.dart';

dynamic spinKit() {
  return CircularProgressIndicator(color: orange);
}

dynamic buildTextFormField(
    {required String labelText, required String hintText, int? maxLines}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: const OutlineInputBorder(),
    ),
    maxLines: maxLines,
  );
}

dynamic buildCategoryChip(String label) {
  return Chip(
    label: Text(label),
    backgroundColor: Colors.grey[200],
  );
}
