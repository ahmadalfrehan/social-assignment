import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
// import '../repositories/post_repository.dart';
import '../respositories/post_prepository.dart';
// import '../entities/post.dart';

class GetCachedStories {
  final PostRepository repository;

  GetCachedStories(this.repository);

  Future<Either<Failure, List<Uint8List?>>> execute() {
    return repository.getCachedStories();
  }
}
