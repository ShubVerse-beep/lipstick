import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hintText;

  const CustomSearchBar({
    this.controller,
    this.onChanged,
    this.onClear,
    this.hintText = 'Search...',
    super.key,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChange);
    widget.controller?.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(covariant CustomSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleTextChange);
      widget.controller?.addListener(_handleTextChange);
    }
  }

  void _handleFocusChange() => setState(() {});

  void _handleTextChange() => setState(() {});

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTextChange);
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller?.text.isNotEmpty ?? false;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      constraints: const BoxConstraints(minHeight: 54),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _focusNode.hasFocus
              ? AppColors.primaryAccent
              : AppColors.surfaceBorder,
          width: _focusNode.hasFocus ? 2 : 1,
        ),
        boxShadow: _focusNode.hasFocus
            ? const [
                BoxShadow(
                  color: AppColors.focusRing,
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.search,
              color: AppColors.leafGreenPrimary, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              cursorColor: AppColors.primaryAccent,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: const TextStyle(fontSize: 15, color: AppColors.textDark),
            ),
          ),
          if (hasText && widget.controller != null)
            IconButton(
              tooltip: 'Clear search',
              onPressed: widget.onClear ?? widget.controller!.clear,
              icon: const Icon(
                LucideIcons.x,
                color: AppColors.textMuted,
                size: 19,
              ),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }
}
