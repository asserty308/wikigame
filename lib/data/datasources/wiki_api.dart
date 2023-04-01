import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wikigame/data/models/wiki_article.dart';

/// An exception that is thrown when the requested page was not found.
class PageNotFoundException implements Exception {}

/// A class that provides access to the wikipedia api.
class WikiApi {
  /// The base url to query the wikipedia api
  final _baseUrl = 'en.wikipedia.org';

  Uri _buildUrl([Map<String, String>? query]) => Uri.https(_baseUrl, 'w/api.php', query);

  /// Performs a GET request on [url] and decodes the result to a json object.
  Future<Map<String, dynamic>> _getJson(Uri url) async {
    final response = await http.get(url);
    return json.decode(response.body);
  }

  /// Calls the Wikipedia API for random articles.
  /// Returns the given amount of articles.
  /// 
  /// https://en.wikipedia.org/w/api.php?action=query&format=json&list=random&rnlimit=2&rnnamespace=0
  /// 
  /// {
  ///   "query":{
  ///     "random":[
  ///       {
  ///         "id":123,
  ///         "ns":0,
  ///         "title":"ABC"
  ///       },
  ///       {
  ///         "id":456,
  ///         "ns":0,
  ///         "title":"DEF"
  ///       }
  ///     ]
  ///   }
  /// }
  Future<List<WikiArticle>> getRandomArticles(int amount) async {
    final url = _buildUrl({
      'action': 'query',
      'format': 'json',
      'list': 'random',
      'rnlimit': '$amount',
      'rnnamespace': '0',
    });

    final response = await _getJson(url);
    final randomArticles = response['query']['random'] as List;

    return randomArticles
      .map((item) => WikiArticle.fromJson(item as Map<String, dynamic>))
      .toList();
  }

  /// Fetches the id of the article by a given title
  /// 
  /// https://en.wikipedia.org/w/api.php?action=query&format=json&titles=Flutter_(software)&formatversion=2
  /// 
  /// {
  ///   "query": {
  ///     "pages":[
  ///       {
  ///         "pageid":54699721,
  ///         "ns":0,
  ///         "title":"Flutter (software)"
  ///       }
  ///     ]
  ///   }
  /// }
  Future<int> getIdFromTitle(String title) async {
    final url = _buildUrl({
      'action': 'query',
      'format': 'json',
      'titles': title,
      'formatversion': '2',
    });

    final response = await _getJson(url);
    final pages = response['query']['pages'] as List;
    
    if (pages.isEmpty) {
      throw PageNotFoundException();
    }

    final article = WikiArticle.fromJson(pages.first as Map<String, dynamic>);
    return article.id;
  }

  /// Fetches the summary for the article with the given id
  /// 
  /// https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&exintro&explaintext&redirects=1&pageids=54699721&formatversion=2
  Future<String> getArticleExtract(int id) async {
    final url = _buildUrl({
      'action': 'query',
      'format': 'json',
      'prop': 'extracts&exintro&explaintext',
      'redirects': '1',
      'pageids': '$id',
      'formatversion': '2',
    });

    final response = await _getJson(url);

    // get page object
    final pages = response['query']['pages'] as List;

    if (pages.isEmpty) {
      throw PageNotFoundException();
    }

    final page = WikiArticle.fromJson(pages.first as Map<String, dynamic>);

    return page.extract ?? 'Summary not available.';
  }

  /// Returns the url of the image associated to the article with [id].
  /// 
  /// https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages&piprop=original&redirects=1&pageids=162510&formatversion=2
  Future<String?> getArticleImageUrl(int id) async {
    final url = _buildUrl({
      'action': 'query',
      'format': 'json',
      'prop': 'pageimages',
      'piprop': 'original',
      'redirects': '1',
      'pageids': '$id',
      'formatversion': '2',
    });

    final response = await _getJson(url);

    final pages = response['query']['pages'] as List;

    if (pages.isEmpty) {
      throw PageNotFoundException();
    }

    final page = pages.first;
    return page['original']['source'] as String?;
  }

  /// Fetches all links in the article which lead to other wikipedia articles.
  /// The links are returned as a list of the titles of the article.
  /// 
  /// https://en.wikipedia.org/w/api.php?action=query&format=json&prop=links&pllimit=max&titles=Flutter_(software)&formatversion=2
  Future<List<String>> getArticleLinksByTitle(String title) async {
    final url = _buildUrl({
      'action': 'query',
      'format': 'json',
      'prop': 'links',
      'pllimit': 'max',
      'titles': title,
      'formatversion': '2',
    });

    var response = await _getJson(url);

    final links = <String>[];

    while (true) {
      // parse page object
      final pages = response['query']['pages'] as List;

      if (pages.isEmpty) {
        throw PageNotFoundException();
      }

      final pageLinks = pages.first['links'] as List;

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
      url.queryParameters['plcontinue'] = contParam;
      response = await _getJson(url);
    }

    return links;
  }

  /// Fetches an article by a given category
  /// 
  /// https://en.wikipedia.org/w/api.php?action=query&format=json&cmnamespace=0&list=categorymembers&cmtitle=Category:Space
  Future<List<dynamic>> getArticlesWithCategory(String category) async {
    final url = _buildUrl({
      'action': 'query',
      'format': 'json',
      'cmnamespace': '0',
      'list': 'categorymembers',
      'cmtitle': 'Category:$category',
    });

    final response = await _getJson(url);
    return response['query']['categorymembers'] as List;
  }

  /// Perform a search for titles containing the searchTerm
  /// 
  /// https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=Flutter
  Future<List<WikiArticle>> searchArticles(String searchTerm) async {
    final url = _buildUrl({
      'action': 'query',
      'format': 'json',
      'list': 'search',
      'srsearch': searchTerm,
    });
    
    final response = await _getJson(url);
    final results = response['query']['search'] as List;

    return results
      .map((e) => WikiArticle.fromJson(e as Map<String, dynamic>))
      .toList();
  }
}
