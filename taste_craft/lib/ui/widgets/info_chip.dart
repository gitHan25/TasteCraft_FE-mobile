import 'package:flutter/material.dart';
import 'package:taste_craft/shared/theme.dart';

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;

  const InfoChip({
    super.key,
    required this.icon,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor ?? Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: whiteTextStyle.copyWith(
              fontSize: 12,
              color: textColor ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
