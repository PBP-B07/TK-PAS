import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/reviews/models/product.dart';
import 'package:ulasbuku/reviews/screens/reviews_form_page.dart';
import 'package:intl/intl.dart';

class BookReviewPage extends StatefulWidget {
  final int bookId;

  const BookReviewPage({Key? key, required this.bookId}) : super(key: key);

  @override
  _BookReviewPageState createState() => _BookReviewPageState();
}

class _BookReviewPageState extends State<BookReviewPage> {
  Future<List<Product>> fetchProduct(request) async {
    var response = await request.get('http://localhost:8000/review/get-reviews-json/${widget.bookId}/');
    print(response);

    List<Product> list_product = [];
    for (var d in response) {
      if (d != null) {
        list_product.add(Product.fromJson(d));
      }
    }
    return list_product;
  }

  Future<bool> hasUserReviewed(request) async {
  var response = await request.get('http://localhost:8000/review/get-user-reviews/${widget.bookId}/');
  print(response);

  return response.isNotEmpty; // Gantilah dengan kondisi yang sesuai
}


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      backgroundColor: const Color(0xFFCFFAFE),
      body: FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            Product? firstProduct;
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              firstProduct = snapshot.data![0];
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 20, right: 20),
                  child: Center(
                    child: Text(
                      firstProduct != null
                    ? "Reviews of ${firstProduct.bookTitle}"
                    : "No reviews available",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      Product currentProduct = snapshot.data![index];
                      return InkWell(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white, // Set the background color to white
                            borderRadius: BorderRadius.circular(20.0), // Set the border radius
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display colored star icons based on currentProduct.star
                              Row(
                                children: [
                                  // Display colored star icons based on currentProduct.star
                                  ...List.generate(
                                    currentProduct.star,
                                    (index) => const Icon(
                                      Icons.star,
                                      color: Colors
                                          .yellow, // Set the color for colored stars
                                    ),
                                  ),
                                  // Display uncolored star icons for the remaining stars
                                  ...List.generate(
                                    5 - currentProduct.star,
                                    (index) => const Icon(
                                      Icons.star_border,
                                      color: Colors
                                          .grey, // Set the color for uncolored stars
                                    ),
                                  ),
                                  Text(
                                    " (${currentProduct.star} stars)",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  "by ${currentProduct.profileName} | posted on ${DateFormat('yyyy-MM-dd').format(currentProduct.dateAdded)}"),
                              const SizedBox(height: 10),
                              Text(
                                "\"${currentProduct.description}\"",
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                FutureBuilder(
                  future: hasUserReviewed(request),
                  builder: (context, AsyncSnapshot<bool> userReviewSnapshot) {
                    if (userReviewSnapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      bool hasUserReviewed = userReviewSnapshot.data ?? false;
                      if (!hasUserReviewed) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 50.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                      ReviewFormPage(bookId: widget.bookId),
                                  ),
                                );
                              },
                              child: const Text('Add Your Review'),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(); // Tidak menampilkan tombol jika pengguna sudah memberikan review
                      }
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
