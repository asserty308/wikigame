import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_api.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/style/text_styles.dart';
import 'package:wikigame/widgets/article_expansion_tile.dart';
import 'package:wikigame/widgets/game_handler.dart';
import 'package:wikigame/widgets/success_widget.dart';
import 'package:wikigame/widgets/fail_widget.dart';

class FiveToJesusWidget extends StatefulWidget {
  final WikiArticle startArticle;
  final GameHandlerWidgetState gameHandler;

  const FiveToJesusWidget({this.startArticle, this.gameHandler});

  @override
  State<StatefulWidget> createState() => FiveToJesusWidgetState(startArticle: this.startArticle, gameHandler: this.gameHandler);
}

class FiveToJesusWidgetState extends State<FiveToJesusWidget> {
  final WikiArticle startArticle;
  final GameHandlerWidgetState gameHandler;

  List<Widget> linkWidgets = List<Widget>();
  List<WikiArticle> clickedLinks = List<WikiArticle>();
  bool goalReached = false;
  bool tooManyMoves = false;

  FiveToJesusWidgetState({this.startArticle, this.gameHandler});

  @override
  void initState() {
    super.initState();

    this.clickedLinks.add(this.startArticle);
    this.fetchLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () { this.gameHandler.stopGame(); }),),
      body:
      // check whether the user needed too many moves
      this.tooManyMoves ? FailWidget(clickedLinks: this.clickedLinks,) :
      // check whether the goal has been reached. show congrats text when true
      this.goalReached ? SuccessWidget(clickedLinks: this.clickedLinks) :
      // goal not reached
      this.linkWidgets.isEmpty ? Center(child: CircularProgressIndicator()) :
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
    var jesus = await createArticleFromTitle("Jesus Christus");

    // first row of the list should be the header
    var header = Column(
      children: <Widget>[
        HeaderText(text: "Ziel"),
        ArticleExpansionTile(article: jesus),
        HeaderText(text: "Mögliche Links"),
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

    this.setState((){});
  }

  /// Called when the user taps a link.
  /// Appends the selected article to the clickedLinks list and
  /// refreshes the site with the new article.
  void linkTapped(String title) async {
    final tappedArticle = await createArticleFromTitle(title);
    var jesus = await createArticleFromTitle("Jesus Christus");

    this.clickedLinks.add(tappedArticle);
    this.linkWidgets.clear();

    if (this.clickedLinks.length >= 6) {
      this.tooManyMoves = true;
    } else if (jesus.id == tappedArticle.id) {
      this.goalReached = true;
    }

    setState(() {
      if (!this.goalReached) {
        this.fetchLinks();
      }
    });
  }

}