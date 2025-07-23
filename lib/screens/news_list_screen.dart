import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/news_article.dart';
import '../services/news_api_service.dart';
import 'news_detail_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsApiService _newsApiService = NewsApiService();
  late Future<List<NewsArticle>> _futureArticles;

  @override
  void initState() {
    super.initState();
    _futureArticles = _newsApiService.fetchTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              child: Text(
                "Top Headline",
                style: GoogleFonts.playfair(
                    fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<NewsArticle>>(
              future: _futureArticles,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  return Expanded(
                    child: Center(
                      child: Text("Error loading: ${snapshot.error}"),
                    ),
                  );
                } else {
                  List<NewsArticle> articles = snapshot.data ?? [];
                  return Expanded(
                    child: ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetailScreen(article: article),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 220,
                                  width: MediaQuery.of(context).size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      article.urlToImage ??
                                          "https://via.placeholder.com/150",
                                      fit: BoxFit.fill,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.network(
                                              "https://via.placeholder.com/150",
                                              fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  article.title ?? "No Title Available",
                                  style: GoogleFonts.playfair(
                                      height: 1,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      child: Text(
                                        article.author ?? "Unknown Author",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.playfair(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                    ),
                                    Text(article.publishedAt?.toString() ?? "No Date"),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NewsDetailScreen(article: article),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: const [
                                      Text(
                                        "Read Now",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 1.5,
                                          decorationColor: Colors.blue,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Divider(),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
