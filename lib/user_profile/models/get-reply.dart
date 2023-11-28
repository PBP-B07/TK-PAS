// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  String forumSubject;
  String message;
  String forumUserUsername;
  int forumUserPk;
  int pk;

  Product({
    required this.forumSubject,
    required this.message,
    required this.forumUserUsername,
    required this.forumUserPk,
    required this.pk,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        forumSubject: json["forum__subject"],
        message: json["message"],
        forumUserUsername: json["forum__user__username"],
        forumUserPk: json["forum__user__pk"],
        pk: json["pk"],
      );

  Map<String, dynamic> toJson() => {
        "forum__subject": forumSubject,
        "message": message,
        "forum__user__username": forumUserUsername,
        "forum__user__pk": forumUserPk,
        "pk": pk,
      };
}
