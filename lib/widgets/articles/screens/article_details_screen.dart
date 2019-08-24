import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_api.dart';
import 'package:wikigame/api/wiki_article.dart';

class ArticleScreenArguments {
  final WikiArticle article;
  ArticleScreenArguments(this.article);
}

/// Must be called as follows
/// Navigator.pushNamed(
///   context, 
///   '/article_details', 
///   arguments: ArticleScreenArguments(article),
/// );
class ArticleScreen extends StatefulWidget {
  createState() => ArticleScreenState();
}

class ArticleScreenState extends State<ArticleScreen> {
  ArticleScreenArguments args;
  Widget sliverBackground;

  @override
  void initState() {
    super.initState();

    // run 'afterFirstlayout' after first build()
    WidgetsBinding.instance.addPostFrameCallback((_) => afterFirstlayout(context));
  }

  @override
  Widget build(BuildContext context) {
    // Extract arguments from the current route and cast them as ArticleScreenArguments
    args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(args.article.title),
                background: sliverBackground,
              ),
            )
          ];
        },
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(args.article.summary),
        ),
      ),
    );
  }

  void afterFirstlayout(BuildContext context) {
    fetchBackground();
  }

  void fetchBackground() async {
    sliverBackground = await fetchArticleImage(args.article.id);
    setState(() { 
    });
  }

}