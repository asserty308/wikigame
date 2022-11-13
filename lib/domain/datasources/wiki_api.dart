import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:wikigame/domain/models/wiki_article.dart';
import 'package:wikigame/domain/services/image.dart';

class WikiApi {
  /// The base url to query the wikipedia api
  final _baseUrl = 'de.wikipedia.org';

  /// Wrapper to fetch JSON from the API
  Future<Map<String, dynamic>> _getJSON(Uri url) async {
    final response = await http.get(url);
    return json.decode(response.body);
  }

  /// Calls the Wikipedia API for random articles.
  /// Returns the given amount of articles.
  Future<List<WikiArticle>> getRandomArticles(int amount) async {
    final uri = Uri.https(_baseUrl, 'w/api.php', {
      'action': 'query',
      'format': 'json',
      'list': 'random',
      'rnlimit': amount,
      'rnnamespace': 0,
    });

    final response = await _getJSON(uri);
    final randomArticles = response['query']['random'] as List<Map<String, dynamic>>;

    return randomArticles.map(WikiArticle.fromJSON).toList();
  }

  /// Fetches the id of the article by a given title
  Future<int> fetchIDFromTitle(String title) async {
    final uri = Uri.https(_baseUrl, 'w/api.php', {
      'action': 'query',
      'format': 'json',
      'titles': title,
      'formatversion': 2,
    });

    final response = await _getJSON(uri);
    return response['query']['pages'][0]['pageid'];
  }

  /// Fetches the summary for the article with the given id
  Future<String> fetchArticleSummary(int id) async {
    // The url to fetch the summary.
    // formatversion=2 makes sure, that the response pages are returned as json array.
    // This is needed because the id of an article could not be valid anymore because of
    // a redirect. (example on german wiki: Filmindustrie (1566124) became Filmwirtschaft (202198))
    final uri = Uri.https(_baseUrl, 'w/api.php', {
      'action': 'query',
      'format': 'json',
      'prop': 'extracts&exintro&explaintext',
      'redirects': 1,
      'pageids': id,
      'formatversion': 2,
    });

    final response = await _getJSON(uri);

    // get page object
    final pageObj = response['query']['pages'][0];

    if (pageObj.containsKey('extract')) {
      return pageObj['extract'];
    }

    return 'Zusammenfassung nicht verfügbar.';
  }

  Future<Widget?> fetchArticleImage(int id) async {
    final uri = Uri.https(_baseUrl, 'w/api.php', {
      'action': 'query',
      'format': 'json',
      'prop': 'pageimages',
      'piprop': 'original',
      'redirects': 1,
      'pageids': id,
      'formatversion': 2,
    });

    final response = await _getJSON(uri);

    final pageObj = response['query']['pages'][0];

    if (pageObj.containsKey('original')) {
      var imageUrl = pageObj['original']['source'];

      // Image lib does not support SVG images yet
      log('Loading image url $imageUrl');
      return getNetworkImage(imageUrl);
    }

    return null;
  }

  /// Fetches all links in the article which lead to other wikipedia articles.
  /// The links are returned as a list of the titles of the article.
  Future<List<String>> fetchArticleLinksByTitle(String title) async {
    final uri = Uri.https(_baseUrl, 'w/api.php', {
      'action': 'query',
      'format': 'json',
      'prop': 'links',
      'pllimit': 'max',
      'titles': title,
      'formatversion': 2,
    });

    var response = await _getJSON(uri);

    final links = <String>[];

    while (true) {
      // parse page object
      final pageObj = response['query']['pages'][0];
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
      if (!response.containsKey('continue')) {
        // continue key not available -> all links fetched
        break;
      }

      // start new request
      final contParam = response['continue']['plcontinue'];
      uri.queryParameters.addAll({'plcontinue': contParam});
      response = await _getJSON(uri);
    }

    return links;
  }

  /// Fetches an article by a given category
  Future<List<String>> fetchArticlesWithCategory(String category) async {
    final uri = Uri.https(_baseUrl, 'w/api.php', {
      'action': 'query',
      'format': 'json',
      'cmnamespace': 0,
      'list': 'categorymembers',
      'cmtitle': 'Category:$category',
    });

    final response = await _getJSON(uri);
    return response['query']['pages'][0]['pageid'];
  }

  Future<List<WikiArticle>> searchArticles(String searchTerm) async {
    final articles = <WikiArticle>[];

    // perform a search for titles containing the searchTerm
    final uri = Uri.https(_baseUrl, 'w/api.php', {
      'action': 'query',
      'format': 'json',
      'list': 'search',
      'srsearch': searchTerm,
    });
    final response = await _getJSON(uri);
    final query = response['query'];

    if (query == null) {
      return articles;
    }

    // fetch both articles from response and convert them to WikiArticle
    for (var articleJSON in query['search']) {
      articles.add(WikiArticle.fromJSON(articleJSON, idKey: 'pageid'));
    }

    return articles;
  }
}
