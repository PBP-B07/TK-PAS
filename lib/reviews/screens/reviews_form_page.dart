import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/reviews/screens/reviews_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewFormPage extends StatefulWidget {
  final int bookId;

  const ReviewFormPage({Key? key, required this.bookId}) : super(key: key);

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  int _star = 0;
  String _description = "";

  get bookId => widget.bookId;

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
            style: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w700),
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255), // Set the background color
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RatingBar.builder(
                        initialRating: _star.toDouble(),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 30,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _star = rating.toInt();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: const TextStyle(fontFamily: 'Poppins',),
                        decoration: const InputDecoration(
                          labelText: "Deskripsi",
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 1, 51, 168)),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          filled: true, // Mengaktifkan pengisian warna latar belakang
                          fillColor: Color.fromARGB(255, 236, 236, 236), // Menentukan warna latar belakang
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _description = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Deskripsi tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 17,),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF0077C0)),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Kirim ke Django dan tunggu respons
                          final response = await request.postJson(
                            "http://localhost:8000/review/create-reviews-flutter/${widget.bookId}/",
                            jsonEncode(<String, String>{
                              'star': _star.toString(),
                              'description': _description,
                            }),
                          );
                          if (response['status'] == 'success') {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Review berhasil ditambahkan!"),
                              ),
                            );
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookReviewPage(bookId: bookId),
                              ),
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Terdapat kesalahan, silakan coba lagi."),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(fontFamily: 'Poppins',color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
