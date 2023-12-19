import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/user_profile/models/get-profile.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';
import 'package:ulasbuku/login/login.dart';

import 'package:ulasbuku/user_profile/screens/your_reviews.dart';
import 'package:ulasbuku/user_profile/screens/your_forums.dart';
import 'package:ulasbuku/user_profile/screens/your_replies.dart';

import 'package:ulasbuku/user_profile/widgets/profile_card.dart';
import 'package:ulasbuku/user_profile/widgets/navigator_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<Product>> fetchProduct(request) async {
    var response = await request.get('http://localhost:8000/profile/get/');
    print(response);

    List<Product> list_product = [];
    for (var d in response) {
      if (d != null) {
        list_product.add(Product.fromJson(d));
      }
    }
    return list_product;
  }

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
      backgroundColor: const Color(0xFFCFFAFE),
      drawer: const LeftDrawer(),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600), // Set your maximum width
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 8),
              FutureBuilder(
                future: fetchProduct(request),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xff59A5D8),
                            fontSize: 20),
                      ),
                    );
                  } else {
                    if (!snapshot.hasData) {
                      return const Column(
                        children: [
                          Text(
                            "Tidak ada data profile.",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xff59A5D8),
                                fontSize: 20),
                          ),
                          SizedBox(height: 8),
                        ],
                      );
                    } else {
                      // TODO: Buatlah profile card dengan parameter yang dipass name=uname, username=snapshot field username, dan description=description field description
                      Product profileData = snapshot.data![0];

                      return Column(
                        children: [
                          ProfileCard(
                            ProfileItem(
                              LoginPage.uname,
                              profileData.fields.name,
                              profileData.fields.description,
                            ),
                          ),
                          SizedBox(height: 16.0), // Add vertical space
                          NavigatorCard(
                            NavigatorItem('63025', 'Your Reviews'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const YourReviewsPage()),
                              );
                            },
                          ),
                          NavigatorCard(
                            NavigatorItem('58618', 'Your Forums'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const YourForumsPage()),
                              );
                            },
                          ),
                          NavigatorCard(
                            NavigatorItem('983294', 'Your Replies'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const YourRepliesPage()),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
