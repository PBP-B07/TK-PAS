import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/forum/screens/reply.dart';

class ReplyFormPage extends StatefulWidget {
  final int bookId;
  final int forumId;
  final String bookTitle;
  final String forumTitle;

  const ReplyFormPage(
      {Key? key,
      required this.bookId,
      required this.forumId,
      required this.bookTitle,
      required this.forumTitle})
      : super(key: key);

  @override
  State<ReplyFormPage> createState() => _ReplyFormPageState();
}

class _ReplyFormPageState extends State<ReplyFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _message = "";

  get bookId => widget.bookId;
  get forumId => widget.forumId;

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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 255, 255, 255), // Set the background color
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
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                        ),
                        decoration: const InputDecoration(
                          labelText: "Message",
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 25, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 1, 51, 168)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          filled:
                              true, // Mengaktifkan pengisian warna latar belakang
                          fillColor: Color.fromARGB(255, 236, 236,
                              236), // Menentukan warna latar belakang
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _message = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Message tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF5038BC)),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Kirim ke Django dan tunggu respons
                          final response = await request.postJson(
                            "http://localhost:8000/forum/${widget.bookId}/create-reply-flutter/${widget.forumId}/",
                            jsonEncode(<String, String>{
                              'message': _message,
                            }),
                          );
                          if (response['status'] == 'success') {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Reply berhasil ditambahkan!"),
                              ),
                            );
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReplyPage(
                                  bookId: bookId,
                                  forumId: forumId,
                                  bookTitle: widget.bookTitle,
                                  forumTitle: widget.forumTitle,
                                ),
                              ),
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Terdapat kesalahan, silakan coba lagi."),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
