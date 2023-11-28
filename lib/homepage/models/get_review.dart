// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  String profileName;
  String bookTitle;
  int star;
  String description;
  int bookPk;

  Product({
    required this.profileName,
    required this.bookTitle,
    required this.star,
    required this.description,
    required this.bookPk,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        profileName: json["profile__name"],
        bookTitle: json["book__title"],
        star: json["star"],
        description: json["description"],
        bookPk: json["book__pk"],
      );

  Map<String, dynamic> toJson() => {
        "profile__name": profileName,
        "book__title": bookTitle,
        "star": star,
        "description": description,
        "book__pk": bookPk,
      };
}
