import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/features/posts/presentation/home/getX/home-controller.dart';
import 'package:social_app/features/posts/presentation/home/ui/display.dart';
import 'package:social_app/features/posts/presentation/home/ui/posts.dart';
import 'package:social_app/features/posts/presentation/home/ui/socialavatar.dart';

// Main Home Screen widget
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Injecting the HomeController using GetX dependency injection
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      // Refresh functionality triggered by pull-to-refresh
      onRefresh: () async {
        if (await controller.checkInternet()) {
          // Fetch new posts and stories if the internet is available
          controller.fetchPosts();
          controller.getStories();
        } else {
          // Show a snackbar message if there is no internet
          Get.showSnackbar(const GetSnackBar(
            title: 'An error Occured',
            message: 'check your internet connection',
            duration: Duration(seconds: 3),
          ));
        }
      },
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 8, top: 8),
            child: Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                  color: const Color(0xFF1d2b39), // Background color
                  borderRadius: BorderRadius.circular(60)),
              // Rounded corners
              height: 75,
              // Fixed height for the container
              child: Obx(
                // Reactive UI updates using GetX's Obx
                () => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ListView.separated(
                        // Show a horizontal list of stories
                        itemCount: controller.isConnectedToNet.value
                            ? controller.stories.value.length
                            : controller.storiesCached.value.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 15);
                        },
                        padding: const EdgeInsets.only(left: 10),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            // Navigate to the Display screen when a story is tapped
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Display(
                                      cache: controller.isConnectedToNet.value
                                          ? null
                                          : controller
                                              .storiesCached.value[index],
                                      url: controller.isConnectedToNet.value
                                          ? controller.stories.value[index]
                                          : null)));
                            },
                            child: StoryAvatar(
                                // Display the story avatar image
                                imageCache: controller.isConnectedToNet.value
                                    ? null
                                    : controller.storiesCached.value[index],
                                imageUrl: controller.isConnectedToNet.value
                                    ? controller.stories.value[index]
                                    : null.toString(),
                                name: ''), // Placeholder name for the story
                          );
                        }),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              // Reactive update for the posts list
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      // Display a vertical list of posts
                      itemCount: controller.posts.value.length,
                      itemBuilder: (context, index) {
                        final Uint8List? imageData =
                            controller.getImageData(controller.posts[index]);

                        return Posts(
                          // Display individual post details
                          profileImageUrl:
                              'https://ahmadalfrehan.org/assets/assets/images/logo.jpg',
                          username: 'Ahmad Al_Frehan',
                          // Static username
                          timestamp: '2 d ago',
                          // Placeholder timestamp
                          content:
                              controller.posts.value[index].body.toString(),
                          imageUrl:
                              controller.posts.value[index].image.toString(),
                          imageCache: imageData,
                          // Cached image data
                          likes: controller.posts.value[index].likes,
                          // Likes count
                          comments: 23, // Placeholder comments count
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
