import 'package:flutter/material.dart';
import 'package:wikigame/app/data/models/wiki_article.dart';
import 'package:wikigame/ui/style/text_styles.dart';

import 'article_tile.dart';

/// This widget is presented when the user didn't find jesus within 5 moves
class FailWidget extends StatelessWidget {
  /// Constructor initializes the clickedLinks list
  const FailWidget({this.clickedLinks});

  /// A list of all articles that have been selected during the last game
  final List<WikiArticle> clickedLinks;

  @override
  Widget build(BuildContext context) {
    final text = HeaderText(text: 'Leider verloren. Versuche es doch erneut!');
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