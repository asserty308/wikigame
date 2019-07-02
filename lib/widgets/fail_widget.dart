import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/style/text_styles.dart';
import 'package:wikigame/widgets/article_expansion_tile.dart';

class FailWidget extends StatelessWidget {
  final List<WikiArticle> clickedLinks;

  const FailWidget({this.clickedLinks});

  @override
  Widget build(BuildContext context) {
    var text = HeaderText(text: "Leider konntest du Jesus nicht in 5 Zügen erreichen. Versuche es doch erneut!");
    var list = ListView.builder(
        itemCount: clickedLinks.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
              child: text,
            );
          }

          return ArticleExpansionTile(article: clickedLinks[index-1],);
        }
    );

    return list;
  }
}