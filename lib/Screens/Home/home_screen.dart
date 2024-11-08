import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dizzy_admin/Config/contstants/constants.dart';
import 'package:dizzy_admin/Config/contstants/widgets.dart';
import 'package:dizzy_admin/Config/theme/theme.dart';
import 'package:dizzy_admin/Screens/Category/category_content.dart';
import 'package:dizzy_admin/Screens/Home/home_controller.dart';
import 'package:dizzy_admin/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../AddCategoryContent/add_category_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final firestore = FirebaseFirestore.instance;
  final HomeController homeController = HomeController();

  @override
  void dispose() {
    homeController.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return buildDesktopLayout(context);
      } else if (constraints.maxWidth > 700 && constraints.maxWidth <= 1200) {
        return buildTabletLayout(context);
      } else {
        return buildMobileLayout(context);
      }
    });
  }

  Widget buildDesktopLayout(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Get.width * 0.66,
        child: Scaffold(
          appBar: buildAppBar(),
          body: buildBody(),
        ),
      ),
    );
  }

  Widget buildTabletLayout(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Get.width * 0.8,
        child: Scaffold(
          appBar: buildAppBar(),
          body: buildBody(),
        ),
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Image.asset(
          logoadmin,
          height: 40,
          width: 130,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.to(AddCaregoryContent());
          },
          style: TextButton.styleFrom(foregroundColor: orange),
          child: const Text('Изменить'),
        ),
        const SizedBox(
          width: 5,
        ),
        IconButton(
            onPressed: () {
              AuthService().signOut();
            },
            icon: Icon(
              Icons.logout,
              color: orange,
            )),
      ],
    );
  }

  Widget buildBody() {
    return FutureBuilder(
      future: firestore.collection('Category').get(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: spinKit());
        }
        final category = snapshot.data?.docs ?? [];
        homeController.tabController =
            TabController(length: category.length, vsync: this);
        return Column(
          children: [
            TabBar(
              onTap: (index) {
                homeController.changeTab(index);
              },
              isScrollable: true,
              dividerColor: white,
              controller: homeController.tabController,
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              labelStyle: TextStyle(
                color: white,
                fontSize: 16,
              ),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: black2,
              ),
              tabs: category.map((doc) {
                return Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Tab(text: doc['name']));
              }).toList(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => IndexedStack(
                  index: homeController.tabIndex.value,
                  children: category.map((doc) {
                    return CategoryContent(
                      categoryname: doc['name'],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
