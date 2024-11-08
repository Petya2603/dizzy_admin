import 'package:dizzy_admin/Config/theme/theme.dart';
import 'package:dizzy_admin/Screens/Home/home_screen.dart';
import 'package:dizzy_admin/auth/auth_service.dart';
import 'package:dizzy_admin/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Screens/AddCategoryContent/add_category_content.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCgqQj4NxFvnBkphV7mrZmn5c7DZqVBQJY",
        authDomain: "addpost-9b3e9.firebaseapp.com",
        projectId: "addpost-9b3e9",
        storageBucket: "addpost-9b3e9.appspot.com",
        messagingSenderId: "998001294501",
        appId: "1:998001294501:web:fc4c42abbd488edbd6614c",
        measurementId: "G-1VZMHNXSC0"),
  );
  Get.put(AuthService());
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
      home: Get.find<AuthService>().handleAuth(),
    );
  }
}
