class NewsDataModel {
  String status;
  int totalResults;
  List<Article> articles;

  NewsDataModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsDataModel.fromJson(Map<String, dynamic> json) => NewsDataModel(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );
}

class Article {
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  DateTime publishedAt;
  String content;

  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: Source.fromJson(json["source"]),
        author: json["author"] ?? "author",
        title: json["title"] ?? "Null",
        description: json["description"] ?? "Null",
        url: json["url"] ?? "url",
        urlToImage: json["urlToImage"] ??
            "https://resource.rentcafe.com/image/upload/q_auto,f_auto/s3/2/50552/image%20not%20available(52).jpg",
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"] ?? "content",
      );
}

class Source {
  String id;
  String name;

  Source({
    required this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"] ?? "ID",
        name: json["name"] ?? "Null",
      );
}
