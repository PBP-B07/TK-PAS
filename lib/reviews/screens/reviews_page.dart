import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  Future<List<Product>> fetchProduct() async {
    // var url = Uri.parse('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/review/get-reviews-json/14/');
    var url = Uri.parse(
        'http://localhost:8000/review/get-reviews-json/${widget.bookId}/');
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

  Future<bool> hasUserReviewed() async {
    //TODO MASI GABISAAAAAAAAAAAAAAA
  print("WOI HALOOOOOOOOOOO");
  var userReviewUrl = Uri.parse('http://localhost:8000/review/get-user-reviews/${widget.bookId}/');
  var response = await http.get(
    userReviewUrl,
    headers: {"Content-Type": "application/json"},
  );

  var data = jsonDecode(utf8.decode(response.bodyBytes));
  print(data);
  // Periksa apakah data tidak kosong atau sesuai dengan kondisi lain yang Anda tentukan
  return data.isNotEmpty; // Gantilah dengan kondisi yang sesuai
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      // drawer: const LeftDrawer(),
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
                        fontSize: 30,
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
                  future: hasUserReviewed(),
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
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     margin: const EdgeInsets.only(bottom: 50.0),
                //     child: ElevatedButton(
                //       onPressed: () {
                //         // Add logic to navigate to the full reviews screen
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) =>
                //                   ReviewFormPage(bookId: widget.bookId)),
                //         );
                //       },
                //       child: const Text('Add Your Review'),
                //     ),
                //   ),
                // ),
              ],
            );
          }
        },
      ),
    );
  }
}
