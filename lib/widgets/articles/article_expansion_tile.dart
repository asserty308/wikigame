import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/style/text_styles.dart';
import 'package:wikigame/widgets/articles/article_details_screen.dart';

class ArticleExpansionTile extends StatelessWidget {
  const ArticleExpansionTile({this.article});
  
  final WikiArticle article;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: ListText(text: article.title),
      color: Colors.transparent,
      onPressed: () {
        Navigator.pushNamed(
          context, 
          '/article_details', 
          arguments: ArticleScreenArguments(article),
        );
      },
    );
  }
}