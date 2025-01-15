import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:social_app/core/di/service_locator.dart'; // Dependency injection setup
import 'package:social_app/features/posts/domain/usecase/get-cached-stories.dart'; // Use case for retrieving cached stories
import 'package:social_app/features/posts/domain/usecase/get-stories.dart'; // Use case for retrieving stories from the server

import '../../../../../core/utils/Connectivity.dart'; // Custom utility to check connectivity
import '../../../domain/entities/posts.dart'; // Post entity definition
import '../../../domain/usecase/get-cached-posts.dart'; // Use case for retrieving cached posts
import '../../../domain/usecase/get-posts.dart'; // Use case for retrieving posts from the server

class HomeController extends GetxController {
  // Dependency injection for use cases
  GetPosts getPostsUseCase = sl();
  GetCachedPosts getCachedPostsUseCase = sl();
  GetCachedStories getCachedStories = sl();
  GetStories getStoriesUseCase = sl();

  // Observables to manage reactive state
  var posts = <Post>[].obs; // List of posts
  var stories = <String>[].obs; // List of story URLs
  var storiesCached = <Uint8List?>[].obs; // Cached story images
  var isLoading = false.obs; // Loading state
  var isConnectedToNet = false.obs; // Network connectivity status
  var errorMessage = ''.obs; // Error message holder
  var index = 0.obs; // Index for potential UI control

  final geg = GetPosts; // Unused declaration (can be removed if not used)

  @override
  void onInit() {
    super.onInit();
    fetchPosts(); // Fetch posts when the controller is initialized
    getStories(); // Fetch stories when the controller is initialized
  }

  // Fetch posts, either from the server or cached, based on internet connectivity
  Future<void> fetchPosts() async {
    isLoading.value = true; // Set loading state to true
    try {
      // Check internet connectivity
      final connectivity = Connectivity();
      final isConnected = await connectivity.checkConnectivity();
      if (isConnected) {
        // Fetch posts from the server
        final result = await getPostsUseCase.execute();
        result.fold(
            (failure) => errorMessage.value =
                'Failed to load posts from the server.', // Handle failure
            (postsData) {
          posts.value = postsData; // Update posts on success
        });
      } else {
        // Fetch cached posts
        final cacheResult = await getCachedPostsUseCase.execute();
        cacheResult.fold(
            (failure) => errorMessage.value =
                'No internet and no cached data available.', // Handle failure
            (cachedPosts) {
          posts.value = cachedPosts; // Update posts with cached data
        });
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred.'; // Handle exceptions
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

  // Fetch stories, either from the server or cached, based on internet connectivity
  Future<void> getStories() async {
    isLoading.value = true; // Set loading state to true
    final connectivity = Connectivity();
    final isConnected = await connectivity.checkConnectivity();
    isConnectedToNet.value = isConnected; // Update connectivity status
    if (isConnected) {
      // Fetch stories from the server
      final result = await getStoriesUseCase.execute();
      result.fold(
          (failure) => errorMessage.value =
              'Failed to load posts from the server.', // Handle failure
          (storiesData) {
        stories.value = storiesData; // Update stories on success
      });
    } else {
      // Fetch cached stories
      final cacheResult = await getCachedStories.execute();
      cacheResult.fold(
          (failure) => errorMessage.value =
              'No internet and no cached data available.', // Handle failure
          (cachedStories) {
        storiesCached.value = cachedStories; // Update cached stories
      });
    }
    isLoading.value = false; // Set loading state to false
  }

  // Retrieve cached image data for a specific post
  Uint8List? getImageData(Post post) {
    return post.cachedImageData;
  }

  // Check internet connectivity status
  Future<bool> checkInternet() async {
    Connectivity connectivity = Connectivity();
    final isConnected = await connectivity.checkConnectivity();
    isConnectedToNet.value = isConnected; // Update connectivity status
    return isConnected;
  }
}
