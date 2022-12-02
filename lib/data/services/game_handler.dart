import 'package:wikigame/data/models/wiki_article.dart';

/// Set when a new game has started. Unset when any game ends.
GameHandler? currentGame;

class GameHandler {
  GameHandler._(this.from, this.to);

  factory GameHandler.newGame(WikiArticle from, WikiArticle to) => GameHandler._(from, to);

  final WikiArticle from;
  final WikiArticle to;

  final _selectedArticles = <WikiArticle>[];

  List<WikiArticle> get selectedArticles => _selectedArticles;

  void pushArticle(WikiArticle article) => _selectedArticles.add(article);
  
  WikiArticle popArticle() => _selectedArticles.removeLast();

  bool get endReached => _selectedArticles.isEmpty ? false : (_selectedArticles.last.id == to.id);
}
