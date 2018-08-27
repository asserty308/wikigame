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

  final pageObj = responseJSON["query"]["pages"]["$id"];

  if (pageObj.containsKey("extract")) {
    return pageObj["extract"];
  }

  return "Zusammenfassung nicht verfügbar.";
}

/*Future<List<String>> fetchArticleLinks(int id) async {
  var url = "$wikiQueryUrl&prop=links&pllimit=max&pageids=$id";

  var response = await http.get(url);
  var responseJSON = json.decode(response.body);

  List<String> links = List<String>();

  while (true) {
    // fetch all links from response and add them to the link list
    for (var linkObj in responseJSON["query"]["pages"]["$id"]["links"]) {
      if (linkObj["ns"] != 0) {
        // link is not an article
        continue;
      }

      links.add(linkObj["title"]);
    }

    // check for continue key: ['continue']['plcontinue'] is available when
    // the link limit of 500 has been reached. To get all links, another
    // request must be made with the param in 'plcontinue' attached.
    final contObj = responseJSON['continue'];
    if (contObj == null) {
      // continue key not available -> all links fetched
      break;
    }

    final contParam = contObj['plcontinue'];
    response = await http.get("$url&$contParam");
    responseJSON = json.decode(response.body);
  }

  return links;
}*/

Future<List<String>> fetchArticleLinksByTitle(String title) async {
  var url = "$wikiQueryUrl&prop=links&pllimit=max&titles=$title&formatversion=2";

  var response = await http.get(url);
  var responseJSON = json.decode(response.body);

  List<String> links = List<String>();

  while (true) {
    // parse page object
    var pageObj = responseJSON["query"]["pages"][0];
    var pageLinks = pageObj["links"];

    // fetch all links from response and add them to the link list
    for (var linkObj in pageLinks) {
      if (linkObj["ns"] != 0) {
        // link is not an article
        continue;
      }

      links.add(linkObj["title"]);
    }

    // check for continue key: ['continue']['plcontinue'] is available when
    // the link limit of 500 has been reached. To get all links, another
    // request must be made with the param in 'plcontinue' attached.
    if (!responseJSON.containsKey('continue')) {
      // continue key not available -> all links fetched
      break;
    }

    // start new request
    final contParam = responseJSON['continue']['plcontinue'];
    response = await http.get("$url&plcontinue=$contParam");
    responseJSON = json.decode(response.body);
  }

  return links;
}