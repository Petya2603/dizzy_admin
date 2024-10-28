import 'package:get/get.dart';

class BannerController extends GetxController {
  RxBool isHidden = false.obs;

  void toggleHidden() {
    isHidden.toggle();
  }
}
