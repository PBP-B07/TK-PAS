import 'package:flutter/material.dart';

class YourForumsItem {
  final String bookTitle;
  final int pk;
  final String subject;
  final String description;
  final DateTime dateAdded;
  YourForumsItem(
      this.bookTitle, this.pk, this.subject, this.description, this.dateAdded);
  String get formattedDateAdded =>
      "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}";
}

class YourForumsCard extends StatelessWidget {
  final YourForumsItem item;
  const YourForumsCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject
            Text(
              "Subject: ${item.subject}",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),

            // User Info
            Row(
              children: [
                Icon(Icons.account_circle_rounded,
                    color: Colors.grey), // Adjusted color
                SizedBox(width: 4.0),
                Text(
                  'You',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey, // Adjusted color
                  ),
                ),
                SizedBox(width: 4.0),
              ],
            ),
            SizedBox(height: 12.0),

            // Description
            Text(
              "Description: ${item.description}",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontStyle: FontStyle.italic,
                color: Colors.black, // Adjusted color
              ),
            ),

            SizedBox(height: 12.0),

            // Date
            Text(
              "Created forum on ${item.formattedDateAdded}",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),

            SizedBox(height: 12.0),

            // Date
            Text(
              'in book titled "${item.bookTitle}"',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
