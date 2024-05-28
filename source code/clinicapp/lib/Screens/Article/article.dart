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
                        'Ria Apriani',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Jun 27, 2024 - Kesehatan',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Article title
              const Text(
                '5 Manfaat Minum Madu Sebelum Tidur, Tak Sekedar Tidur',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Image from assets
              Image.asset('assets/health_article3.jpg'),
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
                'Madu memiliki kandungan antioksidan dan kandungan lainnya yang berguna untuk mendukung kesehatan tubuh, termasuk saat diminum sebelum tidur. Beberapa manfaat minum madu sebelum tidur, yakni meningkatkan kualitas tidur, mencegah tekanan darah tinggi, meningkatkan sistem imun, dan menurunkan berat badan. Meskipun begitu, madu memiliki kandungan gula yang perlu dibatasi konsumsinya karena bisa meningkatkan risiko obesitas, inflamasi, resistensi insulin, gangguan liver, dan penyakit jantung. Untuk lebih jelasnya, ketahui beberapa manfaat minum madu sebelum tidur dan efek samping yang mungkin dialami berikut ini.Artikel ini telah tayang di Kompas.com dengan judul "5 Manfaat Minum Madu Sebelum Tidur, Tak Sekadar Sehat Klik untuk baca',
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
