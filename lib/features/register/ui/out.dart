import 'package:flutter/material.dart';

import '../controller/google_sign_in_service.dart';

class Out extends StatelessWidget {
  Out({super.key});

  final GoogleSignInService googleSignInService = GoogleSignInService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        // Center(
        child: ElevatedButton.icon(
          onPressed: () => googleSignInService.signOut(),
          icon: const Icon(Icons.login),
          label: const Text('Logout Google Account'),
        ),
      ),
      // );
      // ),
    );
  }
}
