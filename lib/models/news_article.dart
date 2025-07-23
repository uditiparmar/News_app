class NewsArticle {
  final String? title;
  final String? description;
  final String? content;
  final String? author;
  final String? urlToImage;
  final String? publishedAt;
  final String? url;

  NewsArticle({
    this.title,
    this.description,
    this.content,
    this.author,
    this.urlToImage,
    this.publishedAt,
    this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      author: json['author'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      url: json['url'] as String?,
    );
  }
}
