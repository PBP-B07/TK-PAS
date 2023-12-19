import 'package:flutter/material.dart';
import 'package:ulasbuku/catalogue/screen/catalogue.dart';
import 'package:ulasbuku/homepage/screens/busiest_forum.dart';
import 'package:ulasbuku/homepage/screens/event_page.dart';
import 'package:ulasbuku/homepage/screens/latest_forum_page.dart';
import 'package:ulasbuku/homepage/screens/not_recomended_forum.dart';
import 'package:ulasbuku/homepage/screens/recomended_forum.dart';
import 'package:ulasbuku/homepage/screens/review_page.dart';

class ShopItem {
  final String name;
  final IconData icon;
  final Color color;

  ShopItem(this.name, this.icon, this.color);
}

class ShopCard extends StatelessWidget {
  final ShopItem item;

  const ShopCard(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: () {
        // Area responsive terhadap sentuhan
        // Memunculkan SnackBar ketika diklik
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text("Kamu telah menekan tombol ${item.name}!")));
        if (item.name == "Top Latest Reviews") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const ReviewPage()));
        } else if (item.name == "Latest Event") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const EventPage()));
        } else if (item.name == "Latest Forum") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LatestForumPage()));
        } else if (item.name == "Busiest Forum") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const BusiestForumPage()));
        } else if (item.name == "Recomended Forum") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const RecomendedForumPage()));
        } else if (item.name == "Not Recomended Forum") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NotRecomendedForumPage()));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5038BC),
        minimumSize: const Size.fromHeight(150),
        padding: const EdgeInsets.all(20.0), // Mengatur padding tombol
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0), // Mengatur radius tombol
        ),
      ),
      child: SizedBox(
        // width: screenWidth * 0.25, // Adjust the multiplier as needed
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
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins', // Add fontFamily here
              ),
            ),
          ],
        ),
      ),
    );
  }
}
