import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_article.dart';

class ArticleExpansionTile extends StatelessWidget {
  final WikiArticle article;

  const ArticleExpansionTile({this.article});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(article.title),
      children: <Widget>[
        Text(article.summary)
      ],
    );
  }

}