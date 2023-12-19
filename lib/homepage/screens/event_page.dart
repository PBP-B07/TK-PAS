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
    final request = Provider.of<CookieRequest>(context,
        listen: false); // Assuming CookieRequest is provided in the widget tree
    fetchAdminStatus(request);
  }

  Future<List<Product>> fetchProduct() async {
    var url = Uri.parse('https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/get_event/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    // print(data);
    List<Product> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Product.fromJson(d));
      }
    }
    return list_product;
  }

  Future<void> fetchAdminStatus(request) async {
    var url = 'https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/is-admin/';
    // print('Status admin sebelum fetch: $isAdmin');

    try {
      var response = await request.get(url);
      // print('Response: $response');

      // Directly using the response assuming it is already a JSON object
      if (response['is_admin'] != null) {
        setState(() {
          isAdmin = response['is_admin'];
          // print('Status admin setelah fetch: $isAdmin');
        });
      } else {
        // print('Invalid response format');
      }
    } catch (e) {
      // print('Error fetching admin status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        future: fetchProduct(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                "Tidak ada data event.",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xff59A5D8),
                    fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                Product currentProduct = snapshot.data![index];
                return InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookDetailsPage(
                                  bookId: currentProduct.bookPk,
                                )));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentProduct.title,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("Description: ${currentProduct.description}",
                            style: TextStyle(fontFamily: 'Poppins')),
                        const SizedBox(height: 10),
                        Text("Book Title: ${currentProduct.bookTitle}",
                            style: TextStyle(fontFamily: 'Poppins'))
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddItemEventForm()));
              },
              child: const Icon(Icons.add),
              tooltip: 'Add Event',
            )
          : null,
    );
  }
}
