// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  int bookRating;
  String bookTitle;
  int bookPk;
  int pk;
  String description;
  int star;
  DateTime dateAdded;

  Product({
    required this.bookRating,
    required this.bookTitle,
    required this.bookPk,
    required this.pk,
    required this.description,
    required this.star,
    required this.dateAdded,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        bookRating: json["book__rating"],
        bookTitle: json["book__title"],
        bookPk: json["book__pk"],
        pk: json["pk"],
        description: json["description"],
        star: json["star"],
        dateAdded: DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "book__rating": bookRating,
        "book__title": bookTitle,
        "book__pk": bookPk,
        "pk": pk,
        "description": description,
        "star": star,
        "date_added":
            "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
      };
}
