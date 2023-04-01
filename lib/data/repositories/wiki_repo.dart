import 'package:wikigame/data/datasources/wiki_api.dart';
import 'package:wikigame/data/models/wiki_article.dart';

class WikiRepo {
  final _api = WikiApi();

  /// Fetches a list of random articles.
  Future<List<WikiArticle>> getRandomArticles(int amount) async => _api.getRandomArticles(amount);

  /// Searches for articles by a given search term.
  Future<List<WikiArticle>> searchArticles(String searchTerm) async => _api.searchArticles(searchTerm);

  /// Fetches the article with the given id.
  Future<String?> getArticleImageUrl(int id) async => _api.getArticleImageUrl(id);
}
