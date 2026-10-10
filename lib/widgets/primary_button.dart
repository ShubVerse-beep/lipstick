import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// PrimaryButton matches the React Native PrimaryButton component
/// with spring-like scale animation on press.
class PrimaryButton extends StatefulWidget {
  final String title;
  final VoidCallback onPress;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final bool enabled;
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPress,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.enabled = true,
    this.loading = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInteractive = widget.enabled && !widget.loading;
    final radius = BorderRadius.circular(widget.borderRadius ?? 16);
    final activeColor = widget.backgroundColor ?? AppColors.primaryAccent;
    final fillColor =
        widget.enabled ? activeColor : AppColors.disabledBackground;
    final foregroundColor =
        widget.enabled ? widget.textColor ?? Colors.white : AppColors.textMuted;

    return Semantics(
      button: true,
      enabled: isInteractive,
      label: widget.title,
      child: FocusableActionDetector(
        enabled: isInteractive,
        onFocusChange: (focused) => setState(() => _hasFocus = focused),
        mouseCursor:
            isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: ScaleTransition(
          scale: _scale,
          child: SizedBox(
            width: widget.width,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 52),
              child: Material(
                color: fillColor,
                borderRadius: radius,
                elevation: isInteractive ? 1 : 0,
                shadowColor: activeColor.withValues(alpha: 0.25),
                child: InkWell(
                  onTap: isInteractive ? widget.onPress : null,
                  onTapDown: isInteractive ? (_) => _ctrl.forward() : null,
                  onTapUp: isInteractive ? (_) => _ctrl.reverse() : null,
                  onTapCancel: isInteractive ? () => _ctrl.reverse() : null,
                  borderRadius: radius,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: widget.padding ??
                        const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      border: Border.all(
                        color: _hasFocus
                            ? AppColors.focusRing
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: widget.loading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                foregroundColor,
                              ),
                            ),
                          )
                        : Text(
                            widget.title.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: foregroundColor),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
