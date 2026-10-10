import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const StatusBadge({
    required this.status,
    this.backgroundColor,
    this.textColor,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = backgroundColor ?? AppColors.leafGreenPale;
    Color fg = textColor ?? AppColors.leafGreenPrimary;

    final lower = status.toLowerCase();
    if (backgroundColor == null) {
      if (lower.contains('pending') || lower.contains('wait')) {
        bg = AppColors.leafGreenAccent.withValues(alpha: 0.38);
        fg = AppColors.leafGreenDeep;
      } else if (lower.contains('complete') ||
          lower.contains('approved') ||
          lower.contains('active')) {
        bg = AppColors.leafGreenPale;
        fg = AppColors.success;
      } else if (lower.contains('cancel') ||
          lower.contains('reject') ||
          lower.contains('inactive')) {
        bg = AppColors.leafBg;
        fg = AppColors.leafGreenDark;
      }
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 30),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 5),
          ],
          Text(
            status,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
