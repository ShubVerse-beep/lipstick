import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../utils/auth_guard.dart';
import 'connectivity_badge.dart';

/// Top navigation bar used across dashboards.
/// Shows a title, optional notification icon, and a hamburger button on small screens.
class TopNavbar extends StatelessWidget {
  final String title;
  final bool showDrawerButton;
  const TopNavbar(
      {required this.title, this.showDrawerButton = true, super.key});

  @override
  Widget build(BuildContext context) {
    final role = AuthGuard.currentUserRole ?? 'patient';
    return AppBar(
      backgroundColor: AppColors.leafGreenPrimary,
      iconTheme: const IconThemeData(color: Colors.white, size: 24),
      leading: showDrawerButton
          ? IconButton(
              tooltip: 'Open menu',
              icon: const Icon(AppIcons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 19,
        ),
      ),
      actions: [
        const Center(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ConnectivityBadge())),
        IconButton(
          tooltip: 'Notifications',
          icon: const Icon(AppIcons.notifications),
          onPressed: () => context.push('/notifications'),
        ),
        // Profile avatar / menu
        GestureDetector(
          onTap: () {
            if (role == 'admin') {
              context.go('/admin/settings');
            } else if (role == 'patient') {
              context.go('/main/profile');
            } else {
              context.go('/$role/profile');
            }
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/avatar_placeholder.png')),
          ),
        ),
        // Language selector (reuse existing modal)
        // Language selector remains available through the existing modal flow.
      ],
    );
  }
}
