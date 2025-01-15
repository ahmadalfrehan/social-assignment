import 'dart:typed_data'; // For handling binary data like image files
import 'package:dio/dio.dart'; // HTTP client for making API requests
import 'package:hive/hive.dart'; // Hive package for local storage

import '../model/postmodel.dart'; // Model class for posts

// Abstract class defining the contract for local data operations
abstract class PostLocalDataSource {
  // Caches a list of posts locally
  Future<void> cachePosts(List<PostModel> posts);

  // Caches a list of posts along with their images
  Future<void> cachePostsAndImages(List<PostModel> posts);

  // Caches a single story image and returns its binary data
  Future<Uint8List?> cacheStories(String story);

  // Retrieves cached posts from local storage
  Future<List<PostModel>> getCachedPosts();

  // Retrieves cached stories (images) from local storage
  Future<List<Uint8List?>> getCachedStories();
}

// Implementation of PostLocalDataSource using Hive for local storage
class PostLocalDataSourceImpl implements PostLocalDataSource {
  final Box<PostModel> hiveBox; // Hive box for storing PostModel objects
  final Box<Uint8List> hiveBoxStory; // Hive box for storing binary story data

  // Constructor to initialize Hive boxes
  PostLocalDataSourceImpl({required this.hiveBox, required this.hiveBoxStory});

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    // Clear any existing posts in the Hive box
    await hiveBox.clear();
    // Add the new list of posts to the Hive box
    await hiveBox.addAll(posts);
  }

  @override
  Future<Uint8List?> cacheStories(String story) async {
    // Check if the story image is already cached
    if (hiveBoxStory.containsKey(story)) {
      return hiveBoxStory.get(story); // Return the cached image data
    }
    try {
      // Fetch the image data from the URL
      final response = await Dio().get(
        story,
        options: Options(responseType: ResponseType.bytes),
      );

      // Convert the response data to a Uint8List and cache it
      final imageData = Uint8List.fromList(response.data);
      hiveBoxStory.put(story, imageData);
      return imageData; // Return the cached image data
    } catch (e) {
      // Handle any errors during the image fetching process
      print('Error fetching image: $e');
      return null; // Return null if fetching fails
    }
  }

  @override
  Future<List<PostModel>> getCachedPosts() async {
    print('getCachedPosts');
    // Retrieve all posts stored in the Hive box as a list
    return hiveBox.values.toList();
  }

  @override
  Future<void> cachePostsAndImages(List<PostModel> posts) async {
    // Clear existing posts in the Hive box
    await hiveBox.clear();
    for (var post in posts) {
      // Fetch image data for each post
      final imageData = await _fetchImageData(post.image);

      // Create a new PostModel instance with the cached image data
      final postWithImage = PostModel(
        id: post.id,
        title: post.title,
        body: post.body,
        tags: post.tags,
        views: post.views,
        userId: post.userId,
        dislikes: post.dislikes,
        likes: post.likes,
        cachedImageData: imageData,
        image: post.image,
      );

      // Store the modified post in the Hive box
      hiveBox.put(post.id, postWithImage);
    }
  }

  // Helper method to fetch image data from a given URL
  Future<Uint8List?> _fetchImageData(String imageUrl) async {
    try {
      // Fetch the image as binary data
      final response = await Dio()
          .get(imageUrl, options: Options(responseType: ResponseType.bytes));
      return response.data; // Return the image data
    } catch (e) {
      // Handle errors during the fetch operation
      print('Failed to fetch image: $e');
      return null; // Return null if the image cannot be fetched
    }
  }

  @override
  Future<List<Uint8List?>> getCachedStories() async {
    // Retrieve all cached story images from the Hive box as a list
    return hiveBoxStory.values.toList();
  }
}
