import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageHelper {
  static Widget fromUrl(String imageUrl, [BoxFit fit = BoxFit.cover]) {
    // svg images are loaded with flutter_svg because the default implementation doesn't support svg's yet
    if (imageUrl.endsWith('.svg')) {
      return SvgPicture.network(
        imageUrl,
        fit: fit,
      );
    }

    return Image.network(
      imageUrl,
      fit: fit,
    );
  }
}