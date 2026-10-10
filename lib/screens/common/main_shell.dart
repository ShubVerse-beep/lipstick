import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_language.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _tabs = const [
    '/main/home',
    '/main/doctors',
    '/main/symptoms',
    '/main/records',
    '/main/profile',
  ];

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    context.go(_tabs[index]);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageController.instance.currentLanguage,
      builder: (context, lang, _) {
        return Scaffold(
          body: widget.child,
          extendBody: true,
          bottomNavigationBar: Container(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 18,
                  offset: Offset(0, -6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onTap,
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppColors.primaryBg,
                selectedItemColor: AppColors.primaryAccent,
                unselectedItemColor: AppColors.textMuted,
                selectedLabelStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(AppIcons.home),
                    activeIcon: const Icon(AppIcons.home),
                    label: context.tr('tab_home'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(AppIcons.doctors),
                    activeIcon: const Icon(AppIcons.doctors),
                    label: context.tr('tab_doctors'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(AppIcons.symptoms),
                    label: context.tr('tab_symptoms'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(AppIcons.records),
                    activeIcon: const Icon(AppIcons.records),
                    label: context.tr('tab_records'),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(AppIcons.profile),
                    activeIcon: const Icon(AppIcons.profile),
                    label: context.tr('tab_profile'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
