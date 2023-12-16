import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/book/models/product.dart';
import 'package:ulasbuku/homepage/models/item_event.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';
import 'package:ulasbuku/homepage/screens/homepage.dart';

class AddItemEventForm extends StatefulWidget {
  @override
  State<AddItemEventForm> createState() => _AddItemState();
}

class _AddItemState extends State<AddItemEventForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _description = "";
  String? _selectedBookTitle;
  List<String> bookTitles = [];

//   void main() {
//   String jsonData =
//       '[{"model": "book.book", "pk": 1, "fields": {"title": "The Staff Engineer\'s Path", "description": "A Guide for Individual Contributors Navigating Growth and Change", "author": "Tanya Reilly", "isbn10": "1098118731", "isbn13": "978-1098118730", "publish_date": "2022-10-25", "edition": 1, "best_seller": "Yes", "rating": 0.0, "category": "Software Engineering"}}, {"model": "book.book", "pk": 2, "fields": {"title": "Cracking the Coding Interview", "description": "189 Programming Questions and Solutions", "author": "Gayle Laakmann McDowell", "isbn10": "984782869", "isbn13": "978-0984782857", "publish_date": "2015-07-01", "edition": 6, "best_seller": "Yes", "rating": 0.0, "category": "Programming"}}, {"model": "book.book", "pk": 3, "fields": {"title": "Python Crash Course, 3rd Edition", "description": "A Hands-On, Project-Based Introduction to Programming", "author": "Eric Matthes", "isbn10": "1718502702", "isbn13": "978-1718502703", "publish_date": "2023-01-10", "edition": 3, "best_seller": "Yes", "rating": 0.0, "category": "Programming"}},]';

//   List<Map<String, dynamic>> books = List<Map<String, dynamic>>.from(json.decode(jsonData));
  
//   List<String> titles = books.map((book) => book['fields']['title'] as String).toList();

//   print(titles);
// }

  
  @override
  void initState() {
    super.initState();
    fetchBookTitles();
  }

  Future<void> fetchBookTitles() async {
    final response = await http.get(Uri.parse("http://localhost:8000/books/"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<String> titles = jsonData.map((book) => book['fields']['title'] as String).toList();
      // Add a default item to the beginning of the list
      // titles.insert(0, 'Select Book Title');
      //print("Fetched Titles: $titles"); // Print fetched titles
      setState(() {
        bookTitles = titles;
        _selectedBookTitle = titles.isNotEmpty ? titles[0] : null;
      });

       //_selectedBookTitle = titles[0]; // Set default value
       //print("Selected Book Title: $_selectedBookTitle"); // Print selected book title
  
    } else {
      throw Exception("Failed to load book titles");
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("TAMBAH EVENT"),
        ),
        backgroundColor: Color.fromARGB(221, 158, 68, 68),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Title",
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _title = value;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Title Tidak Boleh Kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Description",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Description Tidak Boleh Kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedBookTitle,
                  decoration: InputDecoration(
                    hintText: "Book Title",
                    labelText: 'Book Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  items: bookTitles.isNotEmpty
        ? bookTitles.toSet().toList().map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList()
        : [],// Set to null if bookTitles is empty
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBookTitle = newValue;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Book Title Tidak Boleh Kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                    // onPressed: () async {
                    //   if (_formKey.currentState!.validate()) {
                    //     // Implement your save logic here
                    //     // You can use _title, _description, and _selectedBookTitle
                    //     // to send data to the server or perform any other actions.
                    //   }
                    // },
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                            "http://localhost:8000/create-flutter/",
                            jsonEncode(<String, String>{
                        // Navigator.pop(context, {
                          'title': _title,
                          'description': _description,
                          'bookTitle': _selectedBookTitle ?? '',
                        }));
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Item baru berhasil disimpan!"),
                          ));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text("Terdapat kesalahan, silakan coba lagi."),
                          ));
                        }
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}