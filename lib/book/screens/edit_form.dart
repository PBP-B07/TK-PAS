import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:ulasbuku/book/screens/book_details.dart';
// import 'package:ulasbuku/book/models/product.dart' as product;

class EditFormPage extends StatefulWidget {
  // final Map<String, dynamic> bookData;
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

  // Future<Map<String, dynamic>> sendEditedDataToDjango(
  //     Map<String, dynamic> editedData) async {
  //   final response = await http.post(
  //     Uri.parse(
  //         'http://127.0.0.1:8000/books/edit_book_flutter/${widget.bookData['id']}/'), // Replace with your Django API endpoint
  //     body: jsonEncode(editedData),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //   );

  //   print(widget.bookData['id']);
  //   if (response.statusCode == 200) {
  //     print('Data updated successfully');
  //     return {'status': 'success'};
  //   } else {
  //     print('Failed to update data. Status code: ${response.statusCode}');
  //     return {'status': 'error'};
  //   }
  // }

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
    // final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Edit Book'),
          ),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
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
                _rating = snapshot
                    .data?['rating']; // Get the rating from the fetched data
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Similar form fields as in ShopFormPage, but use controllers instead of onChanged
                        // ...
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
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.indigo),
                              ),
                              // onPressed: () async {
                              //   if (_formKey.currentState!.validate()) {
                              //     // Send data to Django and wait for the response
                              //     // Map<String, dynamic> response = await sendEditedDataToDjango(widget.bookData);

                              //     widget.bookData['title'] = _titleController.text;
                              //     widget.bookData['description'] = _descriptionController.text;
                              //     widget.bookData['author'] = _authorController.text;
                              //     widget.bookData['isbn10'] = _isbn10Controller.text;
                              //     widget.bookData['isbn13'] = _isbn13Controller.text;
                              //     widget.bookData['publish_date'] = _publishDateController.text;
                              //     widget.bookData['edition'] = _editionController.text;
                              //     widget.bookData['best_seller'] = _bestSellerController.text;
                              //     widget.bookData['category'] = _categoryController.text;

                              //     // Update the book details page with the new data
                              //     Navigator.pop(context, widget.bookData);
                              //     Map<String, dynamic> response = await sendEditedDataToDjango(widget.bookData);

                              //     if (response['status'] == 'success') {
                              //       ScaffoldMessenger.of(context)
                              //           .showSnackBar(const SnackBar(
                              //         content: Text("Detail buku berhasil diubah!"),
                              //       ));
                              //       Navigator.pop(context);
                              //     } else {
                              //       ScaffoldMessenger.of(context)
                              //           .showSnackBar(const SnackBar(
                              //         content:
                              //             Text("Terdapat kesalahan, silakan coba lagi."),
                              //       ));
                              //     }
                              //   }
                              // },
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await editBook(widget.bookId);
                                  // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BookDetailsPage(bookId: widget.bookId,)));
                                  Navigator.pop(context,
                                      getUpdatedBookData()); // Pass true back to BookDetailsPage
                                }
                              },
                              child: const Text(
                                "Save Changes",
                                style: TextStyle(color: Colors.white),
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
