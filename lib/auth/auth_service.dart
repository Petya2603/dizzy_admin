import 'package:dizzy_admin/Config/contstants/widgets.dart';
import 'package:dizzy_admin/Config/theme/theme.dart';
import 'package:dizzy_admin/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Screens/Home/home_screen.dart';

class AuthService extends GetxController {
  Rx<User?> firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);

  @override
  void onInit() {
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    super.onInit();
  }

  // Sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Handle authentication
  Widget handleAuth() {
    return Obx(() {
      if (firebaseUser.value != null) {
        return const HomeScreen();
      } else {
        return const LoginScreen();
      }
    });
  }

  // Sign in
  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      showSnackbar('Ошибка входа',
          "Пожалуйста, проверьте свой адрес электронной почты и пароль.",
          backgroundColor: red);
    }
  }
}
