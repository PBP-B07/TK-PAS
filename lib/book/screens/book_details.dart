import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:ulasbuku/book/screens/edit_form.dart';
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
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
    fetchRecentReviews();
    fetchRecentForums();
  }

  @override
  void didChangeDependencies() {
    // print('here');
    super.didChangeDependencies();
    final request = context.watch<CookieRequest>();
    fetchAdminStatus(request);
  }

  Future<void> fetchAdminStatus(request) async {
    var url = 'https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/catalogue/is-admin/';
    // print('Status admin sebelum fetch: $isAdmin');

    try {
      var response = await request.get(url);
      // print('Response: $response');

      // Directly using the response assuming it is already a JSON object
      if (response['is_admin'] != null) {
        setState(() {
          isAdmin = response['is_admin'];
          // print('Status admin setelah fetch: $isAdmin');
        });
      } else {
        // print('Invalid response format');
      }
    } catch (e) {
      // print('Error fetching admin status: $e');
    }
  }

  Future<void> fetchBookDetails() async {
    var url = Uri.parse(
        'https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/books/get-book/${widget.bookId}/');
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
        'https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/review/get-reviews-json/${widget.bookId}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<review_product.Product> reviews =
          (jsonDecode(utf8.decode(response.bodyBytes)) as List)
              .map((review) => review_product.Product.fromJson(review))
              .toList();

      reviews.sort((a, b) =>
          b.pk.compareTo(a.pk)); // Sort reviews by PK in descending order

      List<review_product.Product> selectedReviews =
          reviews.sublist(0, min(3, reviews.length));
      setState(() {
        recentReviews = selectedReviews;
      });
    } else {
      throw Exception('Failed to load recent reviews');
    }
  }

  Future<void> fetchRecentForums() async {
    var url = Uri.parse(
        'https://ulasbuku-b07-tk.pbp.cs.ui.ac.id/forum/get-forum/${widget.bookId}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<forum_product.Product> forums =
          (jsonDecode(utf8.decode(response.bodyBytes)) as List)
              .map((forum) => forum_product.Product.fromJson(forum))
              .toList();

      forums.sort((a, b) =>
          b.pk.compareTo(a.pk)); // Sort forums by PK in descending order

      List<forum_product.Product> selectedForums =
          forums.sublist(0, min(3, forums.length));

      setState(() {
        recentForums = selectedForums;
      });
    } else {
      throw Exception('Failed to load recent forums');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Menempatkan judul di tengah
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 32,
                fontWeight: FontWeight.w700),
            children: [
              TextSpan(
                text: 'Ulas',
                style: TextStyle(color: Color(0xFF0919CD)),
              ),
              TextSpan(
                text: 'Buku',
                style: TextStyle(color: Color(0xFFC51605)),
              ),
            ],
          ),
        ),
      ),
      body: bookData != null
          ? ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 8.0,
                    color: const Color(0xFFCFFAFE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              bookData!['title'],
                              style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Center(
                            child: Text(
                              '"${bookData!['description']}"',
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          // <---Book Details Section
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _buildBookDetailsSection(),
                          ),
                          const SizedBox(height: 30.0),
                          Center(
                            child: _buildSectionHeader('Recent Reviews'),
                          ),
                          const SizedBox(height: 10.0),
                          Center(
                            child: Text(
                                'Total Reviews: ${recentReviews.length}',
                                style: const TextStyle(
                                    fontSize: 16.0, fontFamily: 'Poppins')),
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
                                    builder: (context) =>
                                        BookReviewPage(bookId: widget.bookId),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5038BC),
                                padding: const EdgeInsets.all(20.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: const Text(
                                'View Full Reviews',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Center(
                            child: _buildSectionHeader('Recent Forums'),
                          ),
                          const SizedBox(height: 10.0),
                          Center(
                            child: Text('Total Forums: ${recentForums.length}',
                                style: const TextStyle(
                                    fontSize: 16.0, fontFamily: 'Poppins')),
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
                                    builder: (context) => ForumPage(
                                        bookId: widget.bookId,
                                        bookTitle: bookData!['title']),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5038BC),
                                padding: const EdgeInsets.all(20.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: const Text(
                                'View Full Forums',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Visibility(
                            visible: isAdmin,
                            child: Center(
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5038BC),
                                  padding: const EdgeInsets.all(20.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                child: const Text(
                                  'Edit Book',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
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

  Widget _buildBookDetailsSection() {
    return Card(
      elevation: 8.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Book Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const Divider(
              height: 20,
              thickness: 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem('Author :', bookData!['author']),
                _buildDetailItem('ISBN-10 :', bookData!['isbn10']),
                _buildDetailItem('ISBN-13 :', bookData!['isbn13']),
                _buildDetailItem('Publish Date :', bookData!['publish_date']),
                _buildDetailItem('Edition :', bookData!['edition'].toString()),
                _buildDetailItem('Best Seller :', bookData!['best_seller']),
                _buildDetailItem('Category :', bookData!['category']),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 2,
            ),
            const Center(
              child: Text(
                'Rating :',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStarRating(bookData!['rating']),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    '(${bookData!['rating'].toDouble().toStringAsFixed(1)})',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            fontSize: 16.0, fontFamily: 'Poppins', color: Colors.black),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedBox(width: 5),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black, // Mengatur warna value menjadi hitam
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating ? Colors.amber : Colors.grey,
          size: 24.0, // Adjust the size based on your preference
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
    );
  }

  Widget _buildReviewCard(review_product.Product review) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStarRating(review.star.toDouble()),
                Flexible(
                  child: Text(
                    ' (${review.star.toDouble()} Stars)',
                    style:
                        const TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
                  ),
                )
              ],
            ),
            Text(
              'by ${review.profileName}',
              style: const TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 10.0),
            Text(
              '"${review.description}"',
              style: const TextStyle(
                  fontStyle: FontStyle.italic, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget _buildForumCard(forum_product.Product forum) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
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
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
              ],
            ),
            Text('by ${forum.userUsername}',
                style:
                    const TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
            const SizedBox(height: 10.0),
            Text(
              '"${forum.description}"',
              style: const TextStyle(
                  fontStyle: FontStyle.italic, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 10.0),
            Text('Last Replied: ${forum.dateAdded.toLocal()}',
                style:
                    const TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
