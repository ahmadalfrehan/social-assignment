import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:social_app/features/posts/presentation/home/getX/home-controller.dart'; // GetX controller for managing home screen state
import 'package:social_app/features/posts/presentation/home/ui/home-screen.dart'; // Home screen UI
import 'package:social_app/features/register/ui/out.dart'; // Out screen (possibly for user profile or logout)

import '../../../../../core/utils/const.dart'; // Constants like asset paths

class Home extends GetView<HomeController> {
  Home({super.key});

  // Instantiate the HomeController using Get.put for dependency injection
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1F26), // Background color for the entire screen
      appBar: AppBar(
          backgroundColor: const Color(0xFF1C1F26), // Matches the background color
          elevation: 0, // Removes the shadow below the AppBar
          title: SvgPicture.asset('${assetsPath}Socially.svg'), // App logo
          centerTitle: true, // Centers the title/logo
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Aligns the child widget to the end
              children: [
                SizedBox(
                    height: 30,
                    width: 30,
                    child: SvgPicture.asset(
                      '${assetsPath}carbon_notification-filled.svg', // Notification icon
                    )),
              ],
            ),
          )),
      body: Obx(
        // Observes changes in the controller index and updates the view
            () => IndexedStack(
          index: controller.index.value, // Displays the child corresponding to the current index
          children: [
            HomeScreen(), // Home screen
            Container(), // Placeholder for future feature or screen
            Out(), // Out screen (possibly a profile or logout screen)
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10), // Adds horizontal padding to the navigation bar
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)), // Rounded corners at the top
          child: Container(
            height: 70, // Height of the bottom navigation bar
            color: Colors.white, // Background color
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Space the items evenly
              children: [
                _item(0, '${assetsPath}ant-design_home-filled.png'), // Home tab
                _item(1, '${assetsPath}carbon_explore.png'), // Explore tab
                _item(2, '${assetsPath}carbon_user-avatar.png'), // Profile tab
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for individual navigation bar items
  _item(int index, var image) {
    return InkWell(
      onTap: () {
        controller.index.value = index; // Updates the selected index in the controller
      },
      child: Obx(
        // Observes changes in the index value and updates the appearance of the item
            () => SizedBox(
          height: 45,
          width: 45,
          child: Stack(
            children: [
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200), // Smooth animation when the container updates
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(), // No decoration (can be customized)
                ),
              ),
              Image.asset(image,
                  color: controller.index.value == index
                      ? Colors.black // Highlight the active tab
                      : Colors.grey), // Gray color for inactive tabs
            ],
          ),
        ),
      ),
    );
  }
}
