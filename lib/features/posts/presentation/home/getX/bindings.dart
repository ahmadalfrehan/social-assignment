import 'package:get/get.dart';
// import 'package:social_app//home/getX/home-google_sign_in_service.dart';
import 'package:social_app/features/posts/presentation/home/getX/home-controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
