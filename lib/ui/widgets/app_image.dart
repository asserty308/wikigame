import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
  });

  /// The URL of the image to display.
  final String url;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (url.endsWith('.svg')) {
      return SvgPicture.network(
        url,
        fit: fit,
      );
    }

    return Image.network(
      url,
      fit: fit,
    );
  }
}
