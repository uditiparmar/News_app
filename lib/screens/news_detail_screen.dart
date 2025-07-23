import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_article.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  Future<void> _launchUrl(BuildContext context, String url) async {
    print('Launch URL requested: $url');  // Debug log

    final uri = Uri.tryParse(url);
    if (uri == null) {
      print('URL is invalid');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid URL')),
      );
      return;
    }

    try {
      final bool launched =
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        print('Could not launch URL');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch URL')),
        );
      }
    } catch (e) {
      print('Exception launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching URL: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail', style: GoogleFonts.playfair()),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title ?? 'No Title',
              style: GoogleFonts.playfair(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                article.urlToImage ?? 'https://via.placeholder.com/150',
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) =>
                    Image.network('https://via.placeholder.com/150',
                        fit: BoxFit.fill),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              article.content ?? 'No Content Available',
              style: GoogleFonts.playfair(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                final url = article.url ?? '';
                if (url.isNotEmpty) {
                  _launchUrl(context, url);
                } else {
                  print('No URL available');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No URL available')),
                  );
                }
              },
              child: const Text('Read More'),
            ),
          ],
        ),
      ),
    );
  }
}
