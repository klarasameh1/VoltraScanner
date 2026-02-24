import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String userName;

  const CustomAppBar({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.10,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0x800053C8),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF000000),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userName,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 10),
            Image.asset(
              'assets/voltraLogo.png',
              width: 60,
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}