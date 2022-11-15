/// Representation of a Wikipedia article.
class WikiArticle {
  WikiArticle({
    required this.id,
    required this.title,
    this.extract,
  });

  /// Generates an WikiArticle object by parsing json
  /// The given json must contain the keys 'id' and 'title'
  factory WikiArticle.fromJSON(Map<String, dynamic> json, {String idKey = 'id'}) => WikiArticle(
    id: json[idKey],
    title: json['title'],
    extract: json['extract'] as String?,
  );

  final int id;
  final String title;
  final String? extract;

  /// Returns the language specific url of the article
  String url([String langKey = 'de']) {
    if (title.isEmpty) {
      return '';
    }

    return 'https://$langKey.wikipedia.org/wiki/$title';
  }
}
