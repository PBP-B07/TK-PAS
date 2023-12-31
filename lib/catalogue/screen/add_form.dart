import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:ulasbuku/homepage/screens/homepage.dart';
import 'package:ulasbuku/catalogue/screen/catalogue.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';

class ShopFormPage extends StatefulWidget {
  const ShopFormPage({super.key});

  @override
  State<ShopFormPage> createState() => _ShopFormPageState();
}

class _ShopFormPageState extends State<ShopFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _description = "";
  String _author = "";
  String _isbn10 = "";
  String _isbn13 = "";
  String _publishDate = "";
  int _edition = 0;
  String _bestSeller = "";
  double _rating = 0;
  String _category = "";

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
      //drawer: const LeftDrawer(), // Add the pre-made drawer here
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Judul",
                    labelText: "Judul",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelStyle: const TextStyle(
                        fontFamily:
                            'Poppins'), // Set Poppins font for the label
                    hintStyle: const TextStyle(
                        fontFamily: 'Poppins'), // Set Poppins font for the hint
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
                    });
                  },
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
                  decoration: InputDecoration(
                    hintText: "Deskripsi",
                    labelText: "Deskripsi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelStyle: const TextStyle(
                        fontFamily:
                            'Poppins'), // Set Poppins font for the label
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Penulis",
                    labelText: "Penulis",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelStyle: const TextStyle(
                        fontFamily:
                            'Poppins'), // Set Poppins font for the label
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _author = value!;
                    });
                  },
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
                  decoration: InputDecoration(
                    hintText: "ISBN-10",
                    labelText: "ISBN-10",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelStyle: const TextStyle(
                        fontFamily:
                            'Poppins'), // Set Poppins font for the label
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _isbn10 = value!;
                    });
                  },
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
                  decoration: InputDecoration(
                    hintText: "ISBN-13",
                    labelText: "ISBN-13",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelStyle: const TextStyle(
                        fontFamily:
                            'Poppins'), // Set Poppins font for the label
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _isbn13 = value!;
                    });
                  },
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
                  decoration: InputDecoration(
                    hintText: "Tanggal Terbit",
                    labelText: "Tanggal Terbit",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelStyle: const TextStyle(
                        fontFamily:
                            'Poppins'), // Set Poppins font for the label
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _publishDate = value!;
                    });
                  },
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
                  decoration: InputDecoration(
                    hintText: "Edisi",
                    labelText: "Edisi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelStyle: const TextStyle(
                        fontFamily:
                            'Poppins'), // Set Poppins font for the label
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _edition = int.parse(value!);
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Edisi tidak boleh kosong!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Edisi harus berupa angka!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Best Seller",
                    labelText: "Best Seller",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelStyle: const TextStyle(
                        fontFamily:
                            'Poppins'), // Set Poppins font for the label
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _bestSeller = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Best Seller tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: TextFormField(
              //       decoration: InputDecoration(
              //         hintText: "Rating",
              //         labelText: "Rating",
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(5.0),
              //         ),
              //       ),
              //       onChanged: (String? value) {
              //         setState(() {
              //           _rating = double.parse(value!);
              //         });
              //       },
              //       validator: (String? value) {
              //         if (value == null || value.isEmpty) {
              //           return "Rating tidak boleh kosong!";
              //         }
              //         if (double.tryParse(value) == null) {
              //           return "Rating harus berupa angka!";
              //         }
              //         return null;
              //       },
              //     ),
              //   ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Kategori",
                    labelText: "Kategori",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelStyle: const TextStyle(
                        fontFamily:
                            'Poppins'), // Set Poppins font for the label
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _category = value!;
                    });
                  },
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
                      backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Kirim ke Django dan tunggu respons
                        // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                        final response = await request.postJson(
                          //"https://muhammad-farrel21-tugas.pbp.cs.ui.ac.id/create-flutter/"
                          "https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/catalogue/create-flutter/",
                          jsonEncode(<String, dynamic>{
                            'title': _title,
                            'description': _description,
                            'author': _author,
                            'isbn10': _isbn10,
                            'isbn13': _isbn13,
                            'publish_date': _publishDate,
                            'edition': _edition,
                            'best_seller': _bestSeller,
                            'rating': _rating,
                            'category': _category,
                            // TODO: Sesuaikan field data sesuai dengan aplikasimu
                          }),
                        );
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Produk baru berhasil disimpan!"),
                          ));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductPage()),
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
                    child: const Text(
                      "Save",
                      style:
                          TextStyle(fontFamily: 'Poppins', color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
