import 'dart:async';
import 'package:flutter/material.dart';

import 'package:wikigame/api/wiki_api.dart';

/// Generates an WikiArticle object by parsing json
/// The given json must contain the keys 'id' and 'title'
Future<WikiArticle> createArticleFromJSON(Map<String, dynamic> json, {String idKey = 'id'}) async {
  final int id = json[idKey];
  final String title = json['title'];
  final summary = await fetchArticleSummary(id);

  return WikiArticle(
      id: id,
      title: title,
      summary: summary,
      links: null
  );
}

/// Generates an WikiArticle object by parsing json
/// The given json must contain the keys 'id' and 'title'
Future<WikiArticle> createArticleFromTitle(String title) async {
  final id = await fetchIDFromTitle(title);
  final summary = await fetchArticleSummary(id);

  return WikiArticle(
      id: id,
      title: title,
      summary: summary,
      links: null
  );
}

/// Representation of a Wikipedia article.
class WikiArticle {
  WikiArticle({
    this.id,
    this.title,
    this.summary,
    this.links
  });

  int id;
  String title, summary;
  List<WikiArticle> links;

  /// Returns the language specific url of the article
  /// TODO: Add multiple language support
  String getUrl() {
    if (title == null || title.isEmpty) {
      return '';
    }

    return 'https://de.wikipedia.org/wiki/$title';
  }
}