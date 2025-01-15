import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/posts.dart';
import '../../domain/respositories/post_prepository.dart';
import '../datasource/post_local_data_source.dart';
import '../datasource/post_remote_data_source.dart';

// Implementation of the PostRepository interface, handling the interaction
// between the data layer (remote and local data sources) and the domain layer.
class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource; // Remote data source for fetching posts and stories
  final PostLocalDataSource localDataSource; // Local data source for caching posts and stories

  // Constructor to initialize the remote and local data sources
  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      // Fetch posts from the remote source
      final posts = await remoteDataSource.fetchPosts();

      // Cache the fetched posts along with their associated images
      await localDataSource.cachePostsAndImages(posts);

      // Return the posts as a successful result
      return Right(posts);
    } on ServerException {
      // If a server exception occurs, attempt to retrieve cached posts
      try {
        final cachedPosts = await localDataSource.getCachedPosts();
        return Right(cachedPosts); // Return cached posts if available
      } catch (_) {
        return Left(CacheFailure()); // Return a cache failure if fetching cached posts fails
      }
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getCachedPosts() async {
    try {
      // Retrieve posts from the local cache
      final posts = await localDataSource.getCachedPosts();
      return Right(posts); // Return the cached posts
    } catch (e) {
      return Left(CacheFailure()); // Return a cache failure if an error occurs
    }
  }

  @override
  Future<Either<Failure, List<Uint8List?>>> getCachedStories() async {
    try {
      // Retrieve cached stories as Uint8List (binary data)
      final stories = await localDataSource.getCachedStories();
      return Right(stories); // Return the cached stories
    } catch (e) {
      return Left(CacheFailure()); // Return a cache failure if an error occurs
    }
  }

  @override
  Future<Either<Failure, List<String>>> getStories() async {
    try {
      // Fetch stories from the remote source
      final stories = await remoteDataSource.fetchStories();

      // Cache each fetched story
      for (var story in stories) {
        await localDataSource.cacheStories(story);
      }
      return Right(stories); // Return the fetched stories
    } catch (e) {
      return Left(CacheFailure()); // Return a cache failure if an error occurs
    }
  }
}
