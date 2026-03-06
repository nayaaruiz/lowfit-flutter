import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF26263D),
      elevation: 0,
      centerTitle: true,
      title: SvgPicture.asset(
        'assets/logo_petite.svg',
        height: 30,
      ),
    );
  }
}