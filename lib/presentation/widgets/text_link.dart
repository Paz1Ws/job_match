import 'package:flutter/material.dart';

class TextLink extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final Color normalColor;
  final Color hoverColor;
  final bool underlineOnHover;

  const TextLink({
    super.key,
    required this.text,
    this.onTap,
    this.normalColor = Colors.blue,
    this.hoverColor = Colors.blueAccent,
    this.underlineOnHover = true,
  });

  @override
  State<TextLink> createState() => _TextLinkState();
}

class _TextLinkState extends State<TextLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: TextStyle(
            color: _isHovered ? widget.hoverColor : widget.normalColor,
            decoration: _isHovered && widget.underlineOnHover
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
