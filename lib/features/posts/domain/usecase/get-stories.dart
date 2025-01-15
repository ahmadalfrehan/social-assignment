import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../respositories/post_prepository.dart';

class GetStories {
  final PostRepository repository;

  GetStories(this.repository);

  Future<Either<Failure, List<String>>> execute() async {
    return await repository.getStories();
  }
}
