import 'package:dizzy_admin/Config/theme/theme.dart';
import 'package:dizzy_admin/Screens/Home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Screens/AddCategoryContent/add_category_content.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: white,
        primaryColor: orange,
        fontFamily: "Gilroy",
        appBarTheme: AppBarTheme(
          backgroundColor: white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/addCategoryContent', page: () => AddCaregoryContent()),
      ],
    );
  }
}
