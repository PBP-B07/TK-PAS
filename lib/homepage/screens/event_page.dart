import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ulasbuku/homepage/models/get_event.dart';
import 'package:ulasbuku/homepage/screens/event_form.dart';
// import 'package:ulasbuku/homepage/widget/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../../book/screens/book_details.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool isAdmin = false; // Declare isAdmin here

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false); // Assuming CookieRequest is provided in the widget tree
    fetchAdminStatus(request);
  }

  Future<List<Product>> fetchProduct() async {
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

  Future<void> fetchAdminStatus(request) async {
  var url = 'http://localhost:8000/is-admin/';
  print('Status admin sebelum fetch: $isAdmin');

  try {
    var response = await request.get(url);
    print('Response: $response');

    // Directly using the response assuming it is already a JSON object
    if (response['is_admin'] != null) {
      setState(() {
        isAdmin = response['is_admin'];
        print('Status admin setelah fetch: $isAdmin');
      });
    } else {
      print('Invalid response format');
    }
  } catch (e) {
    print('Error fetching admin status: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event yang Anda Buat'),
      ),
      //drawer: const LeftDrawer(), // Uncomment this if you have a LeftDrawer widget
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
                  onTap: () async {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BookDetailsPage(bookId: currentProduct.bookPk,)));
                  },
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
      floatingActionButton: isAdmin ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddItemEventForm()));
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Event',
      ) : null,
    );
  }
}
