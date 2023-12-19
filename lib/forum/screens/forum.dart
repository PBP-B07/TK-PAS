import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ulasbuku/forum/models/product_forum.dart';
import 'package:ulasbuku/forum/screens/forum_form.dart';
import 'package:ulasbuku/forum/screens/reply.dart';

class ForumPage extends StatefulWidget {
  final int bookId;
  final String bookTitle;

  const ForumPage({Key? key, required this.bookId, required this.bookTitle})
      : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  get bookId => widget.bookId;

  Future<List<Product>> fetchProduct() async {
    var url = Uri.parse(
        'https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/forum/get-forum/${widget.bookId}/');
    //'https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/forum/get-forum/14/');

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
    list_product.sort((a, b) => b.pk.compareTo(a.pk));
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
        future: fetchProduct(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            Product? firstProduct;
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              firstProduct = snapshot.data![0];
            }
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 20, right: 20),
                  child: Center(
                    child: Text(
                      firstProduct != null
                          ? "Forums of ${widget.bookTitle}"
                          : "No forum available",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      Product currentProduct = snapshot.data![index];
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReplyPage(
                                      bookId: bookId,
                                      forumId: currentProduct.pk,
                                      bookTitle: widget.bookTitle,
                                      forumTitle: currentProduct.subject)),
                            );
                          },
                          child: Card(
                            elevation: 4.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius value as needed
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${currentProduct.subject}',
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ],
                                  ),
                                  Text('by ${currentProduct.userUsername}',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Poppins')),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    '"${currentProduct.description}"',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Poppins'),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                      'Last Replied: ${currentProduct.dateAdded}',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Poppins')),
                                  const SizedBox(height: 8.0),
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ForumFormPage(
                bookId: widget.bookId,
                bookTitle: widget.bookTitle,
              ),
            ),
          );
        },
        label: const Text(
          'Add New Forum',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Color(0xFF5038BC), // Example color, change as needed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
