import 'package:clinicapp/Constants/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/article_model.dart';

class DetailArticle extends StatefulWidget {
  const DetailArticle({super.key});

  @override
  State<DetailArticle> createState() => _DetailArticleState();
}

class _DetailArticleState extends State<DetailArticle> {
  final List<Article> _articles = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading) {
      _fetchArticles();
    }
  }

  Future<void> _fetchArticles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/everything?q=tesla&from=2024-04-26&sortBy=publishedAt&pageSize=$_pageSize&page=$_currentPage&apiKey=6824d273d6be40e8b656abb2e39c349e'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articlesJson = data["articles"] as List;
        final fetchedArticles = articlesJson
            .map((a) => Article.fromJson(a))
            .where((a) => a.title != "[Removed]")
            .toList();

        setState(() {
          _currentPage++;
          _articles.addAll(fetchedArticles);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      // setState(() {
      //   _isLoading = false;
      // });
      // throw Exception('Failed to load news: $e');
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
      ),
      body: _articles.isEmpty && _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _articles.length + 1,
              itemBuilder: (context, index) {
                if (index == _articles.length) {
                  return _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink();
                }
                final article = _articles[index];
                return ListTile(
                  onTap: () {
                    _launchUrl(Uri.parse(article.url ?? ""));
                  },
                  leading: Image.network(
                    article.urlToImage ?? AppUrl.PLACEHOLDER_IMAGE_LINK,
                    height: 250,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(article.title ?? ""),
                  subtitle: Text(article.publishedAt ?? ""),
                );
              },
            ),
    );
  }
}
