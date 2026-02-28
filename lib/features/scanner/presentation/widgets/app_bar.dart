import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String userName;

  const CustomAppBar({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.10,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF028ECA),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center (
        child: Image.asset(
          'assets/voltraLogo.png',
          width: 200,
          height: 100,
        ),
      ),
    );
  }
}