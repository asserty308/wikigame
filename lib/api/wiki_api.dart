import 'dart:async';
import 'dart:convert'; // json
import 'package:http/http.dart' as http;

import 'package:wikigame/api/wiki_article.dart';

Future<List<WikiArticle>> getRandomArticles() async {
  var url = "https://de.wikipedia.org/w/api.php?action=query&format=json&list=random&rnlimit=2&rnnamespace=0";

  final response = await http.get(url);
  final responseJSON = json.decode(response.body);

  List<WikiArticle> articles = List<WikiArticle>();

  // todo: fetch both articles from response and convert them to WikiArticle

  return articles;
}