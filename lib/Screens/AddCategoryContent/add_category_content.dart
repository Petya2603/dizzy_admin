import 'package:dizzy_admin/Screens/AddCategoryContent/controller/addCategoryContent_controller.dart';
import 'package:dizzy_admin/Screens/AddCategoryContent/add_content/add_audio.dart';
import 'package:dizzy_admin/Screens/AddCategoryContent/add_content/add_banner.dart';
import 'package:dizzy_admin/Screens/AddCategoryContent/add_content/add_post.dart';
import 'package:dizzy_admin/Screens/AddCategoryContent/add_content/add_video.dart';
import 'package:dizzy_admin/Screens/AddCategoryContent/compenents/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/constants/constants.dart';

class AddCaregoryContent extends StatelessWidget {
  AddCaregoryContent({super.key});
  final AddCategoryContent categoryController = AddCategoryContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1200) {
            return buildDesktopLayout(context);
          } else if (constraints.maxWidth > 700 &&
              constraints.maxWidth <= 1200) {
            return buildTabletLayout(context);
          } else {
            return buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget buildDesktopLayout(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Get.width * 0.8,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildMenuList(),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: buildContentDisplay(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: buildMenuList(),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: buildContentDisplay(),
        ),
      ],
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: buildMenuList(),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 5,
          child: buildContentDisplay(),
        ),
      ],
    );
  }

  Widget buildMenuList() {
    return ListView.builder(
      itemCount: contentName.length,
      itemBuilder: (context, index) {
        return Obx(
          () => MenuButton(
            title: contentName[index],
            isSelected: categoryController.selectedIndex == index,
            onTap: () {
              categoryController.updateSelectedIndex(index);
            },
          ),
        );
      },
    );
  }

  Widget buildContentDisplay() {
    return Obx(() {
      switch (categoryController.selectedIndex.value) {
        case 0:
          return const AddBanner();
        case 1:
          return const AddPost();
        case 2:
          return const AddAudio();
        case 3:
          return const AddVideo();
        default:
          return const Center(child: Text(""));
      }
    });
  }
}
