// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  String bookTitle;
  int pk;
  String subject;
  String description;
  DateTime dateAdded;

  Product({
    required this.bookTitle,
    required this.pk,
    required this.subject,
    required this.description,
    required this.dateAdded,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        bookTitle: json["book__title"],
        pk: json["pk"],
        subject: json["subject"],
        description: json["description"],
        dateAdded: DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "book__title": bookTitle,
        "pk": pk,
        "subject": subject,
        "description": description,
        "date_added":
            "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
      };
}
