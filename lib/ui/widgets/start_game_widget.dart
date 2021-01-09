import 'package:flutter/material.dart';
import 'package:wikigame/ui/style/text_styles.dart';
import 'package:wikigame/ui/widgets/article_tile.dart';
import 'package:wikigame/ui/widgets/game_handler.dart';

class StartGameWidget extends StatelessWidget {
  StartGameWidget({this.onStart, this.onFetch});

  final VoidCallback onStart, onFetch;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: HeaderText(text: 'Deine Artikel sind'),
                )
              ],
            ),
          ),
          ArticleTile(article: globalStartArticle, type: ArticleType.start,),
          ArticleTile(article: globalGoalArticle, type: ArticleType.goal,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              onPressed: onStart,
              child: ListText(text: 'Spiel starten'),
            ),
          ),
          FlatButton(
            onPressed: onFetch,
            child: ExplainText(text: 'Neue Artikel laden'),
          )
        ],
      ),
    );
  }
}