import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsApiService {
  static const String _apiKey = 'f5d7fec99e274bd7b99a05ef99b5d5bd';
  static const String _baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsArticle>> fetchTopHeadlines({String country = 'us'}) async {
    final url = Uri.parse('$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List articlesJson = jsonData['articles'] as List;
      return articlesJson.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to fetch news: ${response.statusCode}');
    }
  }
}
