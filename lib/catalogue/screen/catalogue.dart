import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ulasbuku/book/screens/book_details.dart';
import 'dart:convert';
import 'package:ulasbuku/catalogue/models/product.dart';
import 'package:ulasbuku/catalogue/screen/add_form.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';

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

  @override
  void initState() {
    super.initState();
    fetchProduct().then((products) {
      setState(() {
        allProducts = products;
        sortProductsByTitle(); // Sort products by title initially
        filteredProducts = allProducts;
        updateCategories(); // Update the category list
      });
    });
  }

  Future<List<Product>> fetchProduct() async {
    var url = Uri.parse('http://127.0.0.1:8000/books/');
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
        title: const Text('Catalogue Buku'),
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: selectedSort,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSort = newValue!;
                      sortProducts(); // Sort products by rating
                    });
                  },
                  items: sortOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 16.0),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                      filterByCategory(); // Filter products by category
                    });
                  },
                  items: categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                // Navigate to add product page
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopFormPage()),
                );
                // Fetch products again after adding a product
                await fetchProduct().then((products) {
                  setState(() {
                    allProducts = products;
                    sortProductsByTitle(); // Sort products by title
                    filteredProducts = allProducts;
                    updateCategories(); // Update the category list
                  });
                });
              },
              child: Text("Add Product"),
            ),
          ),
          Expanded(
            child: filteredProducts.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (_, index) {
                      Product currentProduct = filteredProducts[index];
                      return InkWell(
                        onTap: () async {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => BookDetailsPage(bookId: currentProduct.pk,)));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentProduct.fields.title,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("Description: ${currentProduct.fields.description}"),
                              const SizedBox(height: 10),
                              Text("Author: ${currentProduct.fields.author}"),
                              const SizedBox(height: 10),
                              Text("Category: ${currentProduct.fields.category}"),
                              const SizedBox(height: 10),
                              Text("Rating: ${currentProduct.fields.rating}"),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No products found.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
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
      filteredProducts.sort((a, b) => a.fields.rating.compareTo(b.fields.rating));
    } else {
      filteredProducts.sort((a, b) => b.fields.rating.compareTo(a.fields.rating));
    }
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
