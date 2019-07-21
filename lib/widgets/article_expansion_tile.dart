import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/style/text_styles.dart';

class ArticleExpansionTile extends StatelessWidget {
  const ArticleExpansionTile({this.article});
  
  final WikiArticle article;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ListText(text: article.title),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ExplainText(text: article.summary),
        )
      ],
    );
  }

}