import 'dart:async';
import 'dart:convert'; // json
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:wikigame/api/wiki_article.dart';

/// The base url to query the wikipedia api
const wikiQueryUrl = 'https://de.wikipedia.org/w/api.php?action=query&format=json';

/// Calls the Wikipedia API for random articles.
/// Returns the given amount of articles.
Future<List<WikiArticle>> getRandomArticles(int amount) async {
  final url = '$wikiQueryUrl&list=random&rnlimit=$amount&rnnamespace=0';

  final response = await http.get(url);
  final responseJSON = json.decode(response.body);

  final articles = <WikiArticle>[];

  // fetch both articles from response and convert them to WikiArticle
  for (var articleJSON in responseJSON['query']['random']) {
    articles.add(await createArticleFromJSON(articleJSON));
  }

  return articles;
}

/// Fetches the id of the article by a given title
Future<int> fetchIDFromTitle(String title) async {
  final url = '$wikiQueryUrl&titles=$title&formatversion=2';

  final response = await http.get(url);
  final responseJSON = json.decode(response.body);

  return responseJSON['query']['pages'][0]['pageid'];
}

/// Fetches the summary for the article with the given id
Future<String> fetchArticleSummary(int id) async {
  // The url to fetch the summary.
  // formatversion=2 makes sure, that the response pages are returned as json array.
  // This is needed because the id of an article could not be valid anymore because of
  // a redirect. (example on german wiki: Filmindustrie (1566124) became Filmwirtschaft (202198))
  final url = '$wikiQueryUrl&prop=extracts&exintro&explaintext&redirects=1&pageids=$id&formatversion=2';

  final response = await http.get(url);
  final responseJSON = json.decode(response.body);

  // get page object
  final pageObj = responseJSON['query']['pages'][0];

  if (pageObj.containsKey('extract')) {
    return pageObj['extract'];
  }

  return 'Zusammenfassung nicht verfügbar.';
}

Future<Image> fetchArticleImage(int id) async {
  final url = '$wikiQueryUrl&prop=pageimages&piprop=original&redirects=1&pageids=$id&formatversion=2';

  final response = await http.get(url);
  final responseJSON = json.decode(response.body);

  final pageObj = responseJSON['query']['pages'][0];

  if (pageObj.containsKey('original')) {
    var url = pageObj['original']['source'];
    return Image.network(
      url,
      fit: BoxFit.cover,
    );
  }

  return null;
}

/// Fetches all links in the article which lead to other wikipedia articles.
/// The links are returned as a list of the titles of the article.
Future<List<String>> fetchArticleLinksByTitle(String title) async {
  final url = '$wikiQueryUrl&prop=links&pllimit=max&titles=$title&formatversion=2';

  var response = await http.get(url);
  var responseJSON = json.decode(response.body);

  final links = <String>[];

  while (true) {
    // parse page object
    final pageObj = responseJSON['query']['pages'][0];
    final pageLinks = pageObj['links'];

    // fetch all links from response and add them to the link list
    for (var linkObj in pageLinks) {
      if (linkObj['ns'] != 0) {
        // link is not an article
        continue;
      }

      links.add(linkObj['title']);
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
    response = await http.get('$url&plcontinue=$contParam');
    responseJSON = json.decode(response.body);
  }

  return links;
}

/// Fetches an article by a given category
Future<List<String>> fetchArticlesWithCategory(String category) async {
  final url = '$wikiQueryUrl&cmnamespace=0&list=categorymembers&cmtitle=Category:$category';

  // TODO: Test
  final response = await http.get(url);
  final responseJSON = json.decode(response.body);

  return responseJSON['query']['pages'][0]['pageid'];
}

Future<List<WikiArticle>> searchArticles(String searchTerm) async {
  // perform a search for titles containing the searchTerm
  final url = '$wikiQueryUrl&list=search&srsearch=$searchTerm&srwhat=title';

  final response = await http.get(url);
  final responseJSON = json.decode(response.body);

  final articles = <WikiArticle>[];

  // fetch both articles from response and convert them to WikiArticle
  for (var articleJSON in responseJSON['query']['search']) {
    articles.add(await createArticleFromJSON(articleJSON));
  }

  return articles;
}