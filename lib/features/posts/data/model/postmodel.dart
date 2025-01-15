import 'dart:typed_data';

import 'package:hive/hive.dart';

import '../../../../core/utils/const.dart';
import '../../domain/entities/posts.dart';

// part 'post_model.g.dart';
part 'postmodel.g.dart';

@HiveType(typeId: 1) // Unique type ID for PostModel
class PostModel extends Post {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final List<String> tags;

  @HiveField(4)
  final int views;

  @HiveField(5)
  final int userId;

  @HiveField(6)
  final int likes;

  @HiveField(7)
  final int dislikes;

  @HiveField(8)
  final String image; // For the image

  @HiveField(9)
  final Uint8List? cachedImageData;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.views,
    required this.userId,
    required this.likes,
    required this.dislikes,
    required this.image,
    this.cachedImageData,
  }) : super(
          id: id,
          title: title,
          image: image,
          body: body,
          cachedImageData: cachedImageData,
          tags: tags,
          views: views,
          userId: userId,
          likes: likes,
          dislikes: dislikes,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      image: json['image'] ?? '$imageUrlGL',
      tags: List<String>.from(json['tags']),
      views: json['views'],
      cachedImageData: null,
      userId: json['userId'],
      likes: json['reactions']['likes'],
      dislikes: json['reactions']['dislikes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'tags': tags,
      'views': views,
      'image': image,
      'userId': userId,
      'cachedImageData': cachedImageData,
      'reactions': {
        'likes': likes,
        'dislikes': dislikes,
      },
    };
  }
}
