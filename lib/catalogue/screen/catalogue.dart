import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ulasbuku/book/screens/book_details.dart';
import 'dart:convert';
import 'package:ulasbuku/catalogue/models/product.dart';
import 'package:ulasbuku/catalogue/screen/add_form.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  TextEditingController searchController = TextEditingController();
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  String selectedCategory = 'All Categories';
  String selectedSort = 'Rating (Lowest)';
  List<String> categories = ['All Categories'];
  List<String> sortOptions = ['Rating (Lowest)', 'Rating (Highest)'];
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchProduct().then((products) {
      setState(() {
        allProducts = products;
        sortProductsByTitle();
        filteredProducts = allProducts;
        updateCategories();
      });
    });
  }

  @override
  void didChangeDependencies() {
    // print('here');
    super.didChangeDependencies();
    final request = context.watch<CookieRequest>();
    fetchAdminStatus(request);
  }

  Future<List<Product>> fetchProduct() async {
    var url = Uri.parse('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/books/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      List<Product> listProduct = [];
      for (var d in data) {
        listProduct.add(Product.fromJson(d));
      }
      return listProduct;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> fetchAdminStatus(request) async {
    var url = 'https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/catalogue/is-admin/';
    //print('Status admin sebelum fetch: $isAdmin');

    try {
      var response = await request.get(url);
      //print('Response: $response');

      // Directly using the response assuming it is already a JSON object
      if (response['is_admin'] != null) {
        setState(() {
          isAdmin = response['is_admin'];
          //print('Status admin setelah fetch: $isAdmin');
        });
      } else {
        //print('Invalid response format');
      }
    } catch (e) {
      //print('Error fetching admin status: $e');
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = allProducts;
      });
      return;
    }

    List<Product> dummyListData = [];
    allProducts.forEach((item) {
      if (item.fields.title.toLowerCase().contains(query.toLowerCase())) {
        dummyListData.add(item);
      }
    });

    setState(() {
      filteredProducts = dummyListData;
    });
  }

  void updateCategories() {
    Set<String> uniqueCategories = {'All Categories'};
    for (var product in allProducts) {
      uniqueCategories.add(product.fields.category);
    }
    setState(() {
      categories = uniqueCategories.toList();
      categories.sort(); // Sort the categories
    });
  }

  void sortProductsByTitle() {
    allProducts.sort((a, b) => a.fields.title.compareTo(b.fields.title));
  }

  @override
  Widget build(BuildContext context) {
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
      drawer: const LeftDrawer(),
      backgroundColor: const Color(0xFFCFFAFE),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearchResults,
              style: const TextStyle(
                fontFamily: 'Poppins',
              ),
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: const TextStyle(
                  fontFamily: 'Poppins',
                ),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          // Sort Dropdown Row
          Center(
            child: DropdownButton<String>(
              value: selectedSort,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSort = newValue!;
                  sortProducts();
                });
              },
              items: sortOptions.map<DropdownMenuItem<String>>((String value) {
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
          ),
          const SizedBox(height: 8.0),
          // Category Dropdown Row
          Center(
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  filterByCategory();
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
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
          ),
          const SizedBox(height: 8.0),
          Visibility(
            visible: isAdmin,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5038BC),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ShopFormPage()),
                  );
                  await fetchProduct().then((products) {
                    setState(() {
                      allProducts = products;
                      sortProductsByTitle();
                      filteredProducts = allProducts;
                      updateCategories();
                    });
                  });
                },
                child: Text("Add Book",
                    style:
                        const TextStyle(fontSize: 16.0, fontFamily: 'Poppins')),
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (_, index) {
                      Product currentProduct = filteredProducts[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookDetailsPage(bookId: currentProduct.pk),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentProduct.fields.title,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                Text(
                                  "Author: ${currentProduct.fields.author}",
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                Text(
                                  "Publish Date: ${currentProduct.fields.publishDate}",
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                Text(
                                  "Category: ${currentProduct.fields.category}",
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                                Text(
                                  "Rating: ${currentProduct.fields.rating.toStringAsFixed(1)}",
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "No products found.",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xff59A5D8),
                        fontSize: 20,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void filterByCategory() {
    if (selectedCategory == 'All Categories') {
      setState(() {
        filteredProducts = allProducts;
      });
    } else {
      List<Product> categoryProducts = allProducts
          .where((product) => product.fields.category == selectedCategory)
          .toList();
      setState(() {
        filteredProducts = categoryProducts;
      });
    }
  }

  void sortProducts() {
    if (selectedSort == 'Rating (Lowest)') {
      filteredProducts
          .sort((a, b) => a.fields.rating.compareTo(b.fields.rating));
    } else {
      filteredProducts
          .sort((a, b) => b.fields.rating.compareTo(a.fields.rating));
    }
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
