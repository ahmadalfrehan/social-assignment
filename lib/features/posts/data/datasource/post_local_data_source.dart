import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../model/postmodel.dart';

abstract class PostLocalDataSource {
  Future<void> cachePosts(List<PostModel> posts);

  Future<void> cachePostsAndImages(List<PostModel> posts);

  Future<Uint8List?> cacheStories(String story);

  Future<List<PostModel>> getCachedPosts();

  Future<List<Uint8List?>> getCachedStories();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final Box<PostModel> hiveBox;
  final Box<Uint8List> hiveBoxStory;

  PostLocalDataSourceImpl({required this.hiveBox, required this.hiveBoxStory});

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    await hiveBox.clear(); // Clear existing data
    await hiveBox.addAll(posts); // Save new posts
  }

  // final Box<Uint8List> hiveBoxStory //= Hive.box<Uint8List>('image_cache');
  @override
  Future<Uint8List?> cacheStories(String story) async {
    // Check if the image is already cached
    if (hiveBoxStory.containsKey(story)) {
      return hiveBoxStory.get(story);
    }
    try {
      final response = await Dio().get(
        story,
        options: Options(responseType: ResponseType.bytes),
      );

      final imageData = Uint8List.fromList(response.data);
      hiveBoxStory.put(story, imageData);
      return imageData;
    } catch (e) {
      print('Error fetching image: $e');
      return null; // Return null if fetching fails
    }
  }

  @override
  Future<List<PostModel>> getCachedPosts() async {
    print('getCachedPosts');
    return hiveBox.values.toList();
  }

  @override
  Future<void> cachePostsAndImages(List<PostModel> posts) async {
    await hiveBox.clear();
    for (var post in posts) {
      final imageData = await _fetchImageData(post.image);
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

      hiveBox.put(post.id, postWithImage); // Store posts with cached image data
    }
  }

  Future<Uint8List?> _fetchImageData(String imageUrl) async {
    try {
      final response = await Dio()
          .get(imageUrl, options: Options(responseType: ResponseType.bytes));
      return response.data;
    } catch (e) {
      print('Failed to fetch image: $e');
      return null; // Return null if the image cannot be fetched
    }
  }

  @override
  Future<List<Uint8List?>> getCachedStories() async {
    return hiveBoxStory.values.toList();
  }
}
