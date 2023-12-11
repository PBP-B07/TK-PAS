import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ulasbuku/homepage/widget/drawer.dart';
import 'package:ulasbuku/reviews/models/product.dart';

class BookReviewPage extends StatefulWidget {
  const BookReviewPage({Key? key}) : super(key: key);

  @override
  _BookReviewPageState createState() => _BookReviewPageState();
}

class _BookReviewPageState extends State<BookReviewPage> {
  Future<List<Product>> fetchProduct() async {
    
    // var url = Uri.parse('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/review/get-reviews-json/14/');
    var url = Uri.parse('http://localhost:8000/review/get-reviews-json/14/');
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
        title: const Text('Reviews'),
      ),
      drawer: const LeftDrawer(),
      backgroundColor: const Color(0xFFCFFAFE),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Tidak ada review untuk buku ini.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            Product firstProduct = snapshot.data![0];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                  child: Center(
                    child: Text(
                      "Reviews of ${firstProduct.bookTitle}",
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
                          // color: Colors.white,
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white, // Set the background color to white
                            borderRadius: BorderRadius.circular(20.0), // Set the border radius
                          ),
                          // decoration: (borderRadius = BorderRadius.all(Radius.circular(20))),
                          // // BorderRadius: const BorderRadius.all(Radius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              // Display colored star icons based on currentProduct.star
                              Row(
                                children: [
                                  // Display colored star icons based on currentProduct.star
                                  ...List.generate(
                                    currentProduct.star,
                                    (index) => const Icon(
                                      Icons.star,
                                      color: Colors.yellow, // Set the color for colored stars
                                    ),
                                  ),
                                  // Display uncolored star icons for the remaining stars
                                  ...List.generate(
                                    5 - currentProduct.star,
                                    (index) => const Icon(
                                      Icons.star_border,
                                      color: Colors.grey, // Set the color for uncolored stars
                                    ),
                                  ),
                                  Text(
                                    " (${currentProduct.star} stars)",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text("by ${currentProduct.profileName} | posted on ${currentProduct.dateAdded}"),
                              const SizedBox(height: 10),
                              Text(
                                "\"${currentProduct.description}\"",
                                style: const TextStyle(fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

            
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (_, index) {
//                 Product currentProduct = snapshot.data![index];
//                 return InkWell(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 10),
//                         Text(
//                           "⭐⭐⭐⭐⭐ (${currentProduct.star} stars)",
//                           style: const TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text("by ${currentProduct.profileName} | posted on ${currentProduct.dateAdded}"),
//                         const SizedBox(height: 10),
//                         Text(
//                           "\"${currentProduct.description}\"",
//                           style: const TextStyle(fontStyle: FontStyle.italic),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }