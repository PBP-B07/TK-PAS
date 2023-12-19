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
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor:
              Color.fromARGB(255, 1, 51, 168), // Avatar background color
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
            fontFamily: 'Poppins',
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Username: ${item.username}",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Description: ${item.description}",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
