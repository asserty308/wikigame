import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_api.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/style/text_styles.dart';
import 'package:wikigame/widgets/article_expansion_tile.dart';
import 'package:wikigame/widgets/game_handler.dart';
import 'package:wikigame/widgets/success_widget.dart';

class ClassicGameWidget extends StatefulWidget {
  const ClassicGameWidget({this.startArticle, this.goalArticle, this.gameHandler});

  final WikiArticle startArticle, goalArticle;
  final GameHandlerWidgetState gameHandler;

  @override
  State<StatefulWidget> createState() => ClassicGameWidgetState(startArticle: startArticle, goalArticle: goalArticle, gameHandler: gameHandler);
}

class ClassicGameWidgetState extends State<ClassicGameWidget> {
  ClassicGameWidgetState({this.startArticle, this.goalArticle, this.gameHandler});

  final WikiArticle startArticle, goalArticle;
  final GameHandlerWidgetState gameHandler;

  List<Widget> linkWidgets = <Widget>[];
  List<WikiArticle> clickedLinks = <WikiArticle>[];
  bool goalReached = false;

  @override
  void initState() {
    super.initState();

    clickedLinks.add(startArticle);
    fetchLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: gameHandler.stopGame),),
      body:
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

  /// Calls the wiki api for links on the current article and
  /// generates a list of these links as well as a 'header' with information
  /// about the current goal.
  void fetchLinks() async {
    final links = await fetchArticleLinksByTitle(clickedLinks.last.title);

    // first row of the list should be the header
    final header = Column(
      children: <Widget>[
        HeaderText(text: 'Ziel'),
        ArticleExpansionTile(article: goalArticle,),
        HeaderText(text: 'Mögliche Links'),
      ],
    );

    linkWidgets.add(header);

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
    if (goalArticle.id == tappedArticle.id) {
      goalReached = true;
    }

    setState(() {
      if (!goalReached) {
        fetchLinks();
      }
    });
  }

}