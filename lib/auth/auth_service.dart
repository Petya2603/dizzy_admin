import 'package:dizzy_admin/auth/login_screen.dart';
import 'package:dizzy_admin/config/constants/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/home/home_view.dart';

class AuthService extends GetxController {
  Rx<User?> firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);

  @override
  void onInit() {
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    super.onInit();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget handleAuth() {
    return Obx(() {
      if (firebaseUser.value != null) {
        return  const HomeScreen();
      } else {
        return const LoginScreen();
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      showSnackBar(
          'Ошибка входа',
          "Пожалуйста, проверьте свой адрес электронной почты и пароль.",
          Colors.red);
    }
  }
}
