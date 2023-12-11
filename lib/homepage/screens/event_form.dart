import 'dart:convert';

import 'package:ulasbuku/book/models/product.dart';
import 'package:ulasbuku/homepage/models/item_event.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';
import 'package:ulasbuku/homepage/models/item_event.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/homepage/screens/homepage.dart';

List<Item> productList = [];

class AddItemEventForm extends StatefulWidget {
  final List<Product> products; // Tambahkan ini jika list produk diteruskan ke form

  //const AddItemEventForm({super.key});
   const AddItemEventForm({Key? key, this.products = const []}) : super(key: key);

  @override
  State<AddItemEventForm> createState() => _AddItemState();
}

class _AddItemState extends State<AddItemEventForm> {
  final _formKey = GlobalKey<FormState>();
  String _bookTitle = "";
  String _title = "";
  String _description = "";

   List<String> getBookTitles(List<Product> products) {
    return products.map((product) => product.fields.title).toList();
  }

  
  @override
  Widget build(BuildContext context) {
   
    final request = context.watch<CookieRequest>();

     // Misalkan Anda mendapatkan produk dari sumber lain atau diinisialisasi di sini
    List<Product> products = []; // Anda perlu mengisi ini dengan data produk yang sesuai
    
    List<String> bookTitles = getBookTitles(products);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "TAMBAH EVENT",
          ),
        ),
        backgroundColor: Color.fromARGB(221, 158, 68, 68),
        foregroundColor: Colors.white,
      ),
      // tempat drawer
      drawer: const LeftDrawer(),

      //nampilin body page
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
                          borderRadius: BorderRadius.circular(5))),
                  // isi dari formnya
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
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
                          borderRadius: BorderRadius.circular(5))),
                  // isi dari formnya
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
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
              value: _bookTitle,
              decoration: InputDecoration(
                labelText: 'Book Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              items: bookTitles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _bookTitle = newValue!;
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
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Kirim ke Django dan tunggu respons
                        // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                        final response = await request.postJson(
                             "http://localhost:8000/books/",
                            jsonEncode(<String, String>{
                              'title': _title,
                              'description': _description,
                              'bookTitle': _bookTitle,
                            
                              // TODO: Sesuaikan field data sesuai dengan aplikasimu
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