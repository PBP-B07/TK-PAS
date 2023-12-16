import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ulasbuku/book/screens/edit_form.dart';
import 'dart:convert';

import 'package:ulasbuku/reviews/screens/reviews_page.dart';
import 'package:ulasbuku/forum/screens/forum.dart';
import 'package:ulasbuku/reviews/models/product.dart' as review_product;
import 'package:ulasbuku/forum/models/product_forum.dart' as forum_product;

class BookDetailsPage extends StatefulWidget {
  final int bookId;

  const BookDetailsPage({Key? key, required this.bookId}) : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  Map<String, dynamic>? bookData;
  List<review_product.Product> recentReviews = [];
  List<forum_product.Product> recentForums = [];

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
    fetchRecentReviews();
    fetchRecentForums();
  }

  Future<void> fetchBookDetails() async {
    var url =
        Uri.parse('http://127.0.0.1:8000/books/get-book/${widget.bookId}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      setState(() {
        bookData = jsonDecode(utf8.decode(response.bodyBytes));
      });
    } else {
      throw Exception('Failed to load book details');
    }
  }

  Future<void> fetchRecentReviews() async {
    var url = Uri.parse(
        'http://127.0.0.1:8000/review/get-reviews-json/${widget.bookId}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<review_product.Product> reviews =
          (jsonDecode(utf8.decode(response.bodyBytes)) as List)
              .map((review) => review_product.Product.fromJson(review))
              .toList();

      setState(() {
        recentReviews = reviews;
      });
    } else {
      throw Exception('Failed to load recent reviews');
    }
  }

  Future<void> fetchRecentForums() async {
    var url =
        Uri.parse('http://127.0.0.1:8000/forum/get-forum/${widget.bookId}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<forum_product.Product> forums =
          (jsonDecode(utf8.decode(response.bodyBytes)) as List)
              .map((forum) => forum_product.Product.fromJson(forum))
              .toList();

      setState(() {
        recentForums = forums;
      });
    } else {
      throw Exception('Failed to load recent forums');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: bookData != null
          ? ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            // Menengahkan judul
                            child: Text(
                              bookData!['title'],
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Center(
                            // Menengahkan deskripsi
                            child: Text(
                              bookData!['description'],
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text('Author: ${bookData!['author']}'),
                          Text('ISBN-10: ${bookData!['isbn10']}'),
                          Text('ISBN-13: ${bookData!['isbn13']}'),
                          Text('Publish Date: ${bookData!['publish_date']}'),
                          Text('Edition: ${bookData!['edition']}'),
                          Text('Best Seller: ${bookData!['best_seller']}'),
                          Text('Category: ${bookData!['category']}'),
                          const SizedBox(height: 20.0),
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                const Text('Average Rating: ', style: TextStyle(fontSize: 20.0)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _buildStarRating(bookData!['rating']),
                                    Text(
                                      ' (${bookData!['rating'].toDouble()} Stars)',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          Center(
                            child: _buildSectionHeader('Recent Reviews'),
                          ),
                          const SizedBox(height: 10.0),
                          Center(
                            child:
                                Text('Total Reviews: ${recentReviews.length}'),
                          ),
                          if (recentReviews.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10.0),
                                for (int i = 0;
                                    i < recentReviews.length && i < 3;
                                    i++)
                                  _buildReviewCard(recentReviews[i]),
                              ],
                            ),
                          const SizedBox(height: 10.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookReviewPage(
                                          bookId: widget.bookId)),
                                );
                              },
                              child: const Text('View Full Reviews'),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Center(
                            child: _buildSectionHeader('Recent Forums'),
                          ),
                          const SizedBox(height: 10.0),
                          Center(
                            child: Text('Total Forums: ${recentForums.length}'),
                          ),
                          if (recentForums.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10.0),
                                for (int i = 0;
                                    i < recentForums.length && i < 3;
                                    i++)
                                  _buildForumCard(recentForums[i]),
                              ],
                            ),
                          const SizedBox(height: 10.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForumPage(bookId: widget.bookId)),
                                );
                              },
                              child: const Text('View Full Forums'),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditFormPage(bookId: widget.bookId),
                                  ),
                                ).then((updatedData) {
                                  if (updatedData != null) {
                                    setState(() {
                                      bookData = updatedData;
                                    });
                                  }
                                });
                              },
                              child: const Text('Edit Book'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildReviewCard(review_product.Product review) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // const Text('Rating: ', style: TextStyle(fontSize: 16.0)),
                _buildStarRating(review.star as double),
                Text(
                  ' (${review.star.toDouble()} Stars)',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Text('by ${review.profileName}', style: const TextStyle(color: Colors.grey),),
            const SizedBox(height: 10.0),
            Text(review.description),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget _buildForumCard(forum_product.Product forum) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  forum.subject,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text('by ${forum.userUsername}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10.0),
            Text(forum.description),
            const SizedBox(height: 10.0),
            Text('Posted on: ${forum.dateAdded.toLocal()}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
