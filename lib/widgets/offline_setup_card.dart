import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../config/offline_ai_config.dart';
import '../models/local_model_status.dart';
import '../services/offline_ai_service.dart';
import '../theme/app_colors.dart';

/// Non-blocking status / progress card displaying the offline AI background lifecycle.
///
/// Automatically tracks:
/// - Checking: "Offline AI • Checking"
/// - Downloading: "Offline AI • Downloading XX%" with background progress bar
/// - Verifying: "Offline AI • Verifying"
/// - Pending: "Offline AI • Download pending" (e.g. waiting for Wi-Fi or connection)
/// - Error: "Offline AI • Retry pending"
/// - Ready: "Offline AI • Ready"
///
/// Does NOT require user taps to start downloading. Does NOT block user navigation.
class OfflineSetupCard extends StatefulWidget {
  const OfflineSetupCard({super.key, this.onDismiss});
  final VoidCallback? onDismiss;

  @override
  State<OfflineSetupCard> createState() => _OfflineSetupCardState();
}

class _OfflineSetupCardState extends State<OfflineSetupCard> {
  late StreamSubscription<LocalModelStatus> _sub;
  LocalModelStatus _status = OfflineAiService.instance.modelStatus;
  double _progress = OfflineAiService.instance.downloadProgress;

  @override
  void initState() {
    super.initState();
    _sub = OfflineAiService.instance.statusStream.listen((s) {
      if (!mounted) return;
      setState(() {
        _status = s;
        _progress = OfflineAiService.instance.downloadProgress;
      });
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 MB';
    final mb = bytes / (1024 * 1024);
    return '${mb.toStringAsFixed(0)} MB';
  }

  @override
  Widget build(BuildContext context) {
    // Hide card once fully ready or active in memory or in knowledge mode
    if (_status == LocalModelStatus.ready ||
        _status == LocalModelStatus.loaded ||
        _status == LocalModelStatus.generating ||
        _status == LocalModelStatus.lexiconOnly) {
      return const SizedBox.shrink();
    }

    const totalBytes = OfflineAiConfig.modelExpectedSizeBytes;
    final downloadedBytes = OfflineAiService.instance.downloadedBytes;
    final pct = (_progress * 100).toStringAsFixed(0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: AppColors.primaryBg,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _status == LocalModelStatus.downloading
                ? AppColors.leafGreenPrimary.withValues(alpha: 0.45)
                : AppColors.surfaceBorder,
          ),
          color: AppColors.primaryBg,
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _status == LocalModelStatus.error
                        ? AppColors.leafGreenAccent.withValues(alpha: 0.45)
                        : AppColors.leafGreenPale,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _status == LocalModelStatus.error
                        ? LucideIcons.refreshCw
                        : LucideIcons.wifiOff,
                    size: 20,
                    color: _status == LocalModelStatus.error
                        ? AppColors.leafGreenDeep
                        : AppColors.leafGreenPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _headerTitle(pct),
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtitleText(totalBytes, downloadedBytes, pct),
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.3,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onDismiss != null)
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 18),
                    onPressed: widget.onDismiss,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    color: AppColors.textMuted,
                  ),
              ],
            ),

            // Progress Indicator / Controls
            if (_status == LocalModelStatus.downloading) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progress > 0 ? _progress : null,
                  minHeight: 6,
                  backgroundColor: AppColors.leafGreenPale,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.leafGreenPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_formatBytes(downloadedBytes)} / ${_formatBytes(totalBytes)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: OfflineAiService.instance.cancelDownload,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text(
                      'Pause',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.leafGreenDeep,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (_status == LocalModelStatus.verifying ||
                _status == LocalModelStatus.checking) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  minHeight: 4,
                  backgroundColor: AppColors.leafGreenPale,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.leafGreenMedium,
                  ),
                ),
              ),
            ] else if (_status == LocalModelStatus.pending) ...[
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.leafGreenPale,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.wifi,
                      size: 16,
                      color: AppColors.leafGreenPrimary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        OfflineAiService.instance.statusReason ??
                            'Download pending — will begin automatically',
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.3,
                          color: AppColors.leafGreenDeep,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (_status == LocalModelStatus.error) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      OfflineAiService.instance.lastError ??
                          'Download paused. Retrying automatically...',
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        color: AppColors.leafGreenDeep,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: OfflineAiService.instance.startDownload,
                    icon: const Icon(LucideIcons.refreshCw, size: 18),
                    label:
                        const Text('Retry now', style: TextStyle(fontSize: 13)),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _headerTitle(String pct) {
    switch (_status) {
      case LocalModelStatus.checking:
        return 'Offline AI · Checking your device';
      case LocalModelStatus.downloading:
        return 'Offline AI · Downloading $pct%';
      case LocalModelStatus.verifying:
        return 'Offline AI · Verifying files';
      case LocalModelStatus.verified:
        return 'Offline AI • Verified';
      case LocalModelStatus.compatible:
        return 'Offline AI • Compatible';
      case LocalModelStatus.loadable:
        return 'Offline AI • Ready';
      case LocalModelStatus.ready:
        return 'Offline AI • Ready';
      case LocalModelStatus.loading:
        return 'Offline AI • Starting';
      case LocalModelStatus.loaded:
        return 'AI • Offline';
      case LocalModelStatus.generating:
        return 'Offline AI • Thinking';
      case LocalModelStatus.lexiconOnly:
        return 'Offline AI • Knowledge mode';
      case LocalModelStatus.pending:
        return 'Offline AI · Download waiting';
      case LocalModelStatus.error:
        return 'Offline AI · Retry pending';
      case LocalModelStatus.unavailable:
        return 'Offline AI';
    }
  }

  String _subtitleText(int totalBytes, int downloadedBytes, String pct) {
    switch (_status) {
      case LocalModelStatus.checking:
        return 'Checking your device in the background.';
      case LocalModelStatus.downloading:
        return 'Preparing your offline health assistant.';
      case LocalModelStatus.verifying:
        return 'Verifying the downloaded files.';
      case LocalModelStatus.pending:
        return OfflineAiService.instance.statusReason ??
            'Waiting for a connection to continue.';
      case LocalModelStatus.error:
        return OfflineAiService.instance.statusReason ??
            'We will retry automatically.';
      default:
        return 'Your offline health assistant is preparing in the background.';
    }
  }
}
