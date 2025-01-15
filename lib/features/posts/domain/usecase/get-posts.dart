import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/posts.dart';
// import '../repositories/post_repository.dart';
import '../respositories/post_prepository.dart';
// import '../entities/post.dart';

class GetPosts {
  final PostRepository repository;

  GetPosts(this.repository);

  Future<Either<Failure, List<Post>>> execute() async {
    return await repository.getPosts();
  }
}
