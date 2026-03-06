import 'package:flutter/material.dart';
import 'package:flutter_lowfit/features/home/view/home_page.dart';
import 'package:flutter_lowfit/features/class_list/view/class_list_page.dart';
import 'package:flutter_lowfit/features/my_account/view/my_account_page.dart';
import 'package:flutter_lowfit/features/shared/bottom_navigation_item.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const MyBottomNavigationBar({
    super.key,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        top: 16,
        bottom: bottomPadding > 0 ? bottomPadding + 8 : 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF4C4C6B),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF3E3464),
            blurRadius: 1,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomNavigationItem(
            label: 'Home',
            icon: Icons.home_outlined,
            active: currentIndex == 0,
            onTap: () {
              if (currentIndex != 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomePage(),
                  ),
                );
              }
            },
          ),
          BottomNavigationItem(
            label: 'Clases',
            icon: Icons.calendar_today_outlined,
            active: currentIndex == 1,
            onTap: () {
              if (currentIndex != 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClassListPage(),
                  ),
                );
              }
            },
          ),
          BottomNavigationItem(
            label: 'Account',
            icon: Icons.person_outline,
            active: currentIndex == 2,
            onTap: () {
              if (currentIndex != 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MyAccountPage(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
