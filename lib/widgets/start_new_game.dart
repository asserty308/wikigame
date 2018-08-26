import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_api.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/widgets/game_handler.dart';

class StartNewGameWidget extends StatefulWidget {
  final GameHandlerWidgetState gameHandler;

  StartNewGameWidget(this.gameHandler) : super();

  @override
  State<StatefulWidget> createState() => StartNewGameWidgetState(this.gameHandler);
}

class StartNewGameWidgetState extends State<StartNewGameWidget> {
  final GameHandlerWidgetState gameHandler;
  bool articlesFetched = false;
  List<WikiArticle> articles;

  StartNewGameWidgetState(this.gameHandler) : super();

  @override
  void initState() {
    super.initState();
    this.fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !articlesFetched ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Willkommen! Dies sind Deine Wörter.", style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ExpansionTile(
                title: Text(articles[0].title),
                children: <Widget>[
                  Text(articles[0].summary)
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ExpansionTile(
                title: Text(articles[1].title),
                children: <Widget>[
                  Text(articles[1].summary)
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RaisedButton(
                onPressed: startNewGame,
                child: Text("Spiel starten", style: TextStyle(color: Colors.white),),
                color: Colors.blue,
              ),
            ),
            FlatButton(
              onPressed: fetchArticles,
              child: Text("Neue Wörter laden"),
            )
          ],
        ),
      ),
    );
  }

  void startNewGame() {
    this.gameHandler.startGame();
  }

  void fetchArticles() async {
    this.articles = await getRandomArticles(2);

    setState(() {
      this.articlesFetched = true;
    });
  }
}