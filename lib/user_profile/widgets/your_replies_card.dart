import 'package:flutter/material.dart';

class YourRepliesItem {
  final String forumSubject;
  final String message;
  final String forumUserUsername;
  final int forumUserPk;
  final int pk;
  YourRepliesItem(this.forumSubject, this.message, this.forumUserUsername,
      this.forumUserPk, this.pk);
}

class YourRepliesCard extends StatelessWidget {
  final YourRepliesItem item;

  const YourRepliesCard(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User's profile picture (replace with an actual image)
            CircleAvatar(
              backgroundColor: Color(0xFF102542),
              radius: 24,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Message
            Text(
              'You replied "${item.message}"',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Additional information
            Text(
              'on forum "${item.forumSubject}" created by ${item.forumUserUsername}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
