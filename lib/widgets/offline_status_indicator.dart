import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/local_model_status.dart';
import '../services/offline_ai_service.dart';
import '../theme/app_colors.dart';

/// Compact inline status chip displayed in the AI chat app bar.
///
/// Shows:
///   Online:       "AI • Online"         (green chip)
///   Offline:      "AI • Offline"        (deep green chip)
///   Downloading:  "Offline AI • 42%"    (green progress chip)
///   Loading:      "Offline AI • Starting" (green chip)
///   Error:        "Offline AI • Error"  (deep green chip)
class OfflineStatusIndicator extends StatelessWidget {
  const OfflineStatusIndicator({
    super.key,
    required this.isOnline,
    this.compact = true,
  });

  final bool isOnline;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalModelStatus>(
      stream: OfflineAiService.instance.statusStream,
      initialData: OfflineAiService.instance.modelStatus,
      builder: (context, snap) {
        final status = snap.data ?? LocalModelStatus.unavailable;
        return _buildChip(context, status);
      },
    );
  }

  Widget _buildChip(BuildContext context, LocalModelStatus status) {
    final (:label, :color, :icon) = _resolve(status);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: const BoxConstraints(minHeight: 36),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          if (status == LocalModelStatus.downloading) ..._progressPart(),
        ],
      ),
    );
  }

  List<Widget> _progressPart() {
    final pct =
        (OfflineAiService.instance.downloadProgress * 100).toStringAsFixed(0);
    return [
      const SizedBox(width: 4),
      Text(
        '$pct%',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.leafGreenDeep,
        ),
      ),
    ];
  }

  ({
    String label,
    Color color,
    IconData icon,
  }) _resolve(LocalModelStatus status) {
    if (isOnline) {
      return (
        label: 'AI \u2022 Online',
        color: AppColors.leafGreenPrimary,
        icon: LucideIcons.cloud,
      );
    }
    switch (status) {
      case LocalModelStatus.loaded:
      case LocalModelStatus.generating:
        return (
          label: 'AI \u2022 Offline',
          color: AppColors.leafGreenDeep,
          icon: LucideIcons.wifiOff,
        );
      case LocalModelStatus.lexiconOnly:
        return (
          label: 'AI \u2022 Offline (Knowledge)',
          color: AppColors.leafGreenDark,
          icon: LucideIcons.bookOpen,
        );
      case LocalModelStatus.downloading:
        return (
          label: 'Offline AI \u2022 Downloading',
          color: AppColors.leafGreenDeep,
          icon: LucideIcons.downloadCloud,
        );
      case LocalModelStatus.verifying:
        return (
          label: 'Offline AI \u2022 Verifying',
          color: AppColors.leafGreenDeep,
          icon: LucideIcons.refreshCw,
        );
      case LocalModelStatus.verified:
      case LocalModelStatus.compatible:
      case LocalModelStatus.loadable:
      case LocalModelStatus.ready:
        return (
          label: 'Offline AI \u2022 Ready',
          color: AppColors.leafGreenPrimary,
          icon: LucideIcons.checkCircle,
        );
      case LocalModelStatus.loading:
        return (
          label: 'Offline AI \u2022 Starting',
          color: AppColors.leafGreenDeep,
          icon: LucideIcons.hourglass,
        );
      case LocalModelStatus.error:
        return (
          label: 'Offline AI \u2022 Error',
          color: AppColors.leafGreenDeep,
          icon: LucideIcons.alertCircle,
        );
      default:
        return (
          label: 'AI \u2022 Offline',
          color: AppColors.textMedium,
          icon: LucideIcons.cloudOff,
        );
    }
  }
}
