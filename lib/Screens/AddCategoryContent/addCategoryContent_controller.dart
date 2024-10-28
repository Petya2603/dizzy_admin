
// ignore_for_file: file_names

import 'package:get/get.dart';

class AddCategoryContent extends GetxController {
  var selectedIndex = 0.obs;
  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
