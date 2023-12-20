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

  @override
  void initState() {
    super.initState();
    fetchBookTitles();
  }

  Future<void> fetchBookTitles() async {
    final response = await http
        .get(Uri.parse("https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/books/"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<String> titles =
          jsonData.map((book) => book['fields']['title'] as String).toList();
      setState(() {
        bookTitles = titles;
        _selectedBookTitle = titles.isNotEmpty ? titles[0] : null;
      });
    } else {
      throw Exception("Failed to load book titles");
    }
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  style: TextStyle(fontFamily: 'Poppins'), // Use Poppins font
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
                  style: TextStyle(fontFamily: 'Poppins'), // Use Poppins font
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
                // child: Container(
                //   width: 500, // Set a maximum width for the dropdown menu
                child: DropdownButtonFormField<String>(
                  value: _selectedBookTitle,
                  style: TextStyle(fontFamily: 'Poppins'), // Use Poppins font
                  decoration: InputDecoration(
                    hintText: "Book Title",
                    labelText: 'Book Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  isExpanded:
                      true, // Make the dropdown button take up the full width
                  items: bookTitles.isNotEmpty
                      ? bookTitles
                          .toSet()
                          .toList()
                          .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  color: Colors.black, // Mengatur warna teks menjadi hitam
                                  fontFamily: 'Poppins'
                              ),
                            ),
                          );
                        }).toList()
                      : [], // Set to null if bookTitles is empty
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
// ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                            "https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/create-flutter/",
                            jsonEncode(<String, String>{
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
