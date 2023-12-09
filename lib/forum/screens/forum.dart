import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ulasbuku/forum/models/product_forum.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  Future<List<Product>> fetchProduct() async {
    var url = Uri.parse(
        'https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/forum/get-forum/14/');
    //var url = Uri.parse('http://localhost:8000/books/');
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
        iconTheme: IconThemeData(color: Colors.black),
        title: Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
        backgroundColor: Colors.white, // Example color, change as needed
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Tidak ada data produk.",
                style: TextStyle(color: Colors.blueAccent, fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                Product currentProduct = snapshot.data![index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      ("${currentProduct.subject} by ${currentProduct.userUsername}"),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                        "${currentProduct.description}\nPosted on: ${currentProduct.dateAdded}"),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Action to add new forum
        },
        label: const Text('Add New Forum'),
        backgroundColor: Colors.teal, // Example color, change as needed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: Icon(Icons.home), onPressed: () {}),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            SizedBox(width: 48), // The space for the FAB
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
            IconButton(icon: Icon(Icons.person), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
