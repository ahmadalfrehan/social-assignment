import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/const.dart';

class Display extends StatelessWidget {
  final String? url;
  final Uint8List? cache;

  const Display({super.key, required this.url, this.cache});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (cache != null)
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: MemoryImage(cache!), fit: BoxFit.fill)),
            )
          else
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        // 'https://ahmadalfrehan.org/assets/assets/images/ahmad.jpg'
                        url!,
                      ),
                      fit: BoxFit.fill)),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: SvgPicture.asset('${assetsPath}back.svg')),
                    const SizedBox(width: 10),
                    const Text(
                      'Ahmad Alfrehan',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const Text(
                      '17m',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const Spacer(),
                    SvgPicture.asset('${assetsPath}download.svg'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
