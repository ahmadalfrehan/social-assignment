import 'dart:typed_data';

import 'package:flutter/material.dart';

class StoryAvatar extends StatelessWidget {
  final String imageUrl;
  final Uint8List? imageCache;
  final String name;

  const StoryAvatar(
      {super.key, required this.imageUrl, required this.name, this.imageCache});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imageCache != null)
          CircleAvatar(
            radius: 30,
            backgroundImage: MemoryImage(imageCache!),
          )
        else
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
          )

        // const SizedBox(height: 5),
        // Text(
        //   name,
        //   style: const TextStyle(color: Colors.white, fontSize: 12),
        // ),
      ],
    );
  }
}
