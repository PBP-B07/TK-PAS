import 'package:flutter/material.dart';

class NavigatorItem {
  final String title;
  final String icon;
  NavigatorItem(this.icon, this.title);
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

  IconData _getIconData(String icon) {
    switch (icon) {
      case 'replies':
        return Icons.reply_rounded;
      case 'reviews':
        return Icons.chat_rounded;
      case 'forums':
        return Icons.forum_rounded;
      default:
        // Return a default icon in case the specified icon is not recognized
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color.fromARGB(255, 1, 51, 168),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            leading: Icon(
              _getIconData(widget.item.icon),
              size: 48.0,
              color: Color.fromARGB(255, 1, 51, 168),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'See items',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            onTap: widget.onPressed,
          ),
        ),
      ),
    );
  }
}
