import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  TextEditingController categoryController = TextEditingController();
  RxString selectedCategory = ''.obs;
  RxList<String> categories = <String>[].obs;
  void fetchCategories() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('Category').get();
    categories.value =
        snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  void addNewCategory(String categoryName) async {
    if (categoryName.isNotEmpty && !categories.contains(categoryName)) {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('Category').add({
        'name': categoryName,
      });
      firestore.collection(categoryName);
      categories.add(categoryName);
      categoryController.clear();
    }
  }

  void toggleCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = '';
    } else {
      selectedCategory.value = category;
    }
  }

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }
}
