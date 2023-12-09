import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ulasbuku/catalogue/models/product.dart';
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

  @override
  void initState() {
    super.initState();
    fetchProduct().then((products) {
      setState(() {
        allProducts = products;
        filteredProducts = products;
      });
    });
  }

  Future<List<Product>> fetchProduct() async {
    var url = Uri.parse('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/books/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      List<Product> list_product = [];
      for (var d in data) {
        list_product.add(Product.fromJson(d));
      }
      return list_product;
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
        Expanded(
          child: filteredProducts.isNotEmpty ? ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (_, index) {
              Product currentProduct = filteredProducts[index];
              return InkWell(
                onTap: () {
                  // Navigator.push logic
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentProduct.fields.title,  // Using the title from fields
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Description: ${currentProduct.fields.description}"),  // Using the description from fields
                      const SizedBox(height: 10),
                      Text("Author: ${currentProduct.fields.author}")  // Using the author from fields
                    ],
                  ),
                ),
              );
            },
          ) : const Center(
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

// Ensure to adjust the Product model according to your actual model's fields.
