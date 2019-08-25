import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_api.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/style/text_styles.dart';
import 'package:wikigame/widgets/article_tile.dart';
import 'package:wikigame/widgets/game_handler.dart';
import 'package:wikigame/widgets/start_game_widget.dart';
import 'package:wikigame/widgets/success_widget.dart';

class ClassicGameScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ClassicGameScreenState();
}

class ClassicGameScreenState extends State<ClassicGameScreen> {
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
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(clickedLinks.isEmpty ? 'Klassischer Modus' : clickedLinks.last.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => showInfoDialog(context),
            ),
          ],
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
      ),
      onWillPop: () {
        return showPopDialog(context);
      },
    );
  }

  Widget buildClassicModeWidget() {
    return StartGameWidget(
      onStart: startGame,
      onFetch: fetchArticles,
    );
  }

  void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Info'),
          content: Text('In diesem Modus werden Start und Ziel zunächst zufällig ausgewählt. Du kannst die Artikel jedoch ändern, indem du den entsprechenden Artikel für einen Moment gedrückt hältst. Details zu einem Artikel erhältst du, wenn du diesen kurz antippst.'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop()
            )
          ],
        );
      }
    );
  }

  Future<bool> showPopDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Achtung'),
          content: Text('Möchtest du das Spiel wirklich beenden?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Nein'),
              onPressed: () => Navigator.pop(context, false), // only pop dialog
            ),
            FlatButton(
              child: Text('Ja'),
              onPressed: () => Navigator.pop(context, true), // pop screen
            ),
          ],
        );
      }
    );
  }

  void startGame() async {
    clickedLinks.add(globalStartArticle);
    gameStarted = true;
    fetchLinks();
  }

  void fetchArticles() async {
    // update state to show progress indicator
    setState(() {
      articlesFetched = false;
      clickedLinks.clear();
    });

    // load random articles
    var articles = await WikiAPI.getRandomArticles(2); // getRandomArticlesWithImage(2) is slow
    globalStartArticle = articles[0];
    globalGoalArticle = articles[1];

    // update state to display the fetched articles
    setState(() {
      articlesFetched = true;
    });
  }

  /// Calls the wiki api for links on the current article and
  /// generates a list of these links as well as a 'header' with information
  /// about the current goal.
  void fetchLinks() async {
    var mightContainGoal = <String>[];
    var links = await WikiAPI.fetchArticleLinksByTitle(clickedLinks.last.title);

    // filter out links starting with the first letter of the "goal article" and add them to the mightContainGoal list
    links.removeWhere((i) {
      var filterOut = i.toLowerCase().startsWith(globalGoalArticle.title[0].toLowerCase());

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
        ArticleTile(article: globalGoalArticle,),
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
    final tappedArticle = await WikiArticle.createFromTitle(title);
    clickedLinks.add(tappedArticle);
    linkWidgets.clear();

    // check whether the user reached the goal
    if (globalGoalArticle.id == tappedArticle.id) {
      goalReached = true;
    }

    setState(() {
      if (!goalReached) {
        fetchLinks();
      }
    });
  }

}