import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/posts.dart';
import '../../domain/respositories/post_prepository.dart';
import '../datasource/post_local_data_source.dart';
import '../datasource/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;

  // final Box<Post> hiveBox = Hive.box<Post>('post_cache');

  PostRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    try {
      // Fetch posts from the remote source
      final posts = await remoteDataSource.fetchPosts();
      // Cache the posts
      // await localDataSource.cachePosts(posts);
      await localDataSource.cachePostsAndImages(posts);
      return Right(posts);
    } on ServerException {
      try {
        // Fetch cached posts if there’s a server failure
        final cachedPosts = await localDataSource.getCachedPosts();
        return Right(cachedPosts);
      } catch (_) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getCachedPosts() async {
    try {
      // Fetch posts from the remote source
      final posts = await localDataSource.getCachedPosts();
      // Cache the posts
      return Right(posts);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Uint8List?>>> getCachedStories() async {
    try {
      final stories = await localDataSource.getCachedStories();

      return Right(stories);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getStories() async {
    try {
      final stories = await remoteDataSource.fetchStories();
      for (var story in stories) {
        await localDataSource.cacheStories(story);
      }
      return Right(stories);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
