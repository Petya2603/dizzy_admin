import 'package:dizzy_admin/Config/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

dynamic spinKit() {
  return CircularProgressIndicator(color: orange);
}

Widget buildTextFormField({
  required String labelText,
  FormFieldValidator<String>? validator,
  TextEditingController? controller,
  int? maxLines,
}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLines,
    validator: validator,
    decoration: InputDecoration(
      labelText: labelText,
      border: const OutlineInputBorder(),
    ),
  );
}

dynamic buildCategoryChip(String label) {
  return Chip(
    label: Text(label),
    backgroundColor: Colors.grey[200],
  );
}

void showSnackbar(String title, String message,
    {Color backgroundColor = Colors.red, Color textColor = Colors.white}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: backgroundColor,
    colorText: textColor,
    borderRadius: 15,
    margin: const EdgeInsets.all(20),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    animationDuration: const Duration(milliseconds: 500),
    duration: const Duration(seconds: 3),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        offset: const Offset(0, 2),
        blurRadius: 10,
      ),
    ],
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    borderColor: Colors.black12,
    borderWidth: 1,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
  );
}
