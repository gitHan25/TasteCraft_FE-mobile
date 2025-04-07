import "package:flutter/material.dart";
import "package:taste_craft/shared/theme.dart";

class CustomFormField extends StatelessWidget {
  final String title;
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomFormField({
    super.key,
    required this.title,
    this.hintText,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: darkBrownTextStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            fillColor: bgInputColor,
            filled: true,
            hintText: hintText,
            hintStyle: hintTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: textColor.withOpacity(0.45),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ],
    );
  }
}
