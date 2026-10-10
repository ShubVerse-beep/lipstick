import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../data/doctors_data.dart';
import '../../l10n/app_language.dart';
import '../../theme/app_colors.dart';

class VideoCallScreen extends StatefulWidget {
  final String doctorId;
  const VideoCallScreen({super.key, required this.doctorId});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;
  int _callDuration = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() => _callDuration++);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int sec) {
    final mins = sec ~/ 60;
    final s = sec % 60;
    return '${mins.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final doctor = kDoctors.firstWhere(
      (d) => d.id == widget.doctorId,
      orElse: () => kDoctors.first,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Remote Video Image
          Positioned.fill(
            child: Image.network(
              doctor.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFF222222)),
            ),
          ),

          // Blur if video off
          if (_isVideoOff)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),

          // Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.25),
            ),
          ),

          // Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                color: Colors.black54,
                                blurRadius: 10,
                                offset: Offset(-1, 1)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${context.tr('live_consultation')} • ${_formatTime(_callDuration)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: const Icon(LucideIcons.chevronDown,
                          color: Colors.white, size: 28),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Local Preview (Patient)
          Positioned(
            top: 140,
            right: 24,
            width: 120,
            height: 180,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3), width: 2),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 10,
                      offset: Offset(0, 4)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: _isVideoOff
                    ? Container(
                        color: const Color(0xFF1A1A1A),
                        child: const Icon(LucideIcons.videoOff,
                            color: Colors.white, size: 28),
                      )
                    : Image.network(
                        'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=200',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),

          // HD Badge
          Positioned(
            top: 150,
            right: 34,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.signal, size: 12, color: AppColors.success),
                  SizedBox(width: 4),
                  Text('HD',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),

          // Controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mute
                GestureDetector(
                  onTap: () => setState(() => _isMuted = !_isMuted),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isMuted
                              ? AppColors.error
                              : Colors.white.withValues(alpha: 0.2),
                        ),
                        child: Icon(
                            _isMuted ? LucideIcons.micOff : LucideIcons.mic,
                            color: Colors.white,
                            size: 24),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isMuted ? context.tr('unmute') : context.tr('mute'),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                // End Call
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.error,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.error,
                            blurRadius: 15,
                            offset: Offset(0, 8)),
                      ],
                    ),
                    child: const Icon(LucideIcons.phoneOff,
                        color: Colors.white, size: 34),
                  ),
                ),
                const SizedBox(width: 24),

                // Video toggle
                GestureDetector(
                  onTap: () => setState(() => _isVideoOff = !_isVideoOff),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isVideoOff
                              ? AppColors.error
                              : Colors.white.withValues(alpha: 0.2),
                        ),
                        child: Icon(
                            _isVideoOff
                                ? LucideIcons.videoOff
                                : LucideIcons.video,
                            color: Colors.white,
                            size: 24),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isVideoOff
                            ? context.tr('start_video')
                            : context.tr('stop_video'),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
