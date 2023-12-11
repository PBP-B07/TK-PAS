import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ulasbuku/homepage/models/get_event.dart';
import 'package:ulasbuku/homepage/screens/event_form.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';
// Tambahkan import untuk halaman detail

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Future<List<Product>> fetchProduct() async {
  //  var url = Uri.parse('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/get_event/');
    var url = Uri.parse('http://localhost:8000/get_event/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);
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
        title: const Text('Event yang Anda Buat'),
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
                "Tidak ada data event.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                Product currentProduct = snapshot.data![index];
                return InkWell(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => ProductDetailPage(Product: currentProduct),
                //       ),
                //     );
                //   },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentProduct.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("Description: ${currentProduct.description}"),  // Using the description from fields
                        const SizedBox(height: 10),
                        Text("Book Title: ${currentProduct.bookTitle}")
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah event
           Navigator.push(context, MaterialPageRoute(builder: (context) => AddItemEventForm()));
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Event',
        
      ),
    );
  }
} 