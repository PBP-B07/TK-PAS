// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    int user;
    String userUsername;
    DateTime dateAdded;
    String subject;
    String description;
    int pk;
    String bookTitle;
    int bookPk;

    Product({
        required this.user,
        required this.userUsername,
        required this.dateAdded,
        required this.subject,
        required this.description,
        required this.pk,
        required this.bookTitle,
        required this.bookPk,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        user: json["user"],
        userUsername: json["user__username"],
        dateAdded: DateTime.parse(json["date_added"]),
        subject: json["subject"],
        description: json["description"],
        pk: json["pk"],
        bookTitle: json["book__title"],
        bookPk: json["book__pk"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "user__username": userUsername,
        "date_added": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "subject": subject,
        "description": description,
        "pk": pk,
        "book__title": bookTitle,
        "book__pk": bookPk,
    };
}
