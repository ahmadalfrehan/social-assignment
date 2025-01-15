import 'dart:convert'; // For JSON encoding and decoding
import 'package:http/http.dart' as http; // HTTP client for making API requests

import '../../../../core/utils/const.dart'; // Contains constants like API URLs
import '../model/postmodel.dart'; // Model class for handling post data

// Abstract class defining the contract for the PostRemoteDataSource
abstract class PostRemoteDataSource {
  // Fetches a list of posts from the remote server
  Future<List<PostModel>> fetchPosts();

  // Fetches a list of stories (image URLs) from the remote server
  Future<List<String>> fetchStories();
}

// Implementation of PostRemoteDataSource for handling remote API requests
class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client; // HTTP client for making requests

  // Constructor to initialize the HTTP client
  PostRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PostModel>> fetchPosts() async {
    // Makes an HTTP GET request to fetch posts
    final response = await http.get(Uri.parse(postsUrl));

    // Check if the response is successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response body into a Map
      Map<String, dynamic> data =
      Map<String, dynamic>.from(json.decode(response.body));

      // Initialize an empty list to store the posts
      List<PostModel> list = [];

      // Loop through each post in the 'posts' field of the JSON response
      for (var o in data['posts']) {
        // Convert each post JSON object into a PostModel instance and add it to the list
        list.add(PostModel.fromJson(o));
      }

      // Return the list of PostModel objects
      return list;
    } else {
      // Throw an exception if the response is not successful
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<List<String>> fetchStories() async {
    // Makes an HTTP GET request to fetch stories
    final response = await http.get(Uri.parse(stories));

    // Check if the response is successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response body into a Map
      Map<String, dynamic> data =
      Map<String, dynamic>.from(json.decode(response.body));

      // Initialize an empty list to store the story image URLs
      List<String> list = [];

      // Loop through each story URL in the 'images' field of the JSON response
      for (var o in data['images']) {
        // Add each URL to the list
        list.add(o);
      }

      // Return the list of story URLs
      return list;
    } else {
      // Throw an exception if the response is not successful
      throw Exception('Failed to load posts');
    }
  }
}
