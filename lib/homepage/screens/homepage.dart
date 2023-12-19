import 'package:flutter/material.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';
import 'package:ulasbuku/homepage/widget/item_card.dart';
import 'package:ulasbuku/catalogue/screen/catalogue.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final List<ShopItem> items = [
    ShopItem("Lihat Buku", Icons.checklist, Color.fromARGB(255, 244, 163, 63)),
    ShopItem("Top Latest Reviews", Icons.reviews_outlined, Color.fromARGB(255, 92, 39, 171)),
    ShopItem("Latest Event", Icons.event_note_outlined, Color.fromARGB(255, 229, 218, 11)),
    ShopItem("Latest Forum", Icons.forum_rounded, Color.fromARGB(255, 106, 204, 206)),
    ShopItem("Busiest Forum", Icons.add_shopping_cart, Color.fromARGB(255, 87, 135, 116)),
    ShopItem("Recomended Forum", Icons.recommend_outlined, Color.fromARGB(255, 194, 49, 24)),
    ShopItem("Not Recomended Forum", Icons.not_interested, Color.fromARGB(255, 182, 38, 136)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Menempatkan judul di tengah
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
      drawer: const LeftDrawer(),
      backgroundColor: const Color(0xFFCFFAFE),
      body: SingleChildScrollView(
        // Widget wrapper yang dapat discroll
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding dari halaman
          child: Column(
            // Widget untuk menampilkan children secara vertikal
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                child: Text(
                  'Welcome to UlasBuku', // Text yang menandakan toko
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Display ShopItems vertically without GridView
              for (ShopItem item in items)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    //height: 100,
                    child: ShopCard(item),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
