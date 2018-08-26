import 'dart:async';
import 'dart:convert'; // json
import 'package:http/http.dart' as http;

import 'package:wikigame/api/wiki_article.dart';

final wikiQueryUrl = "https://de.wikipedia.org/w/api.php?action=query&format=json";

/// Calls the Wikipedia API for random articles.
/// Returns the given amount of articles.
Future<List<WikiArticle>> getRandomArticles(int amount) async {
  var url = "$wikiQueryUrl&list=random&rnlimit=$amount&rnnamespace=0";

  final response = await http.get(url);
  final responseJSON = json.decode(response.body);

  List<WikiArticle> articles = List<WikiArticle>();

  // fetch both articles from response and convert them to WikiArticle
  for (var articleJSON in responseJSON["query"]["random"]) {
    articles.add(await createArticleFromJSON(articleJSON));
  }

  return articles;
}

/// Fetches the summary for the article with the given id
Future<int> fetchIDFromTitle(String title) async {
  var url = "$wikiQueryUrl&titles=$title&formatversion=2";

  final response = await http.get(url);
  final responseJSON = json.decode(response.body);

  return responseJSON["query"]["pages"][0]["pageid"];
}

/// Fetches the summary for the article with the given id
Future<String> fetchArticleSummary(int id) async {
  var url = "$wikiQueryUrl&prop=extracts&exintro&explaintext&redirects=1&pageids=$id";

  final response = await http.get(url);
  final responseJSON = json.decode(response.body);

  return responseJSON["query"]["pages"]["$id"]["extract"];
}

Future<List<String>> fetchArticleLinks(int id) async {
  var url = "$wikiQueryUrl&prop=links&pllimit=500&pageids=$id";

  final response = await http.get(url);
  final responseJSON = json.decode(response.body);

  List<String> links = List<String>();

  // fetch both articles from response and convert them to WikiArticle
  for (var linkObj in responseJSON["query"]["pages"]["$id"]["links"]) {
    if (linkObj["ns"] != 0) {
      // link is not an article
      continue;
    }
    
    links.add(linkObj["title"]);
  }

  return links;
}

Future<List<String>> fetchArticleLinksByTitle(String title) async {
  var url = "$wikiQueryUrl&prop=links&pllimit=500&titles=$title&formatversion=2";

  final response = await http.get(url);
  final responseJSON = json.decode(response.body);

  List<String> links = List<String>();

  var pageObj = responseJSON["query"]["pages"][0];

  // fetch both articles from response and convert them to WikiArticle
  for (var linkObj in pageObj["links"]) {
    if (linkObj["ns"] != 0) {
      // link is not an article
      continue;
    }

    links.add(linkObj["title"]);
  }

  return links;
}