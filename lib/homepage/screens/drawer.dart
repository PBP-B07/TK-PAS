import 'package:flutter/material.dart';



class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 212, 237, 52)),
            child: Column(
              children: [
                Text(
                  "This Is  UlasBuku",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Cari Buku yang Anda Butuhkan!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Homepage'),

            //Ketika diklik akan ke homepage
            // onTap: () {
            //   Navigator.pushReplacement(context,
            //       MaterialPageRoute(builder: (context) => MyHomePage()));
            // },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text("Catalogue"),

            // ketika diklik akan ke forms add_item
            // onTap: () {
            //   Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => const AddItemForm()));
            // },
          ),
          // ListTile(
          //   leading: const Icon(Icons.shopping_bag_outlined),
          //   title: const Text("Lihat Item"),

          //   // ketika diklik akan ke list item
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const ItemPage()));
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.account_circle_rounded),
            title: const Text('Profile'),
            // onTap: () {
            //     // Route menu ke halaman produk
            //     Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const ProductPage()),
            //   );
            // },
          ),
        ],
      ),
    );
  }
}