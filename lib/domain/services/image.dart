import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Loads SVG as well as normal images from network.
Widget getNetworkImage(String url, [BoxFit fit = BoxFit.cover]) {
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
