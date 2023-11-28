// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  int user;
  String userUsername;
  String message;
  int pk;

  Product({
    required this.user,
    required this.userUsername,
    required this.message,
    required this.pk,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        user: json["user"],
        userUsername: json["user__username"],
        message: json["message"],
        pk: json["pk"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "user__username": userUsername,
        "message": message,
        "pk": pk,
      };
}
