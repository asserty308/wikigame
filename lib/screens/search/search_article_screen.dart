import 'package:flutter/material.dart';
import 'package:wikigame/screens/search/search_delegate.dart';

class SearchArticleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchArticleScreenState();
}

class SearchArticleScreenState extends State<SearchArticleScreen> {
  @override
  void initState() {
    super.initState();

    // run 'afterFirstlayout' after first build()
    WidgetsBinding.instance.addPostFrameCallback((_) => afterFirstlayout(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artikel suchen'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () { 
              showSearch(
                context: context,
                delegate: ArticleSearchDelegate(),
              );
            }
          )
        ],
      ),
    );
  }

  void afterFirstlayout(BuildContext context) {
    // show search when showing screen
    showSearch(
      context: context,
      delegate: ArticleSearchDelegate(),
    );
  }
}
