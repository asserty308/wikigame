import 'dart:async';

import 'package:wikigame/api/wiki_api.dart';

/// Generates an WikiArticle object by parsing json
/// The given json must contain the keys 'id' and 'title'
Future<WikiArticle> createArticleFromJSON(Map<String, dynamic> json) async {
  int id = json['id'];
  String title = json['title'];
  String summary = await fetchArticleSummary(id);

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
  int id = await fetchIDFromTitle(title);
  String summary = await fetchArticleSummary(id);

  return WikiArticle(
      id: id,
      title: title,
      summary: summary,
      links: null
  );
}

/// Representation of a Wikipedia article.
class WikiArticle {
  int id;
  String title, summary;
  List<WikiArticle> links;

  WikiArticle({
    this.id,
    this.title,
    this.summary,
    this.links
  });

  /// Returns the language specific url of the article
  /// TODO: Add multiple language support
  String getUrl() {
    if (title == null || title.isEmpty) {
      return "";
    }

    return "https://de.wikipedia.org/wiki/$title";
  }
}