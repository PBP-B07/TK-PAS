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
            border: Border.all(
              color: isHovered ? Colors.white : Color(0xFF102542),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            leading: Icon(
              IconData(int.parse(widget.item.icon),
                  fontFamily: 'MaterialIcons'),
              size: 48.0,
              color: isHovered ? Colors.white : Color(0xFF102542),
            ),
            title: Column(
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
                  'See items',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            tileColor: isHovered ? Color(0xFF102542) : null,
            onTap: widget.onPressed,
          ),
        ),
      ),
    );
  }
}
