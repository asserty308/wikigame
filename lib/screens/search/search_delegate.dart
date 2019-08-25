import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_api.dart';
import 'package:wikigame/api/wiki_article.dart';
import 'package:wikigame/style/text_styles.dart';

class ArticleSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return showSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return showSearchResults();
  }

  Widget showSearchResults() {
    var articles = WikiAPI.searchArticles(query);

    return FutureBuilder<List<WikiArticle>>(
      future: articles,
      builder: (BuildContext context, AsyncSnapshot<List<WikiArticle>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var widgetList = <Widget>[];

          if (snapshot.data == null) {
            return Center(child: Text('Keine Artikel gefunden'));
          }

          for (var article in snapshot.data) {
            widgetList.add(
              ListTile(
                title: HeaderText(text: article.title),
                onTap: () {
                  Navigator.pop(context, article); // pop search delegate
                  Navigator.pop(context, article); // pop screen
                },
              )
            );
          }

          return ListView.builder(
            itemCount: widgetList.length,
            itemBuilder: (context, index) {
              return widgetList[index];
            }
          );
        }

        // show progress indicator when search results aren't available
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

}