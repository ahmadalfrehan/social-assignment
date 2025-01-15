import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/google_sign_in_service.dart';

class LoginScreen extends GetView<GoogleSignInService> {
  LoginScreen({super.key});

  final controller = Get.put(GoogleSignInService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => controller.handleGoogleSignIn(),
          icon: const Icon(Icons.login),
          label: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
