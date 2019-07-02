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
  List<WikiArticle> articles = List<WikiArticle>();

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
          this.gameHandler.gameMode == GameModes.classic ? HeaderText(text: "Klassischer Modus") :
          this.gameHandler.gameMode == GameModes.fiveToJesus ? HeaderText(text: "5 Klicks bis Jesus") : HeaderText(text: "Zeitdruck",),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,),
      body: !articlesFetched ? Center(child: CircularProgressIndicator()) :
        this.gameHandler.gameMode == GameModes.fiveToJesus ? this.buildFiveToJesusWidget() :
        this.gameHandler.gameMode == GameModes.classic ? this.buildClassicModeWidget() : this.buildTimeTrialsWidget(),
    );
  }

  Widget buildClassicModeWidget() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BodyText(text: "In diesem Modus werden Start und Ziel zufällig ausgewählt"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: HeaderText(text: "Deine Artikel sind"),
                )
              ],
            ),
          ),
          ArticleExpansionTile(article: articles[0],),
          ArticleExpansionTile(article: articles[1],),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              onPressed: startNewGame,
              child: ListText(text: "Spiel starten"),
              color: Colors.red,
            ),
          ),
          FlatButton(
            onPressed: fetchArticles,
            child: ExplainText(text: "Neue Wörter laden"),
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BodyText(text: "In diesem Modus muss von einem beliebigen Artikel innerhalb von 5 Klicks der Artikel 'Jesus Christus' erreicht werden."),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: HeaderText(text: "Deine Artikel sind"),
                )
              ],
            ),
          ),
          ArticleExpansionTile(article: articles[0],),
          ArticleExpansionTile(article: articles[1],),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              onPressed: startNewGame,
              child: ListText(text: "Spiel starten"),
              color: Colors.red,
            ),
          ),
          FlatButton(
            onPressed: fetchArticles,
            child: ExplainText(text: "Neue Wörter laden"),
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
            padding: const EdgeInsets.all(8.0),
            child: BodyText(text: "Dieser Modus ist leider noch nicht verfügbar"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: goBack,
              child: ListText(text: "Zurück"),
              color: Colors.red,
            ),
          ),
        ]
      )
    );
  }

  void startNewGame() {
    this.gameHandler.startGame(articles[0], articles[1]);
  }

  void goBack() {
    this.gameHandler.setState(() =>
      this.gameHandler.gameState = GameStates.menu
    );
  }

  void fetchArticles() async {
    if (this.gameHandler.gameMode == GameModes.classic) {
      this.articles = await getRandomArticles(2);
    } else if (this.gameHandler.gameMode == GameModes.fiveToJesus) {
      var rand = await getRandomArticles(1);
      var jesus = await createArticleFromTitle("Jesus Christus");
      this.articles.add(rand[0]);
      this.articles.add(jesus);
    }

    setState(() {
      this.articlesFetched = true;
    });
  }
}