import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../l10n/app_language.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/language_selector_modal.dart';
import '../../utils/auth_guard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = true;

  String _name = '';
  String _email = '';
  String _address = '';
  String _phoneNumber = '';
  String _age = '';
  String _gender = '';
  String _bloodGroup = '';
  String _pinCode = '';
  String _abhaId = '';

  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _pinCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _abhaCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _ageCtrl = TextEditingController();
    _pinCtrl = TextEditingController();
    _addressCtrl = TextEditingController();
    _abhaCtrl = TextEditingController();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AuthService.getUser();
    if (user != null && mounted) {
      setState(() {
        _name = user['name'] as String? ?? '';
        _email = user['email'] as String? ?? '';
        _phoneNumber = user['phone'] as String? ?? '';
        _address = user['address'] as String? ?? '';
        _age = user['age']?.toString() ?? '';
        _gender = user['gender'] as String? ?? '';
        _bloodGroup = user['bloodGroup'] as String? ?? '';
        _pinCode = user['pinCode'] as String? ?? '';
        _abhaId = user['abhaId'] as String? ?? '';
        _isLoading = false;
        // seed controllers
        _nameCtrl.text = _name;
        _phoneCtrl.text = _phoneNumber;
        _ageCtrl.text = _age;
        _pinCtrl.text = _pinCode;
        _addressCtrl.text = _address;
        _abhaCtrl.text = _abhaId;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _pinCtrl.dispose();
    _addressCtrl.dispose();
    _abhaCtrl.dispose();
    super.dispose();
  }

  void _handleSave() {
    setState(() {
      _name = _nameCtrl.text;
      _phoneNumber = _phoneCtrl.text;
      _age = _ageCtrl.text;
      _pinCode = _pinCtrl.text;
      _address = _addressCtrl.text;
      _abhaId = _abhaCtrl.text;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.secondaryBg,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.secondaryBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 120),
        child: Column(
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primaryAccent,
                        child: Text(
                          _name.isNotEmpty ? _name[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryBg,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.textDark,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(LucideIcons.camera,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _name,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _address,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark.withValues(alpha: 0.6)),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _isEditing
                        ? _handleSave
                        : () => setState(() => _isEditing = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: _isEditing
                            ? AppColors.primaryAccent
                            : AppColors.textDark,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                              _isEditing
                                  ? LucideIcons.check
                                  : LucideIcons.pencil,
                              size: 16,
                              color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            _isEditing
                                ? context.tr('save_changes')
                                : context.tr('edit_profile'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Profile info card
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildInfoRow(LucideIcons.mail, 'Email',
                      _email.isNotEmpty ? _email : '—'),
                  const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.surfaceBorder),
                  _buildInfoRow(LucideIcons.phone, context.tr('phone_number'),
                      _phoneNumber.isNotEmpty ? _phoneNumber : '—'),
                  const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.surfaceBorder),
                  _buildInfoRow(
                      LucideIcons.calendarDays, context.tr('age_gender'), () {
                    final parts = [
                      if (_age.isNotEmpty) '$_age Yrs',
                      if (_gender.isNotEmpty) _gender,
                    ];
                    return parts.isEmpty ? '—' : parts.join(' / ');
                  }()),
                  const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.surfaceBorder),
                  _buildInfoRow(LucideIcons.mapPin, context.tr('pin_code'),
                      _pinCode.isNotEmpty ? _pinCode : '—'),
                  const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.surfaceBorder),
                  _buildInfoRow(LucideIcons.droplets, context.tr('blood_group'),
                      _bloodGroup.isNotEmpty ? _bloodGroup : '—',
                      iconColor: AppColors.error),
                  const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.surfaceBorder),
                  _buildInfoRow(LucideIcons.shieldCheck, "ABHA ID",
                      _abhaId.isNotEmpty ? _abhaId : '—',
                      iconColor: AppColors.leafGreenPrimary),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Edit Form if active
            if (_isEditing) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr('edit_profile'),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    const SizedBox(height: 16),
                    _buildInputGroup(
                        context.tr('username'), _nameCtrl, LucideIcons.user),
                    _buildInputGroup(context.tr('phone_number'), _phoneCtrl,
                        LucideIcons.phone,
                        keyboardType: TextInputType.phone),
                    Row(
                      children: [
                        Expanded(
                            child: _buildInputGroup(
                                context.tr('age_gender'), _ageCtrl, null,
                                keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildInputGroup(
                                context.tr('pin_code'), _pinCtrl, null,
                                keyboardType: TextInputType.number)),
                      ],
                    ),
                    _buildInputGroup(context.tr('address_village'),
                        _addressCtrl, LucideIcons.map),
                    _buildInputGroup("ABHA ID (Optional)", _abhaCtrl,
                        LucideIcons.shieldCheck),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _handleSave,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(context.tr('save_changes'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: AppColors.textDark)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // App settings
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.tr('app_settings'),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark),
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildSettingRow(
                    LucideIcons.languages,
                    '${context.tr('language')} - ${context.currentLanguage.nativeName} (${context.currentLanguage.englishName})',
                    () => showLanguageSelector(context),
                  ),
                  const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.surfaceBorder),
                  _buildSettingRow(
                      LucideIcons.bell,
                      context.tr('notifications'),
                      () => context.push('/notifications')),
                  const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.surfaceBorder),
                  _buildSettingRow(
                    LucideIcons.logOut,
                    context.tr('logout'),
                    () async {
                      AuthGuard.onLogout();
                      await AuthService.logout();
                      if (context.mounted) context.go('/onboarding');
                    },
                    textColor: AppColors.error,
                    iconColor: AppColors.error,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.secondaryBg,
              shape: BoxShape.circle,
            ),
            child:
                Icon(icon, size: 18, color: iconColor ?? AppColors.textMuted),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputGroup(
      String label, TextEditingController ctrl, IconData? icon,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMedium)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.secondaryBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    keyboardType: keyboardType,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textDark),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(IconData icon, String title, VoidCallback onTap,
      {Color? textColor, Color? iconColor}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor ?? AppColors.textDark),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppColors.textDark,
                ),
              ),
            ),
            const Icon(LucideIcons.chevronRight,
                size: 20, color: AppColors.disabled),
          ],
        ),
      ),
    );
  }
}
