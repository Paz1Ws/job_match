import 'package:flutter/material.dart';
import 'package:job_match/config/constants/layer_constants.dart';

class InfoChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const InfoChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kSpacing8 + kSpacing4,
        vertical: kSpacing4,
      ), // kSpacing12 horizontal
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(kRadius4),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 11.0),
      ), // Font size kept as is
    );
  }
}

class IconTextRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconTextRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: Colors.blue, size: kIconSize18),
        const SizedBox(width: kSpacing8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey[700],
          ), // Font size kept
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: kSpacing20 + kSpacing4,
        bottom: kSpacing8,
      ), // kSpacing24 top
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ), // Font size kept
      ),
    );
  }
}

class JustifiedText extends StatelessWidget {
  final String text;

  const JustifiedText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15.0, // Font size kept
        color: Colors.black87,
        height: 1.5,
      ),
      textAlign: TextAlign.justify,
    );
  }
}

class BulletPointItem extends StatelessWidget {
  final String text;

  const BulletPointItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSpacing4 / 2), // kSpacing2
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 15.0)), // Font size kept
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15.0, // Font size kept
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileSocialShareButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ProfileSocialShareButton({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: kSpacing8),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: kStroke1),
          padding: const EdgeInsets.symmetric(
            horizontal: kPadding12,
            vertical: kPadding8,
          ),
        ),
        icon: Icon(icon, size: kIconSize18),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}

class ProfileOverviewItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileOverviewItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.blue,
          size: kIconSize24 + kSpacing4,
        ), // kIconSize28
        const SizedBox(height: kSpacing8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12, // Font size kept
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: kSpacing4 / 2), // kSpacing2
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14, // Font size kept
          ),
        ),
      ],
    );
  }
}
