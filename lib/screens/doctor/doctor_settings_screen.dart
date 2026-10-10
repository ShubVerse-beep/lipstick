import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../l10n/app_language.dart';
import '../../widgets/dashboard_layout.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/language_selector_modal.dart';
import '../../theme/app_colors.dart';

class DoctorSettingsScreen extends StatelessWidget {
  const DoctorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: context.tr('settings'),
      child: ListView(
        children: [
          Text(
            context.tr('settings'),
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark),
          ),
          const SizedBox(height: 16),
          GlassCard(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(LucideIcons.languages,
                      color: AppColors.leafGreenPrimary),
                  title: Text(context.tr('select_language')),
                  subtitle: Text(context.currentLanguage.nativeName),
                  trailing: const Icon(LucideIcons.chevronRight),
                  onTap: () => showLanguageSelector(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(LucideIcons.bell,
                      color: AppColors.leafGreenPrimary),
                  title: const Text('Notifications'),
                  trailing: Switch(
                    value: true,
                    activeThumbColor: AppColors.leafGreenPrimary,
                    activeTrackColor: AppColors.leafGreenPale,
                    inactiveThumbColor: AppColors.textMuted,
                    inactiveTrackColor: AppColors.secondaryBg,
                    onChanged: (v) {},
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(LucideIcons.shieldCheck,
                      color: AppColors.leafGreenPrimary),
                  title: const Text('Privacy & Security'),
                  trailing: const Icon(LucideIcons.chevronRight),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(LucideIcons.helpCircle,
                      color: AppColors.leafGreenPrimary),
                  title: const Text('Help & Support'),
                  trailing: const Icon(LucideIcons.chevronRight),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
