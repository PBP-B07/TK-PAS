import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ulasbuku/homepage/models/get_forum.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';
// Tambahkan import untuk halaman detail

class RecomendedForumPage extends StatefulWidget {
  const RecomendedForumPage({Key? key}) : super(key: key);

  @override
  _RecomendedForumPageState createState() => _RecomendedForumPageState();

}

class _RecomendedForumPageState extends State<RecomendedForumPage> {

  Future<List<Product>> fetchProduct() async {
   var url = Uri.parse('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/get_recomended_forum/');
    //var url = Uri.parse('http://localhost:8000/get_event/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);
    List<Product> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Product.fromJson(d));
        // Tambahkan judul buku dan nama pengguna ke dalam daftar

      }
    }
    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomended Forum'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Tidak ada forum terbaru.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                Product currentProduct = snapshot.data![index];
                return InkWell(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => ProductDetailPage(Product: currentProduct),
                //       ),
                //     );
                //   },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentProduct.bookTitle,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("User: ${currentProduct.userUsername}"),
                        const SizedBox(height: 10),
                        Text("Subject: ${currentProduct.subject}"),
                        const SizedBox(height: 10),
                        Text("Description: ${currentProduct.description}"),  // Using the description from fields
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
} 