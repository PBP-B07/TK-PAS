import 'package:ulasbuku/login/login.dart';
// import 'package:ulasbuku/screens/list_product.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
// import 'package:ulasbuku/screens/item_list_page.dart';
// import 'package:ulasbuku/screens/login.dart';
// import 'package:ulasbuku/screens/menu.dart';
// import '../screens/add_item_form.dart';

class ShopItem {
  final String name;
  final IconData icon;
  final Color color;
  ShopItem(this.name, this.icon, this.color);
}

class ShopCard extends StatelessWidget {
  final ShopItem item;

  const ShopCard(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: item.color,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () async {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));
      //     if (item.name == "Homepage") {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => const AddItemForm()));
      //     } else if (item.name == "Catalogue") {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => const ProductPage()));
      //     } else if (item.name == "Profile") {
      //   final response = await request.logout(
      //       // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
      //       "http://localhost:8000/auth/logout/");
      //   String message = response["message"];
      //   if (response['status']) {
      //     String uname = response["username"];
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content: Text("$message Sampai jumpa, $uname."),
      //     ));
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => const LoginPage()),
      //     );
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content: Text("$message"),
      //     ));
      //   }
      // }
        },
        child: Container(
          // Container untuk menyimpan Icon dan Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 100.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}