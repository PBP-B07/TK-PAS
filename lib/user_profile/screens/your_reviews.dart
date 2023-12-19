import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/user_profile/models/get-reviews.dart';

import 'package:ulasbuku/user_profile/widgets/your_reviews_card.dart';

class YourReviewsPage extends StatefulWidget {
  const YourReviewsPage({Key? key}) : super(key: key);

  @override
  _YourReviewsPageState createState() => _YourReviewsPageState();
}

class _YourReviewsPageState extends State<YourReviewsPage> {
  List<Product> yourReviews = [];

  Future<List<Product>> fetchProduct(request) async {
    var response = await request.get('http://localhost:8000/profile/reviews/');
    print(response);

    List<Product> list_product = [];
    for (var d in response) {
      if (d != null) {
        list_product.add(Product.fromJson(d));
      }
    }
    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Your Reviews',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchProduct(request),
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xff59A5D8),
                          fontSize: 20),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No review data.",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xff59A5D8),
                          fontSize: 20),
                    ),
                  );
                }
                // Display the data in a ListView
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => YourReviewsCard(
                    YourReviewsItem(
                      snapshot.data![index].bookRating,
                      snapshot.data![index].bookTitle,
                      snapshot.data![index].bookPk,
                      snapshot.data![index].pk,
                      snapshot.data![index].description,
                      snapshot.data![index].star,
                      snapshot.data![index].dateAdded,
                    ),
                    // Pass the onDelete callback
                    onDelete: () {
                      // Reload data when onDelete is invoked
                      fetchProduct(request).then((updatedData) {
                        setState(() {
                          yourReviews = updatedData;
                        });
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
