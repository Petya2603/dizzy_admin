import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dizzy_admin/screens/home/home_widgets/home_appBar.dart';
import 'package:dizzy_admin/screens/home/home_widgets/home_controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/constants/constants.dart';
import '../../config/constants/widgets.dart';
import '../category/category_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final firestore = FirebaseFirestore.instance;
  final HomeController homeController = HomeController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> categoryDocuments = [];
  Map<String, List<DocumentSnapshot>> categoryData = {};
  TabController? tabController;

  Stream<void> _initializeCategoryStream() async* {
    try {
      final querySnapshot = await firestore.collection('Category').get();
      categoryDocuments = querySnapshot.docs;
      for (var doc in categoryDocuments) {
        final categoryName = doc['name'];
        final categorySnapshot = await firestore.collection(categoryName).get();
        categoryData[categoryName] = categorySnapshot.docs;
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  void dispose() {
    tabController?.dispose();
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

  Widget buildBody() {
    return StreamBuilder<void>(
        stream: _initializeCategoryStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading categories"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return spinKit();
          }
          tabController =
              TabController(length: categoryDocuments.length, vsync: this);
          return Obx(
            () => Column(
              children: [
                buildTabBar(categoryDocuments),
                const SizedBox(height: 10),
                Expanded(
                  child: IndexedStack(
                    index: homeController.tabIndex.value,
                    children: categoryDocuments.map((doc) {
                      return CategoryView(
                        categoryname: doc['name'],
                        documents: categoryData[doc['name']] ?? [],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget buildTabBar(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> categoryDocs) {
    return TabBar(
      onTap: (index) {
        homeController.changeTab(index);
      },
      isScrollable: true,
      dividerColor: AppColors.white,
      tabAlignment: TabAlignment.start,
      padding: EdgeInsets.zero,
      controller: tabController,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      unselectedLabelStyle:
          const TextStyle(fontSize: 16, fontFamily: Fonts.gilroyRegular),
      labelStyle: const TextStyle(
        color: AppColors.white,
        fontFamily: Fonts.gilroyBold,
        fontSize: 16,
      ),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: AppColors.black2,
      ),
      tabs: categoryDocs.map((doc) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Tab(text: doc['name']),
        );
      }).toList(),
    );
  }
}
