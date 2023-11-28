// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Model model;
  int pk;
  Fields fields;

  Product({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String title;
  String description;
  String author;
  int isbn10;
  String isbn13;
  String publishDate;
  int edition;
  BestSeller bestSeller;
  int rating;
  Category category;

  Fields({
    required this.title,
    required this.description,
    required this.author,
    required this.isbn10,
    required this.isbn13,
    required this.publishDate,
    required this.edition,
    required this.bestSeller,
    required this.rating,
    required this.category,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        description: json["description"],
        author: json["author"],
        isbn10: json["isbn10"],
        isbn13: json["isbn13"],
        publishDate: json["publish_date"],
        edition: json["edition"],
        bestSeller: bestSellerValues.map[json["best_seller"]]!,
        rating: json["rating"],
        category: categoryValues.map[json["category"]]!,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "author": author,
        "isbn10": isbn10,
        "isbn13": isbn13,
        "publish_date": publishDate,
        "edition": edition,
        "best_seller": bestSellerValues.reverse[bestSeller],
        "rating": rating,
        "category": categoryValues.reverse[category],
      };
}

enum BestSeller { ERTY, NO, YES }

final bestSellerValues = EnumValues(
    {"erty": BestSeller.ERTY, "No": BestSeller.NO, "Yes": BestSeller.YES});

enum Category {
  DATABASE,
  MACHINE_LEARNING,
  POETRY,
  PROGRAMMING,
  SOFTWARE_ENGINEERING,
  THE_234_RFT
}

final categoryValues = EnumValues({
  "Database": Category.DATABASE,
  "Machine Learning": Category.MACHINE_LEARNING,
  "Poetry": Category.POETRY,
  "Programming": Category.PROGRAMMING,
  "Software Engineering": Category.SOFTWARE_ENGINEERING,
  "234rft": Category.THE_234_RFT
});

enum Model { BOOK_BOOK }

final modelValues = EnumValues({"book.book": Model.BOOK_BOOK});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
