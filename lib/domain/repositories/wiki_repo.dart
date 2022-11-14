import 'package:get_it/get_it.dart';
import 'package:wikigame/data/datasources/wiki_api.dart';
import 'package:wikigame/data/models/wiki_article.dart';

class WikiRepo {
  final _api = GetIt.I<WikiApi>();

  Future<List<WikiArticle>> getRandomArticles(int amount) async => _api.getRandomArticles(amount);
}
