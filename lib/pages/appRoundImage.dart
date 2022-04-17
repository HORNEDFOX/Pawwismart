import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppRoundImage extends StatelessWidget {
  final ImageProvider provider;
  final double height;
  final double wight;

  AppRoundImage(this.provider, {required this.height, required this.wight});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Image(
        image: provider,
        height: height,
        width: wight,
      ),
    );
  }

  factory AppRoundImage.url(String url,
      {required double height, required double width}) {
    return AppRoundImage(NetworkImage(url), height: height, wight: width);
  }

  factory AppRoundImage.memory(Uint8List data,
      {required double height, required double wight}) {
    return AppRoundImage(MemoryImage(data), height: height, wight: wight);
  }
}
