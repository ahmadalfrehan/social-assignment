import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/posts.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts();

  Future<Either<Failure, List<Post>>> getCachedPosts();

  Future<Either<Failure, List<String>>> getStories();

  Future<Either<Failure, List<Uint8List?>>> getCachedStories();
}
