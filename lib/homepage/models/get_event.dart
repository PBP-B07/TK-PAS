// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    String bookTitle;
    String title;
    String description;
    int book;
    int bookPk;

    Product({
        required this.bookTitle,
        required this.title,
        required this.description,
        required this.book,
        required this.bookPk,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        bookTitle: json["book__title"],
        title: json["title"],
        description: json["description"],
        book: json["book"],
        bookPk: json["book__pk"],
    );

    Map<String, dynamic> toJson() => {
        "book__title": bookTitle,
        "title": title,
        "description": description,
        "book": book,
        "book__pk": bookPk,
    };
}
