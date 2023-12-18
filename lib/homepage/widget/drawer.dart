import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/catalogue/screen/catalogue.dart';
import 'package:ulasbuku/homepage/screens/event_page.dart';
import 'package:ulasbuku/homepage/screens/homepage.dart';
import 'package:ulasbuku/homepage/screens/review_page.dart';
import 'package:ulasbuku/login/login.dart';
import 'package:ulasbuku/reviews/screens/reviews_page.dart';
import 'package:ulasbuku/user_profile/screens/profile.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_rounded),
            title: const Text('Profile'),
            onTap: () {
              // Route menu ke halaman produk
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books_rounded),
            title: const Text("Catalogue"),

            //ketika diklik akan ke forms add_item
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProductPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_outlined),
            title: const Text("About UlasBuku"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Sudut tumpul
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width *
                          0.6, // 60% dari lebar layar
                      height: MediaQuery.of(context).size.height *
                          0.4, // 40% dari tinggi layar
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'About UlasBuku',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors
                                    .black, // Sesuaikan warna sesuai tema Anda
                              ),
                              text:
                                  'UlasBuku adalah platform online di mana para pecinta Computer Science '
                                  'dapat memberikan ulasan jujur tentang buku-buku yang mereka baca. '
                                  'Tujuannya untuk membantu orang lain menghindari kesalahan dan memastikan nilai setiap pembelian buku. '
                                  'Dengan pertumbuhan pengguna, kami terus hadirkan fitur baru. '
                                  'Kami meluncurkan forum diskusi untuk anggota berbagi konsep dari buku yang mereka baca, '
                                  'bertukar perspektif, dan bantuan dalam topik sulit.',
                            ),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            child: Text('Tutup'),
                            onPressed: () {
                              //Navigator.of(context).pop(); // Tutup dialog
                              // Navigasi ke homepage
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Logout'),
              onTap: () async {
                final response = await request.logout(
                    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                    "http://localhost:8000/auth/logout/");
                String message = response["message"];
                if (response['status']) {
                  String uname = response["username"];
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$message Sampai jumpa, $uname."),
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$message"),
                  ));
                }
                ;
              })
        ],
      ),
    );
  }
}
