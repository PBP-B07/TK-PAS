import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/reviews/models/product.dart';
import 'package:ulasbuku/reviews/screens/reviews_form_page.dart';
import 'package:intl/intl.dart';

class BookReviewPage extends StatefulWidget {
  final int bookId;

  const BookReviewPage({Key? key, required this.bookId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BookReviewPageState createState() => _BookReviewPageState();
}

class _BookReviewPageState extends State<BookReviewPage> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  String selectedSort = 'Date Added (Newest-Oldest)';
  List<String> sortOptions = [
    'Date Added (Newest-Oldest)',
    '5 Stars',
    '4 Stars',
    '3 Stars',
    '2 Stars',
    '1 Star',
    '0 Star'
  ];

  get request => context.watch<CookieRequest>();

  Future<List<Product>> fetchProduct(request) async {
    var response = await request.get(
        'https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/review/get-reviews-json/${widget.bookId}/');
    // print(response);

    List<Product> list_product = [];
    for (var d in response) {
      if (d != null) {
        list_product.add(Product.fromJson(d));
      }
    }

    list_product.sort((a, b) => b.pk.compareTo(a.pk));
    allProducts = list_product;

    return list_product;
  }

  Future<bool> hasUserReviewed(request) async {
    var response = await request.get(
        'https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/review/get-user-reviews/${widget.bookId}/');
    // print(response);

    return response.isNotEmpty; // Gantilah dengan kondisi yang sesuai
  }

  @override
  void initState() {
    super.initState();

    // Menggunakan Provider.of
    CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
    fetchAndSortProducts(request);

    // Atau menggunakan context.read
    // CookieRequest request = context.read<CookieRequest>();
    // fetchAndSortProducts(request);
  }

  void fetchAndSortProducts(CookieRequest request) {
    fetchProduct(request).then((products) {
      setState(() {
        filteredProducts = List.from(products);
        sortProducts();
      });
    });
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
                        fontFamily: 'Poppins',
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        value: selectedSort,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSort = newValue!;
                            sortProducts(); // Sort products by date or rating
                          });
                        },
                        items: sortOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 16.0),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    // itemCount: snapshot.data!.length,
                    itemCount: filteredProducts.length,
                    itemBuilder: (_, index) {
                      Product currentProduct = filteredProducts[index];
                      return InkWell(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // Set the background color to white
                            borderRadius: BorderRadius.circular(
                                20.0), // Set the border radius
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
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  "by ${currentProduct.profileName} | posted on ${DateFormat('yyyy-MM-dd').format(currentProduct.dateAdded)}",
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                  )),
                              const SizedBox(height: 10),
                              Text(
                                "\"${currentProduct.description}\"",
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
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
                    if (userReviewSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      bool hasUserReviewed = userReviewSnapshot.data ?? false;
                      if (!hasUserReviewed) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 60.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReviewFormPage(bookId: widget.bookId),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5038BC),
                                padding: const EdgeInsets.all(
                                    20.0), // Mengatur padding tombol
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Mengatur radius tombol
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 14.0, // Mengatur ukuran teks tombol
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: const Text(
                                'Add Your Review',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
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

  void sortProducts() {
    if (selectedSort == 'Date Added (Newest-Oldest)') {
      // Copy allProducts to filteredProducts
      filteredProducts = List.from(allProducts);
      // Sort filteredProducts by dateAdded
      filteredProducts.sort((a, b) => b.pk.compareTo(a.pk));
    } else if (selectedSort == '5 Stars') {
      filteredProducts =
          allProducts.where((product) => product.star == 5).toList();
    } else if (selectedSort == '4 Stars') {
      filteredProducts =
          allProducts.where((product) => product.star == 4).toList();
    } else if (selectedSort == '3 Stars') {
      filteredProducts =
          allProducts.where((product) => product.star == 3).toList();
    } else if (selectedSort == '2 Stars') {
      filteredProducts =
          allProducts.where((product) => product.star == 2).toList();
    } else if (selectedSort == '1 Star') {
      filteredProducts =
          allProducts.where((product) => product.star == 1).toList();
    } else if (selectedSort == '0 Star') {
      filteredProducts =
          allProducts.where((product) => product.star == 0).toList();
    }
    setState(() {});
  }
}
