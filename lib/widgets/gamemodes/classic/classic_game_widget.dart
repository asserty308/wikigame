import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_api.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/style/text_styles.dart';
import 'package:wikigame/widgets/articles/article_expansion_tile.dart';
import 'package:wikigame/widgets/success_widget.dart';

class ClassicGameWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ClassicGameWidgetState();
}

class ClassicGameWidgetState extends State<ClassicGameWidget> {
  List<WikiArticle> articles = <WikiArticle>[];
  bool articlesFetched = false;

  List<Widget> linkWidgets = <Widget>[];
  List<WikiArticle> clickedLinks = <WikiArticle>[];
  bool goalReached = false;
  bool gameStarted = false;

  @override
  void initState() {
    super.initState();

    fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Klassischer Modus'),
      ),
      body:
        !articlesFetched ? Center(child: CircularProgressIndicator()) : 
        !gameStarted ? buildClassicModeWidget() :
        // check whether the goal has been reached. show congrats text when true
        goalReached ? SuccessWidget(clickedLinks: clickedLinks) :
        // goal not reached
        linkWidgets.isEmpty ?
        // show progress indicator until data has been fetched
        Center(child: CircularProgressIndicator()) :
        // show fetched data
        // ListView.builder constructor will create items as they are scrolled onto the screen
        // This is more efficient then the default ListView constructor
        ListView.builder(
          itemCount: linkWidgets.length,
          itemBuilder: (context, index) {
            return linkWidgets[index];
          }
        ),
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
          ArticleExpansionTile(article: articles[0],),
          ArticleExpansionTile(article: articles[1],),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              onPressed: startRandomGame,
              child: ListText(text: 'Spiel starten'),
              color: Colors.red,
            ),
          ),
          FlatButton(
            onPressed: fetchArticles,
            child: ExplainText(text: 'Neue Artikel laden'),
          )
        ],
      ),
    );
  }

  void startRandomGame() async {
    gameStarted = true;
    fetchLinks();
  }

  void fetchArticles() async {
    clickedLinks.clear();
    articles = await getRandomArticles(2);
    articlesFetched = true;
    clickedLinks.add(articles[0]);

    setState(() { 
    });
  }

  /// Calls the wiki api for links on the current article and
  /// generates a list of these links as well as a 'header' with information
  /// about the current goal.
  void fetchLinks() async {
    var mightContainGoal = <String>[];
    var links = await fetchArticleLinksByTitle(clickedLinks.last.title);

    // filter out links starting with the first letter of the "goal article" and add them to the mightContainGoal list
    links.removeWhere((i) {
      var filterOut = i.toLowerCase().startsWith(articles[1].title[0].toLowerCase());

      if (filterOut) {
        mightContainGoal.add(i);
      }

      return filterOut;
    });

    mightContainGoal.sort();
    links.sort();

    // first row of the list should be the header
    final header = Column(
      children: <Widget>[
        HeaderText(text: 'Ziel'),
        ArticleExpansionTile(article: articles[1],),
        HeaderText(text: 'Mögliche Links'),
      ],
    );

    linkWidgets.add(header);

    // add mightContainGoal
    for (var l in mightContainGoal) {
      linkWidgets.add(
        ListTile(
          title: ListText(text: l),
          onTap: () => linkTapped(l),
        )
      );
    }

    // create Text widgets to show the links in the listview
    for (var l in links) {
      linkWidgets.add(
        ListTile(
          title: ListText(text: l),
          onTap: () => linkTapped(l),
        )
      );
    }

    setState((){});
  }

  /// Called when the user taps a link.
  /// Appends the selected article to the clickedLinks list and
  /// refreshes the site with the new article.
  void linkTapped(String title) async {
    final tappedArticle = await createArticleFromTitle(title);
    clickedLinks.add(tappedArticle);
    linkWidgets.clear();

    // check whether the user reached the goal
    if (articles[1].id == tappedArticle.id) {
      goalReached = true;
    }

    setState(() {
      if (!goalReached) {
        fetchLinks();
      }
    });
  }

}