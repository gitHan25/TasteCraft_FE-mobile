import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final dynamic icon;
  final int index;
  final int selectedIndex;
  const NavItem(
      {super.key,
      required this.icon,
      required this.index,
      required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
