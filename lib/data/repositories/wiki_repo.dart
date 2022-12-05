import 'package:wikigame/data/datasources/wiki_api.dart';
import 'package:wikigame/data/models/wiki_article.dart';

class WikiRepo {
  final _api = WikiApi();

  Future<List<WikiArticle>> getRandomArticles(int amount) async => _api.getRandomArticles(amount);

  Future<List<WikiArticle>> searchArticles(String searchTerm) async => _api.searchArticles(searchTerm);

  Future<String?> getArticleImageUrl(int id) async => _api.getArticleImageUrl(id);
}
