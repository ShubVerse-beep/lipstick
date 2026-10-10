import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';

class FilterDropdown<T> extends StatefulWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hintText;

  const FilterDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
    super.key,
  });

  @override
  State<FilterDropdown<T>> createState() => _FilterDropdownState<T>();
}

class _FilterDropdownState<T> extends State<FilterDropdown<T>> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  void _handleFocusChange() => setState(() {});

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      constraints: const BoxConstraints(minHeight: 54),
      padding: const EdgeInsets.symmetric(horizontal: 14),
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
            : null,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          focusNode: _focusNode,
          value: widget.value,
          items: widget.items,
          onChanged: widget.onChanged,
          hint: widget.hintText != null
              ? Text(
                  widget.hintText!,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                )
              : null,
          icon: const Icon(
            LucideIcons.chevronDown,
            color: AppColors.leafGreenPrimary,
          ),
          dropdownColor: AppColors.primaryBg,
          borderRadius: BorderRadius.circular(14),
          isExpanded: true,
        ),
      ),
    );
  }
}
