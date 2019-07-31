import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/style/text_styles.dart';
import 'package:wikigame/widgets/articles/screens/article_details_screen.dart';
import 'package:wikigame/widgets/game_handler.dart';
import 'package:wikigame/widgets/search/search_article_screen.dart';

enum ArticleType {
  start,
  goal,
  normal
}

class ArticleTile extends StatefulWidget {
  ArticleTile({this.article, this.type = ArticleType.normal});
  
  final WikiArticle article;
  final ArticleType type;

  @override
  State<StatefulWidget> createState() => ArticleTileState(article: article, type: type);
}

class ArticleTileState extends State<ArticleTile> {
  ArticleTileState({this.article, this.type = ArticleType.normal});
  
  WikiArticle article;
  final ArticleType type;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: ListText(text: article.title),
      onTap: () {
        Navigator.pushNamed(
          context, 
          '/article_details', 
          arguments: ArticleScreenArguments(article),
        );
      },
      onLongPress: () {
        if (type == ArticleType.normal) {
          // don't show search for non start/goal articles
          return;
        }

        showSearchAndWaitForSelection(context);
      }
    );
  }

  void showSearchAndWaitForSelection(BuildContext context) async {
    final WikiArticle result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => SearchArticleScreen()),
    );

    setState(() {
      if (result == null) {
        return;
      }

      if (type == ArticleType.start) {
        globalStartArticle = result;
      } else if (type == ArticleType.goal) {
        globalGoalArticle = result;
      }
      
      this.article = result;
    });
  }
}