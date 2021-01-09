import 'dart:async';
import 'dart:convert'; // json
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:wikigame/data/models/wiki_article.dart';
import 'package:wikigame/utils/image_utils.dart';

class WikiAPI {
  /// The base url to query the wikipedia api
  static final wikiQueryUrl = 'https://de.wikipedia.org/w/api.php?action=query&format=json';

  /// Wrapper to fetch JSON from the API
  static Future<dynamic> getJSON(String url) async {
    final response = await http.get(url);
    return json.decode(response.body);
  }

  /// Calls the Wikipedia API for random articles.
  /// Returns the given amount of articles.
  static Future<List<WikiArticle>> getRandomArticles(int amount) async {
    final responseJSON = await getJSON('$wikiQueryUrl&list=random&rnlimit=$amount&rnnamespace=0');

    final articles = <WikiArticle>[];

    for (var articleJSON in responseJSON['query']['random']) {
      var article = await WikiArticle.createFromJSON(articleJSON);
      articles.add(article);
    }

    return articles;
  }

  /// Calls the Wikipedia API for random articles.
  /// Returns the given amount of articles.
  /// The article must contain an image to be useful
  static Future<List<WikiArticle>> getRandomArticlesWithImage(int amount) async {
    final articles = <WikiArticle>[];

    // Search 'amount' articles containing an image
    while (articles.length < amount) {
      // Fetch one article per run until 'amount' articles are available.
      //var articleList = await getRandomArticles(1); 
      //var article = articleList[0];

      // When the fetched article contains an image it is added to the 'articles' list
      //if (article.image != null) {
      //  articles.add(article);
      //}
    }

    return articles;
  }

  /// Fetches the id of the article by a given title
  static Future<int> fetchIDFromTitle(String title) async {
    final responseJSON = await getJSON('$wikiQueryUrl&titles=$title&formatversion=2');
    return responseJSON['query']['pages'][0]['pageid'];
  }

  /// Fetches the summary for the article with the given id
  static Future<String> fetchArticleSummary(int id) async {
    // The url to fetch the summary.
    // formatversion=2 makes sure, that the response pages are returned as json array.
    // This is needed because the id of an article could not be valid anymore because of
    // a redirect. (example on german wiki: Filmindustrie (1566124) became Filmwirtschaft (202198))
    final url = '$wikiQueryUrl&prop=extracts&exintro&explaintext&redirects=1&pageids=$id&formatversion=2';
    final responseJSON = await getJSON(url);

    // get page object
    final pageObj = responseJSON['query']['pages'][0];

    if (pageObj.containsKey('extract')) {
      return pageObj['extract'];
    }

    return 'Zusammenfassung nicht verfügbar.';
  }

  static Future<Widget> fetchArticleImage(int id) async {
    final url = '$wikiQueryUrl&prop=pageimages&piprop=original&redirects=1&pageids=$id&formatversion=2';
    final responseJSON = await getJSON(url);

    final pageObj = responseJSON['query']['pages'][0];

    if (pageObj.containsKey('original')) {
      var imageUrl = pageObj['original']['source'];

      // Image lib does not support SVG images yet
      print('Loading image url $imageUrl');
      return ImageHelper.fromUrl(imageUrl);
    }

    return null;
  }

  /// Fetches all links in the article which lead to other wikipedia articles.
  /// The links are returned as a list of the titles of the article.
  static Future<List<String>> fetchArticleLinksByTitle(String title) async {
    final url = '$wikiQueryUrl&prop=links&pllimit=max&titles=$title&formatversion=2';
    var responseJSON = await getJSON(url);

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
      responseJSON = await getJSON('$url&plcontinue=$contParam');
    }

    return links;
  }

  /// Fetches an article by a given category
  static Future<List<String>> fetchArticlesWithCategory(String category) async {
    final url = '$wikiQueryUrl&cmnamespace=0&list=categorymembers&cmtitle=Category:$category';

    // TODO: Test
    final responseJSON = await getJSON(url);
    return responseJSON['query']['pages'][0]['pageid'];
  }

  static Future<List<WikiArticle>> searchArticles(String searchTerm) async {
    final articles = <WikiArticle>[];

    // perform a search for titles containing the searchTerm
    final url = '$wikiQueryUrl&list=search&srsearch=$searchTerm';
    final responseJSON = await getJSON(url);
    final query = responseJSON['query'];

    if (query == null) {
      return articles;
    }

    // fetch both articles from response and convert them to WikiArticle
    for (var articleJSON in query['search']) {
      articles.add(await WikiArticle.createFromJSON(articleJSON, idKey: 'pageid'));
    }

    return articles;
  }
}