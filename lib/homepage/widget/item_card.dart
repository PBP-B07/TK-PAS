import 'package:ulasbuku/homepage/screens/busiest_forum.dart';
import 'package:ulasbuku/homepage/screens/event_page.dart';
import 'package:ulasbuku/homepage/screens/latest_forum_page.dart';
import 'package:ulasbuku/homepage/screens/not_recomended_forum.dart';
import 'package:ulasbuku/homepage/screens/recomended_forum.dart';
import 'package:ulasbuku/homepage/screens/review_page.dart';
import 'package:ulasbuku/login/login.dart';
// import 'package:ulasbuku/screens/list_product.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/catalogue/screen/catalogue.dart';
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
    return  SizedBox(
      width: 80, // Lebar card
      height: 40, // Tinggi card
    child: Material(
      color: item.color,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () async {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));
          if (item.name == "Lihat Buku") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProductPage()));
          }  if (item.name == "Top Latest Reviews") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ReviewPage()));
          } if (item.name == "Latest Event") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EventPage()));
          } if (item.name == "Latest Forum") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LatestForumPage()));
          } if (item.name == "Busiest Forum") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BusiestForumPage()));
          } if (item.name == "Recomended Forum") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RecomendedForumPage()));
          } if (item.name == "Not Recomended Forum") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NotRecomendedForumPage()));
          } 
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
                  size: 50.0,
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
      ),
    );
  }
}