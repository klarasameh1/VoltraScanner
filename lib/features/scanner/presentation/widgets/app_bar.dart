import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final String userName;

  const CustomAppBar({super.key, required this.userName});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF101922),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF000000),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child:Row(
          children: [
            Text(
              widget.userName,
              style: const TextStyle(
                color: Color(0xFF0053C8),
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}