import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../services/connectivity_service.dart';
import '../theme/app_colors.dart';

class ConnectivityBadge extends StatelessWidget {
  const ConnectivityBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NetworkStatus>(
      stream: ConnectivityService.instance.statusStream,
      initialData: ConnectivityService.instance.currentStatus,
      builder: (context, snapshot) {
        final status = snapshot.data ?? NetworkStatus.online;

        switch (status) {
          case NetworkStatus.online:
            // Usually we hide it if online so it's not distracting,
            // but for GramHealth's explicit rural focus, maybe show it subtly.
            return const SizedBox.shrink();

          case NetworkStatus.weak:
            return Container(
              constraints: const BoxConstraints(minHeight: 44),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.leafGreenPale,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.leafGreenAccent),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.signalLow,
                    size: 18,
                    color: AppColors.leafGreenDeep,
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      'Weak connection · audio works best',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        color: AppColors.leafGreenDeep,
                      ),
                    ),
                  ),
                ],
              ),
            );

          case NetworkStatus.offline:
            return Container(
              constraints: const BoxConstraints(minHeight: 44),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.leafBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.cloudOff,
                    size: 18,
                    color: AppColors.leafGreenDark,
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      'Working offline · sync paused',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: AppColors.leafGreenDark,
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
