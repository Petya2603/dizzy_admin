import 'package:dizzy_admin/auth/auth_service.dart';
import 'package:dizzy_admin/config/constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        primaryColor: AppColors.orange,
        fontFamily: Fonts.gilroySemiBold,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Get.find<AuthService>().handleAuth(),
    );
  }
}
