import 'package:flutter/material.dart';
import 'package:ulasbuku/homepage/screens/drawer.dart';
import 'package:ulasbuku/homepage/screens/item_card.dart';


class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final List<ShopItem> items = [
    ShopItem("Lihat Buku", Icons.checklist, Color.fromARGB(255, 244, 163, 63)),
    // ShopItem("Daftar Produk", Icons.add_shopping_cart,Color.fromARGB(255, 239, 124, 191)),
    ShopItem("Tambah Item", Icons.add_shopping_cart, Colors.lightGreen),
    ShopItem("Logout", Icons.logout, Colors.lightBlue),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'UlasBuku',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        backgroundColor: Color.fromARGB(221, 68, 128, 202),
        foregroundColor: Colors.white,
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