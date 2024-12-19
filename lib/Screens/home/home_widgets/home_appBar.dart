import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Config/constants/constants.dart';
import '../../../auth/auth_service.dart';
import '../../Contact_us/contact_screen.dart';
import '../../addCategoryContent/add_category_content.dart';

AppBar buildAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Image.asset(
        Assets.logoAdmin,
        height: 40,
        width: 130,
      ),
    ),
    scrolledUnderElevation: 0.0,
    actions: [
      TextButton(
        onPressed: () {
          Get.to(AddCaregoryContent());
        },
        style: TextButton.styleFrom(foregroundColor: AppColors.orange),
        child: const Text('Изменить'),
      ),
      const SizedBox(
        width: 10,
      ),
      IconButton(
          onPressed: () {
            Get.to(const ContactUsTableScreen());
          },
          icon: const Icon(
            Icons.quick_contacts_mail,
            color: AppColors.orange,
          )),
      const SizedBox(
        width: 10,
      ),
      IconButton(
          onPressed: () {
            AuthService().signOut();
          },
          icon: const Icon(
            Icons.logout,
            color: AppColors.orange,
          )),
    ],
  );
}
