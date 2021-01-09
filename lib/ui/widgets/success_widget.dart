import 'package:flutter/material.dart';
import 'package:wikigame/data/models/wiki_article.dart';
import 'package:wikigame/ui/style/text_styles.dart';
import 'package:wikigame/ui/widgets/article_tile.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({this.clickedLinks});

  final List<WikiArticle> clickedLinks;

  @override
  Widget build(BuildContext context) {
    final text = HeaderText(text: 'Glückwunsch, Du hast das Ziel in ${clickedLinks.length-1} Zügen erreicht!');
    final list = ListView.builder(
      itemCount: clickedLinks.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
            child: text,
          );
        }

        return ArticleTile(article: clickedLinks[index-1],);
      }
    );

    return list;
  }
}