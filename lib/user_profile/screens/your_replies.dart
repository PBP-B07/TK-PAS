import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/user_profile/models/get-reply.dart';

import 'package:ulasbuku/user_profile/widgets/your_replies_card.dart';

class YourRepliesPage extends StatefulWidget {
  const YourRepliesPage({Key? key}) : super(key: key);

  @override
  _YourRepliesPageState createState() => _YourRepliesPageState();
}

class _YourRepliesPageState extends State<YourRepliesPage> {
  Future<List<Product>> fetchProduct(request) async {
    var response =
        await request.get('http://localhost:8000/profile/get_reply/');
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
        title: const Text('Your Replies'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada data reply",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => YourRepliesCard(
                YourRepliesItem(
                  snapshot.data![index].forumSubject,
                  snapshot.data![index].message,
                  snapshot.data![index].forumUserUsername,
                  snapshot.data![index].forumUserPk,
                  snapshot.data![index].pk,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
