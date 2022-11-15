import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wikigame/data/models/wiki_article.dart';

class WikiApi {
  /// The base url to query the wikipedia api
  final _baseUrl = 'de.wikipedia.org';

  Uri _buildUrl([Map<String, dynamic>? query]) => Uri.https(_baseUrl, 'w/api.php', query);

  /// Performs a GET request on [url] and decodes the result to a json object.
  Future<Map<String, dynamic>> _getJson(Uri url) async {
    final response = await http.get(url);
    return json.decode(response.body);
  }

  /// Calls the Wikipedia API for random articles.
  /// Returns the given amount of articles.
  Future<List<WikiArticle>> getRandomArticles(int amount) async {
    final url = _buildUrl({
      'action': 'query',
      'format': 'json',
      'list': 'random',
      'rnlimit': amount,
      'rnnamespace': 0,
    });

    final response = await _getJson(url);
    final randomArticles = response['query']['random'] as List;

    return randomArticles
      .map((item) => WikiArticle.fromJSON(item as Map<String, dynamic>))
      .toList();
  }

  /// Fetches the id of the article by a given title
  Future<int> getIdFromTitle(String title) async {
    final url = _buildUrl({
      'action': 'query',
      'format': 'json',
      'titles': title,
      'formatversion': 2,
    });

    final response = await _getJson(url);
    return response['query']['pages'][0]['pageid'] as int;
  }

  /// Fetches the summary for the article with the given id
  Future<String> getArticleSummary(int id) async {
    // The url to fetch the summary.
    // formatversion=2 makes sure, that the response pages are returned as json array.
    // This is needed because the id of an article could not be valid anymore because of
    // a redirect. (example on german wiki: Filmindustrie (1566124) became Filmwirtschaft (202198))
    final uri = _buildUrl({
      'action': 'query',
      'format': 'json',
      'prop': 'extracts&exintro&explaintext',
      'redirects': 1,
      'pageids': id,
      'formatversion': 2,
    });

    final response = await _getJson(uri);

    // get page object
    final pages = response['query']['pages'] as List;
    final page = WikiArticle.fromJSON(pages.first as Map<String, dynamic>, idKey: 'pageid');

    return page.extract ?? 'Summary not available.';
  }

  Future<String?> getArticleImageUrl(int id) async {
    final uri = _buildUrl({
      'action': 'query',
      'format': 'json',
      'prop': 'pageimages',
      'piprop': 'original',
      'redirects': 1,
      'pageids': id,
      'formatversion': 2,
    });

    final response = await _getJson(uri);

    final pageObj = response['query']['pages'][0];
    return pageObj['original']['source'] as String?;
  }

  /// Fetches all links in the article which lead to other wikipedia articles.
  /// The links are returned as a list of the titles of the article.
  Future<List<String>> getArticleLinksByTitle(String title) async {
    final uri = _buildUrl({
      'action': 'query',
      'format': 'json',
      'prop': 'links',
      'pllimit': 'max',
      'titles': title,
      'formatversion': 2,
    });

    var response = await _getJson(uri);

    final links = <String>[];

    while (true) {
      // parse page object
      final pageObj = response['query']['pages'][0];
      final pageLinks = pageObj['links'];

      // fetch all links from response and add them to the link list
      for (final linkObj in pageLinks) {
        if (linkObj['ns'] != 0) {
          // link is not an article
          continue;
        }

        links.add(linkObj['title']);
      }

      // check for continue key: ['continue']['plcontinue'] is available when
      // the link limit of 500 has been reached. To get all links, another
      // request must be made with the param in 'plcontinue' attached.
      if (!response.containsKey('continue')) {
        // continue key not available -> all links fetched
        break;
      }

      // start new request
      final contParam = response['continue']['plcontinue'];
      uri.queryParameters.addAll({'plcontinue': contParam});
      response = await _getJson(uri);
    }

    return links;
  }

  /// Fetches an article by a given category
  Future<List<String>> getArticlesWithCategory(String category) async {
    final uri = _buildUrl({
      'action': 'query',
      'format': 'json',
      'cmnamespace': 0,
      'list': 'categorymembers',
      'cmtitle': 'Category:$category',
    });

    final response = await _getJson(uri);
    return response['query']['pages'][0]['pageid'] as List<String>;
  }

  /// Perform a search for titles containing the searchTerm
  Future<List<WikiArticle>> searchArticles(String searchTerm) async {
    final uri = _buildUrl({
      'action': 'query',
      'format': 'json',
      'list': 'search',
      'srsearch': searchTerm,
    });
    
    final response = await _getJson(uri);
    final results = response['query']['search'] as List;

    return results
      .map((e) => WikiArticle.fromJSON(e as Map<String, dynamic>, idKey: 'pageid'))
      .toList();
  }
}
