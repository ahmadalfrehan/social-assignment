import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:social_app/features/posts/data/datasource/post_local_data_source.dart';
import 'package:social_app/features/posts/domain/usecase/get-cached-stories.dart';
import 'package:social_app/features/posts/domain/usecase/get-stories.dart';
import 'package:social_app/features/posts/presentation/home/getX/home-controller.dart';

import '../../features/posts/data/datasource/post_remote_data_source.dart';
import '../../features/posts/data/model/postmodel.dart';
import '../../features/posts/data/repositiores/PostRepositoryImpl.dart';
import '../../features/posts/domain/respositories/post_prepository.dart';
import '../../features/posts/domain/usecase/get-cached-posts.dart';
import '../../features/posts/domain/usecase/get-posts.dart';

final sl = GetIt.instance; // GetIt instance

Future<void> init() async {
  await Hive.initFlutter();
  final hiveBoxStories = await Hive.openBox<Uint8List>('image_cache');
  Hive.registerAdapter(PostModelAdapter()); // Register the PostModel adapter
  final hiveBox = await Hive.openBox<PostModel>('post_cache');
  sl.registerLazySingleton(() => hiveBox);
  sl.registerLazySingleton(() => hiveBoxStories);

  // Register Controllers
  sl.registerFactory(() => HomeController());

  // Register Use Cases
  sl.registerLazySingleton(() => GetPosts(sl()));
  sl.registerLazySingleton(() => GetCachedPosts(sl()));
  sl.registerLazySingleton(() => GetCachedStories(sl()));
  sl.registerLazySingleton(() => GetStories(sl()));

  // Register Repositories
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Register Data Sources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<PostLocalDataSource>(
    () => PostLocalDataSourceImpl(hiveBox: sl(), hiveBoxStory: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}
