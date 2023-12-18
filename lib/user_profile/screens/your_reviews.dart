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
        title: const Text('Your Reviews'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use Expanded to allow the ListView to take remaining space
            Expanded(
              child: FutureBuilder(
                future: fetchProduct(request),
                builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                  // Check for loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Tidak ada data review.",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
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
      ),
    );
  }
}
