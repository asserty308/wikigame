import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wikigame/app/data/datasources/wiki_api.dart';
import 'package:wikigame/app/data/models/wiki_article.dart';
import 'package:wikigame/ui/style/text_styles.dart';
import 'package:wikigame/ui/widgets/article_tile.dart';
import 'package:wikigame/ui/widgets/game_handler.dart';

class StartNewGameWidget extends StatefulWidget {
  const StartNewGameWidget(this.gameHandler) : super();

  final GameHandlerWidgetState gameHandler;

  @override
  State<StatefulWidget> createState() => StartNewGameWidgetState(gameHandler);
}

class StartNewGameWidgetState extends State<StartNewGameWidget> {
  StartNewGameWidgetState(this.gameHandler) : super();

  final GameHandlerWidgetState gameHandler;
  bool articlesFetched = false;
  List<WikiArticle> articles = <WikiArticle>[];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    // show progress indicator until articles have been fetched
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
          gameHandler.gameMode == GameMode.classic ? HeaderText(text: 'Klassischer Modus') :
          gameHandler.gameMode == GameMode.fiveToJesus ? HeaderText(text: '5 Klicks bis Jesus') : HeaderText(text: 'Zeitdruck',),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,),
      body: !articlesFetched ? Center(child: CircularProgressIndicator()) :
        gameHandler.gameMode == GameMode.fiveToJesus ? buildFiveToJesusWidget() :
        gameHandler.gameMode == GameMode.classic ? buildClassicModeWidget() : buildTimeTrialsWidget(),
    );
  }

  Widget buildClassicModeWidget() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BodyText(text: 'In diesem Modus werden Start und Ziel zufällig ausgewählt'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: HeaderText(text: 'Deine Artikel sind'),
                )
              ],
            ),
          ),
          ArticleTile(article: articles[0],),
          ArticleTile(article: articles[1],),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              onPressed: startNewGame,
              child: ListText(text: 'Spiel starten'),
            ),
          ),
          FlatButton(
            onPressed: fetchArticles,
            child: ExplainText(text: 'Neue Wörter laden'),
          )
        ],
      ),
    );
  }

  Widget buildFiveToJesusWidget() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BodyText(text: "In diesem Modus muss von einem beliebigen Artikel innerhalb von 5 Klicks der Artikel 'Jesus Christus' erreicht werden."),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: HeaderText(text: 'Deine Artikel sind'),
                )
              ],
            ),
          ),
          ArticleTile(article: articles[0],),
          ArticleTile(article: articles[1],),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              onPressed: startNewGame,
              child: ListText(text: 'Spiel starten'),
            ),
          ),
          FlatButton(
            onPressed: fetchArticles,
            child: ExplainText(text: 'Neue Wörter laden'),
          )
        ],
      ),
    );
  }

  Widget buildTimeTrialsWidget() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: const <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BodyText(text: 'In diesem Modus hast du zwei Minuten Zeit um das Ziel zu erreichen'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: HeaderText(text: 'Deine Artikel sind'),
                )
              ],
            ),
          ),
          ArticleTile(article: articles[0],),
          ArticleTile(article: articles[1],),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              onPressed: startNewGame,
              child: ListText(text: 'Spiel starten'),
            ),
          ),
          FlatButton(
            onPressed: fetchArticles,
            child: ExplainText(text: 'Neue Wörter laden'),
          )
        ],
      ),
    );
  }

  void startNewGame() {
    gameHandler.startGame(articles[0], articles[1]);
  }

  void goBack() {
    gameHandler.setState(() =>
      gameHandler.gameState = GameState.menu
    );
  }

  void fetchArticles() async {
    if (gameHandler.gameMode == GameMode.classic || gameHandler.gameMode == GameMode.twoMinTimeTrial) {
      articles = await GetIt.I<WikiAPI>().getRandomArticles(2);
    } else if (gameHandler.gameMode == GameMode.fiveToJesus) {
      final rand = await GetIt.I<WikiAPI>().getRandomArticles(1);
      final jesus = await WikiArticle.createFromTitle('Jesus Christus');
      articles
        ..add(rand[0])
        ..add(jesus);
    }

    setState(() {
      articlesFetched = true;
    });
  }
}