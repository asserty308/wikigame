class WikiArticle {
  String title, description;
  List<WikiArticle> links;

  WikiArticle({
    this.title,
    this.description,
    this.links
  });

  factory WikiArticle.fromJson(Map<String, dynamic> json) {
    return WikiArticle();
  }

  // Returns the language specific url of the article
  // TODO: Add multiple language support
  String getUrl() {
    if (title == null || title.isEmpty) {
      return "";
    }

    return "https://de.wikipedia.org/wiki/$title";
  }
}