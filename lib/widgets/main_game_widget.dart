import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_api.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/style/text_styles.dart';
import 'package:wikigame/widgets/article_expansion_tile.dart';
import 'package:wikigame/widgets/game_handler.dart';
import 'package:wikigame/widgets/success_widget.dart';

class MainGameWidget extends StatefulWidget {
  final WikiArticle startArticle, goalArticle;
  final GameHandlerWidgetState gameHandler;

  const MainGameWidget({this.startArticle, this.goalArticle, this.gameHandler});

  @override
  State<StatefulWidget> createState() => MainGameWidgetState(startArticle: this.startArticle, goalArticle: this.goalArticle, gameHandler: this.gameHandler);
}

class MainGameWidgetState extends State<MainGameWidget> {
  final WikiArticle startArticle, goalArticle;
  final GameHandlerWidgetState gameHandler;

  List<Widget> linkWidgets = List<Widget>();
  List<WikiArticle> clickedLinks = List<WikiArticle>();
  bool goalReached = false;

  MainGameWidgetState({this.startArticle, this.goalArticle, this.gameHandler});

  @override
  void initState() {
    super.initState();

    this.clickedLinks.add(this.startArticle);
    this.fetchLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(this.clickedLinks.last.title),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 1.0,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () { this.gameHandler.stopGame(); }),),
      body:
        // check whether the goal has been reached. show congrats text when true
        this.goalReached ? SuccessWidget(clickedLinks: this.clickedLinks) :
        // goal not reached
        this.linkWidgets.isEmpty ?
        // show progress indicator until data has been fetched
        Center(child: CircularProgressIndicator()) :
        // show fetched data
        // ListView.builder constructor will create items as they are scrolled onto the screen
        // This is more efficient then the default ListView constructor
        ListView.builder(
          itemCount: this.linkWidgets.length,
          itemBuilder: (context, index) {
            return this.linkWidgets[index];
          }
        ),
    );
  }

  /// Calls the wiki api for links on the current article and
  /// generates a list of these links as well as a 'header' with information
  /// about the current goal.
  void fetchLinks() async {
    var links = await fetchArticleLinksByTitle(this.clickedLinks.last.title);

    // first row of the list should be the header
    var header = Column(
      children: <Widget>[
        HeaderText(text: "Ziel"),
        ArticleExpansionTile(article: goalArticle,),
        HeaderText(text: "Mögliche Links"),
      ],
    );

    linkWidgets.add(header);

    // create Text widgets to show the links in the listview
    for (var l in links) {
      linkWidgets.add(
        ListTile(
          title: Text(l),
          onTap: () => linkTapped(l),
        )
        /*FlatButton(
          onPressed: () => linkTapped(l),
          child: Text(l, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),)
        ),*/
      );
    }

    this.setState((){});
  }

  /// Called when the user taps a link.
  /// Appends the selected article to the clickedLinks list and
  /// refreshes the site with the new article.
  void linkTapped(String title) async {
    final tappedArticle = await createArticleFromTitle(title);
    this.clickedLinks.add(tappedArticle);
    this.linkWidgets.clear();

    // check whether the user reached the goal
    if (goalArticle.id == tappedArticle.id) {
      this.goalReached = true;
    }

    setState(() {
      if (!this.goalReached) {
        this.fetchLinks();
      }
    });
  }

}