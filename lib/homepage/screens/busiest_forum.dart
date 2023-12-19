import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/book/screens/book_details.dart';
import 'dart:convert';
import 'package:ulasbuku/homepage/models/get_busiest_forum.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';

class BusiestForumPage extends StatefulWidget {
  const BusiestForumPage({Key? key}) : super(key: key);

  @override
  _BusiestForumPageState createState() => _BusiestForumPageState();
}

class _BusiestForumPageState extends State<BusiestForumPage> {
  Future<List<Product>> fetchProduct(request) async {
    //  var url = Uri.parse('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/get_busiest_forum/');
    var response = await request
        .get('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/get_busiest_forum/');
    // print(response);

    List<Product> list_product = [];
    for (var d in response) {
      if (d != null) {
        list_product.add(Product.fromJson(d));
      }
    }
    return list_product;
  }

  Future<bool> hasUserReviewed(request) async {
    //  var response = await request.get('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/get_busiest_forum/');
    var response = await request
        .get('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/get_busiest_forum/');
    // print(response);

    return response.isNotEmpty; // Gantilah dengan kondisi yang sesuai
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Menempatkan judul di tengah
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 32,
                fontWeight: FontWeight.w700),
            children: [
              TextSpan(
                text: 'Ulas',
                style: TextStyle(color: Color(0xFF0919CD)),
              ),
              TextSpan(
                text: 'Buku',
                style: TextStyle(color: Color(0xFFC51605)),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFCFFAFE),
      body: FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                "Tidak ada forum teramai.",
                style: TextStyle(
                    color: Color(0xff59A5D8),
                    fontSize: 20,
                    fontFamily: 'Poppins'),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                Product currentProduct = snapshot.data![index];
                return InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookDetailsPage(
                                  bookId: currentProduct.bookPk,
                                )));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("User: ${currentProduct.userUsername}",
                            style: TextStyle(fontFamily: 'Poppins')),
                        const SizedBox(height: 10),
                        Text("Subject: ${currentProduct.subject}",
                            style: TextStyle(fontFamily: 'Poppins')),
                        const SizedBox(height: 10),
                        Text("Description: ${currentProduct.description}",
                            style: TextStyle(fontFamily: 'Poppins')),
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
