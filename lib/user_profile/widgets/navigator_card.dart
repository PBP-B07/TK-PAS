import 'package:flutter/material.dart';

class NavigatorItem {
  final String title;
  final int amount;
  final String icon;
  NavigatorItem(this.icon, this.title, this.amount);
}

class NavigatorCard extends StatefulWidget {
  final NavigatorItem item;
  final VoidCallback? onPressed;

  const NavigatorCard(this.item, {this.onPressed, Key? key}) : super(key: key);

  @override
  _NavigatorCardState createState() => _NavigatorCardState();
}

class _NavigatorCardState extends State<NavigatorCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Card(
          margin: const EdgeInsets.all(4.0),
          color: isHovered ? Color(0xFF102542) : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icon on the left side
                Icon(
                  IconData(int.parse(widget.item.icon),
                      fontFamily: 'MaterialIcons'),
                  size: 48.0,
                  color: isHovered ? Colors.white : Color(0xFF102542),
                ),
                SizedBox(width: 16.0), // Space between icon and text
                // Text on the left side
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: isHovered ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '${widget.item.amount} items',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
