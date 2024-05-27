import 'package:clinicapp/Screens/Article/detailArticle.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/001/840/618/original/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-free-vector.jpg'), // Placeholder for author image
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'John Doe',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Mar 28, 2023 - Sports',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Article title
              const Text(
                'A Number of Problems at the Indonesian U20 World Cup',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Image from assets
              Image.asset('assets/health_article.jpg'),
              const SizedBox(height: 8),
              // Author and date

              // Photo credit
              const Text(
                'Photo by Ilham Kurniawan',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Article content
              const Text(
                'The 2023 U20 World Championship is said to have been canceled in Indonesia. This was conveyed by football observer, Isaiah Oktavianus.\n\n'
                'The man who is familiarly called Bung Yes is very sure that the 2023 U20 World Cup will not be held in Indonesia even though the government has not officially announced it.',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                  onPressed: () {
                    PageNavigator(ctx: context).nextPage(page: DetailArticle());
                  },
                  child: Text('data'))
            ],
          ),
        ),
      ),
    );
  }
}
