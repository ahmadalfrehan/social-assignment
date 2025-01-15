import 'dart:typed_data';

class Post {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int views;
  final int userId;
  final int likes;
  final int dislikes;
  final String image;
  final Uint8List? cachedImageData;

  Post({
    required this.id,
    required this.image,
    required this.title,
    required this.body,
    required this.tags,
    required this.views,
    required this.userId,
    required this.likes,
    required this.dislikes,
    this.cachedImageData,
  });

  double getPopularity() {
    return (likes - dislikes) + (views * 0.1);
  }
}
