import 'package:flutter/material.dart';

class HomePageTopBarButton extends StatelessWidget {

  // String title, {bool selected = false}
  final String title;
  final bool selected;

  const HomePageTopBarButton({
    super.key, required this.title, this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        title,
        style: TextStyle(color: selected ? Colors.white : Colors.white38),
      ),
    );
  }
}
