import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ulasbuku/forum/screens/forum.dart';
import 'package:ulasbuku/reviews/screens/reviews_page.dart';

class BookDetailsPage extends StatefulWidget {
  final int bookId;

  const BookDetailsPage({Key? key, required this.bookId}) : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  Map<String, dynamic>? bookData;

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
  }

  Future<void> fetchBookDetails() async {
    var url = Uri.parse('http://127.0.0.1:8000/books/get-book/${widget.bookId}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      setState(() {
        bookData = jsonDecode(utf8.decode(response.bodyBytes));
      });

      // print({bookData!['rating']});

    } else {
      throw Exception('Failed to load book details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: bookData != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookData!['title'],
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    bookData!['description'],
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 20.0),
                  Text('Author: ${bookData!['author']}'),
                  Text('ISBN-10: ${bookData!['isbn10']}'),
                  Text('ISBN-13: ${bookData!['isbn13']}'),
                  Text('Publish Date: ${bookData!['publish_date']}'),
                  Text('Edition: ${bookData!['edition']}'),
                  Text('Best Seller: ${bookData!['best_seller']}'),
                  Text('Category: ${bookData!['category']}'),
                  Row(
                    children: [
                      const Text('Average Rating: ', style: TextStyle(fontSize: 16.0)),
                      _buildStarRating(bookData!['rating']),
                      Text(' (${bookData!['rating'].toDouble()} Stars)',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic to navigate to the edit screen
                    },
                    child: const Text('Edit Book'),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic to navigate to the full reviews screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BookReviewPage(bookId: widget.bookId)),
                      );
                    },
                    child: const Text('View Full Reviews'),
                  ),
                  const SizedBox(height: 10.0), // Add space between buttons
                  ElevatedButton(
                    onPressed: () {
                      // Add logic to navigate to the full forums screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ForumPage(bookId: widget.bookId)),
                      );
                    },
                    child: const Text('View Full Forums'),
                  ),
                  // Add widgets to display reviews and forums if needed
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

Widget _buildStarRating(double rating) {
  return Row(
    children: List.generate(
      5,
      (index) => Icon(
        index < rating ? Icons.star : Icons.star_border,
        color: index < rating ? Colors.yellow : Colors.grey,
      ),
    ),
  );
}
