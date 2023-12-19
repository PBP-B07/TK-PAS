import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditFormPage extends StatefulWidget {
  final int bookId;

  const EditFormPage({Key? key, required this.bookId}) : super(key: key);

  @override
  _EditFormPageState createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _authorController;
  late TextEditingController _isbn10Controller;
  late TextEditingController _isbn13Controller;
  late TextEditingController _publishDateController;
  late TextEditingController _editionController;
  late TextEditingController _bestSellerController;
  late TextEditingController _categoryController;

  double? _rating;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _authorController = TextEditingController();
    _isbn10Controller = TextEditingController();
    _isbn13Controller = TextEditingController();
    _publishDateController = TextEditingController();
    _editionController = TextEditingController();
    _bestSellerController = TextEditingController();
    _categoryController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _authorController.dispose();
    _isbn10Controller.dispose();
    _isbn13Controller.dispose();
    _publishDateController.dispose();
    _editionController.dispose();
    _bestSellerController.dispose();
    _categoryController.dispose();
    super.dispose();
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
        body: FutureBuilder(
            future: fetchBookDetails(widget.bookId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                _rating = snapshot.data?['rating']; // Get the rating from the fetched data
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Edit Book',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: "Judul",
                              labelText: "Judul",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelStyle: const TextStyle(fontFamily: 'Poppins'), // Set Poppins font for the label
                              hintStyle: const TextStyle(fontFamily: 'Poppins'),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Judul tidak boleh kosong!";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              hintText: "Deskripsi",
                              labelText: "Deskripsi",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelStyle: const TextStyle(fontFamily: 'Poppins'), // Set Poppins font for the label
                              hintStyle: const TextStyle(fontFamily: 'Poppins'),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Deskripsi tidak boleh kosong!";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _authorController,
                            decoration: InputDecoration(
                              hintText: "Penulis",
                              labelText: "Penulis",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelStyle: const TextStyle(fontFamily: 'Poppins'), // Set Poppins font for the label
                              hintStyle: const TextStyle(fontFamily: 'Poppins'),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Penulis tidak boleh kosong!";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _isbn10Controller,
                            decoration: InputDecoration(
                              hintText: "ISBN-10",
                              labelText: "ISBN-10",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelStyle: const TextStyle(fontFamily: 'Poppins'), // Set Poppins font for the label
                              hintStyle: const TextStyle(fontFamily: 'Poppins'),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "ISBN-10 tidak boleh kosong!";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _isbn13Controller,
                            decoration: InputDecoration(
                              hintText: "ISBN-13",
                              labelText: "ISBN-13",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelStyle: const TextStyle(fontFamily: 'Poppins'), // Set Poppins font for the label
                              hintStyle: const TextStyle(fontFamily: 'Poppins'),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "ISBN-13 tidak boleh kosong!";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _publishDateController,
                            decoration: InputDecoration(
                              hintText: "Tanggal Terbit",
                              labelText: "Tanggal Terbit",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelStyle: const TextStyle(fontFamily: 'Poppins'), // Set Poppins font for the label
                              hintStyle: const TextStyle(fontFamily: 'Poppins'),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Tanggal Terbit tidak boleh kosong!";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _editionController,
                            decoration: InputDecoration(
                              hintText: "Edisi",
                              labelText: "Edisi",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelStyle: const TextStyle(fontFamily: 'Poppins'), // Set Poppins font for the label
                              hintStyle: const TextStyle(fontFamily: 'Poppins'),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Edisi tidak boleh kosong!";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _bestSellerController,
                            decoration: InputDecoration(
                              hintText: "Best Seller",
                              labelText: "Best Seller",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelStyle: const TextStyle(fontFamily: 'Poppins'), // Set Poppins font for the label
                              hintStyle: const TextStyle(fontFamily: 'Poppins'),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Best Seller tidak boleh kosong!";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _categoryController,
                            decoration: InputDecoration(
                              hintText: "Kategori",
                              labelText: "Kategori",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelStyle: const TextStyle(fontFamily: 'Poppins'), // Set Poppins font for the label
                              hintStyle: const TextStyle(fontFamily: 'Poppins'),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Kategori tidak boleh kosong!";
                              }
                              return null;
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await editBook(widget.bookId);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(
                                    context,
                                    getUpdatedBookData(),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5038BC),
                                padding: const EdgeInsets.all(20.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: const Text(
                                'Save Changes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
  }

  Future<Map<String, dynamic>> fetchBookDetails(int bookId) async {
    var url = Uri.parse('http://127.0.0.1:8000/books/get-book/$bookId/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var bookData = jsonDecode(utf8.decode(response.bodyBytes));
      _titleController.text = bookData['title'];
      _descriptionController.text = bookData['description'];
      _authorController.text = bookData['author'];
      _isbn10Controller.text = bookData['isbn10'];
      _isbn13Controller.text = bookData['isbn13'];
      _publishDateController.text = bookData['publish_date'];
      _editionController.text = bookData['edition'].toString();
      _bestSellerController.text = bookData['best_seller'];
      _categoryController.text = bookData['category'];

      return bookData;
    } else {
      throw Exception('Failed to load book details');
    }
  }

  Future<void> editBook(int bookId) async {
    var url =
        Uri.parse('http://127.0.0.1:8000/books/edit_book_flutter/$bookId/');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(<String, dynamic>{
        'title': _titleController.text,
        'description': _descriptionController.text,
        'author': _authorController.text,
        'isbn10': _isbn10Controller.text,
        'isbn13': _isbn13Controller.text,
        'publish_date': _publishDateController.text,
        'edition': _editionController.text,
        'best_seller': _bestSellerController.text,
        'category': _categoryController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
    } else {
      throw Exception('Failed to edit book');
    }
  }

  Map<String, dynamic> getUpdatedBookData() {
    return {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'author': _authorController.text,
      'isbn10': _isbn10Controller.text,
      'isbn13': _isbn13Controller.text,
      'publish_date': _publishDateController.text,
      'edition': _editionController.text,
      'best_seller': _bestSellerController.text,
      'category': _categoryController.text,
      'rating': _rating
    };
  }
}
