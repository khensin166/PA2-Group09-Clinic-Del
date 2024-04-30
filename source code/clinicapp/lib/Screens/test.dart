import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyController extends StatefulWidget {
  @override
  _MyControllerState createState() => _MyControllerState();
}

class _MyControllerState extends State<MyController> {
  // Endpoint URL
  final String apiUrl = "http://127.0.0.1:8080/user/1";

  // Function to fetch data from API
  Future<void> fetchData() async {
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      // Jika respons berhasil (status code 200), kita ubah respons JSON menjadi Map
      Map<String, dynamic> data = json.decode(response.body);
      // Kemudian kita ambil data bagian "data"
      // Map<String, dynamic> userData = data['data'];
      // Print data ke console
      print(data['data']);
      // Anda dapat melakukan sesuatu dengan data yang telah diterima di sini, misalnya menampilkan di UI
    } else {
      // Jika respons gagal, print pesan error ke console
      print("Failed to load data: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Data dari API'),
        ),
        body: Container(
          child: ElevatedButton(
              onPressed: () {
                fetchData();
              },
              child: Text("data dari API")),
        ));
  }
}
