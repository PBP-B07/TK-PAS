import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ulasbuku/book/screens/book_details.dart';
import 'dart:convert';
import 'package:ulasbuku/homepage/models/get_review.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';
// Tambahkan import untuk halaman detail


class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Future<List<Product>> fetchProduct() async {
    //var url = Uri.parse('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/get_review/');
    var url = Uri.parse('http://localhost:8000/get_review/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Product> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Product.fromJson(d));
      }
    }
    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        centerTitle: true, // Menempatkan judul di tengah
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w700),
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
      //drawer: const LeftDrawer(),
      backgroundColor: const Color(0xFFCFFAFE),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                "Tidak ada data produk.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20, fontFamily: 'Poppins'),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                Product currentProduct = snapshot.data![index];
                return InkWell(
                  onTap: () async {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BookDetailsPage(bookId: currentProduct.bookPk,)));
                  },
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
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("User: ${currentProduct.profileName}", style: TextStyle(fontFamily: 'Poppins')),
                        const SizedBox(height: 10),
                        Text("Rate: ${currentProduct.star}/5", style: TextStyle(fontFamily: 'Poppins')),
                        const SizedBox(height: 10),
                        Text("Description: ${currentProduct.description}", style: TextStyle(fontFamily: 'Poppins')),
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
