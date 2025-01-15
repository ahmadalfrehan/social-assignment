import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/const.dart';

class Posts extends StatelessWidget {
  final String profileImageUrl;
  final String username;
  final String timestamp;
  final String content;
  final String? imageUrl;
  final Uint8List? imageCache;
  final int likes;
  final int comments;

  const Posts({
    super.key,
    required this.profileImageUrl,
    required this.username,
    required this.timestamp,
    required this.content,
    this.imageUrl,
    this.imageCache,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Profile and timestamp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          // color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                timestamp,
                style: TextStyle(color: Colors.grey[300], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (content.isNotEmpty)
            Text(
              content,
              style: const TextStyle(),
            ),
          if (content.isNotEmpty) const SizedBox(height: 10),
          // Post Image
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  height: Get.height / 3,
                  width: Get.width,
                  decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl!),
                      fit: BoxFit.fill,
                    ),
              )),
            ),
          if (imageCache != null&&imageUrl==null)
            Container(
                height: Get.height / 3,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(imageCache!),
                    fit: BoxFit.fill,
                  ),
                )),
          // else
          //   const Icon(Icons.image_not_supported),
          // Likes and Comments
          const SizedBox(height: 10),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('${assetsPath}ic_round-favorite-border.svg'),
                  const SizedBox(width: 5),
                  Text(
                    '$likes',
                    style: const TextStyle(),
                  ),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset('${assetsPath}fa-regular_comment-dots.svg'),
                  const SizedBox(width: 5),
                  Text(
                    '$comments',
                    style: const TextStyle(),
                  ),
                ],
              ),
              SvgPicture.asset('${assetsPath}bx_bookmark-alt.svg'),
            ],
          ),
        ],
      ),
    );
  }
}
