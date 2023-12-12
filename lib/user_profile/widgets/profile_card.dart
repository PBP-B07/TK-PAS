import 'package:flutter/material.dart';

class ProfileItem {
  final String name;
  final String username;
  final String description;
  ProfileItem(this.name, this.username, this.description);
}

class ProfileCard extends StatelessWidget {
  final ProfileItem item;
  const ProfileCard(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue, // Avatar background color
              child: Icon(
                Icons.person,
                color: Colors.white, // Icon color
                size: 50.0,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Username: ${item.username}",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Description: ${item.description}",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
