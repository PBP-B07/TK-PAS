import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:ulasbuku/user_profile/models/get-reviews.dart';
import 'package:ulasbuku/homepage/widget/drawer.dart';
import 'package:ulasbuku/login/login.dart';

import 'package:ulasbuku/user_profile/widgets/your_reviews_card.dart';

class YourRepliesPage extends StatefulWidget {
  const YourRepliesPage({Key? key}) : super(key: key);

  @override
  _YourRepliesPageState createState() => _YourRepliesPageState();
}

class _YourRepliesPageState extends State<YourRepliesPage> {
  Future<List<Product>> fetchProduct(request) async {
    var response =
        await request.get('http://localhost:8000/profile/get_forum/');
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
        title: const Text('Your Forums'),
        backgroundColor: Colors.blue,
      ),
      drawer: const LeftDrawer(),
      body: Container(),
    );
  }
}
