import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_article.dart';

class ArticleScreenArguments {
  final WikiArticle article;
  ArticleScreenArguments(this.article);
}

class ArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Extract arguments from the current route and cast them as ArticleScreenArguments
    final ArticleScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(args.article.title),
                background: args.article.image,
              ),
            )
          ];
        },
        body: Center(
          child: Text(args.article.summary),
        ),
      ),
    );
  }
}