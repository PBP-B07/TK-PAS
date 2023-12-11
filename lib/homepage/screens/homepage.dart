import 'package:flutter/material.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';
import 'package:ulasbuku/homepage/widget/item_card.dart';
import 'package:ulasbuku/catalogue/screen/catalogue.dart';


class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final List<ShopItem> items = [
    ShopItem("Lihat Buku", Icons.checklist, Color.fromARGB(255, 244, 163, 63)),
    // ShopItem("Daftar Produk", Icons.add_shopping_cart,Color.fromARGB(255, 239, 124, 191)),
    // ShopItem("Tambah Item", Icons.add_shopping_cart, Colors.lightGreen),
    //ShopItem("Logout", Icons.logout, Colors.lightBlue),
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
        iconTheme: IconThemeData(color: Colors.black),
        title: Center(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
        backgroundColor: Colors.white, // Example color, change as needed
      ),
      drawer: const LeftDrawer(),
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
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Grid layout
              GridView.count(
                // Container pada card kita.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: items.map((ShopItem item) {
                  // Iterasi untuk setiap item
                  return ShopCard(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}