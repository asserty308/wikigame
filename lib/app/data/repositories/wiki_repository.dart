import 'package:get_it/get_it.dart';
import 'package:wikigame/app/data/datasources/wiki_api.dart';
import 'package:wikigame/app/data/models/wiki_article.dart';

class WikiRepository {
  final WikiAPI wikiDatasource = GetIt.I<WikiAPI>();

  Future<List<WikiArticle>> getRandomArticles(int amount) async {
    return wikiDatasource.getRandomArticles(amount);
  }
}