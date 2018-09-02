import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_api.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/style/text_styles.dart';
import 'package:wikigame/widgets/article_expansion_tile.dart';
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
    // show progress indicator until articles have been fetched
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Wikigame"), centerTitle: true, backgroundColor: Colors.black, elevation: 1.0,),
      body: !articlesFetched ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: HeaderText(text: "Willkommen! Dies sind Deine Wörter."),
            ),
            ArticleExpansionTile(article: articles[0],),
            ArticleExpansionTile(article: articles[1],),
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
    this.gameHandler.startGame(articles[0], articles[1]);
  }

  void fetchArticles() async {
    this.articles = await getRandomArticles(2);

    setState(() {
      this.articlesFetched = true;
    });
  }
}