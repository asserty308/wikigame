import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wikigame/data/models/wiki_article.dart';
import 'package:wikigame/data/repositories/wiki_repo.dart';
import 'package:wikigame/ui/widgets/app_image.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    super.key,
    required this.article,
  });

  final WikiArticle article;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _imageContainer,
      Text(article.title),
    ],
  );
  
  Widget get _imageContainer => Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    child: _image,
  );

  Widget get _image => FutureBuilder<String?>(
    future: GetIt.I<WikiRepo>().getArticleImageUrl(article.id),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        // Loading
        return const CircularProgressIndicator.adaptive();
      }

      final url = snapshot.data;

      if (url == null) {
        return ColoredBox(
          color: Colors.blueGrey.shade100,
          child: const Icon(Icons.image_outlined),
        );
      }

      return AppImage(url: url);
    },
  );
}
