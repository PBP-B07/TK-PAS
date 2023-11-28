// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<String> productFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String productToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
