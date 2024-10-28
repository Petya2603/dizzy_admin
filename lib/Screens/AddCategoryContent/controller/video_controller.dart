import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoController extends GetxController {
  TextEditingController categoryController = TextEditingController();
  RxString selectedCategory = ''.obs;
  RxList<String> categories = [
    'Футбол',
    'Новости',
    'UFC',
    'Автомобили',
    'Природа',
    'Музыка',
    'Аниме'
  ].obs;
  void addCategory() {
    String newCategory = categoryController.text;
    if (newCategory.isNotEmpty && !categories.contains(newCategory)) {
      categories.add(newCategory);
      categoryController.clear();
    }
  }

  void toggleCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = ''; // Deselect if the same category is clicked
    } else {
      selectedCategory.value = category; // Select the new category
    }
  }
}
