import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/core/utils/auth-manager.dart';
import 'package:social_app/features/register/ui/login.dart';

import '../../posts/presentation/home/ui/home.dart';

class GoogleSignInService extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthManager authManager = AuthManager();

  Future<void> handleLogin() async {
    // Simulate login (replace this with your actual login logic)
    bool loginSuccessful = true;

    if (loginSuccessful) {
      await authManager.saveLoginState(true);

      Get.offAll(() => Home());
    } else {}
  }

  final GoogleSignInService googleSignInService = GoogleSignInService();

  void handleGoogleSignIn() async {
    final user = await googleSignInService.signInWithGoogle();
    if (user != null) {
      print('User signed in: ${user.displayName}, ${user.email}');
      // Navigate to the home page or dashboard
      await handleLogin();
    } else {
      print('Sign-in failed');
    }
  }

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print(googleUser);
      if (googleUser == null) {
        return null;
      }
      return googleUser;
    } catch (error) {
      print('Google Sign-In error: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut().then((value) {
      authManager.clearLoginState();
      Get.offAll(() => LoginScreen());
    });
  }
}
