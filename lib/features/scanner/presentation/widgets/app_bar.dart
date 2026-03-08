import 'package:event_scanner_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String userName;
  final bool showNotificationSwitch;
  final bool notificationsEnabled;
  final ValueChanged<bool>? onNotificationToggle;

  const CustomAppBar({
    super.key,
    required this.userName,
    this.showNotificationSwitch = false,
    this.notificationsEnabled = false,
    this.onNotificationToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.10,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/voltraLogo.png',
            width: 220,
            height: 80,
          ),
          if (showNotificationSwitch) ...[
            const SizedBox(width: 16),
            Switch(
              value: notificationsEnabled,
              onChanged: onNotificationToggle,
              activeColor: AppColors.accentGreen,
              inactiveThumbColor: Colors.grey[300],
            ),
          ]
        ],
      ),
    );
  }
}