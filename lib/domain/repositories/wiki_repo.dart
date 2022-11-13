import 'package:get_it/get_it.dart';
import 'package:wikigame/domain/datasources/wiki_api.dart';
import 'package:wikigame/domain/models/wiki_article.dart';

class WikiRepo {
  final _api = GetIt.I<WikiApi>();

  Future<List<WikiArticle>> getRandomArticles(int amount) async => _api.getRandomArticles(amount);
}
