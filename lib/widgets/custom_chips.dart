import 'package:flutter/material.dart';
import 'package:pedidos/theme/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomFilterChips extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;
  final double height;
  final EdgeInsetsGeometry itemPadding;
  final double borderRadius;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;

  const CustomFilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.height = 44,
    this.itemPadding = const EdgeInsets.symmetric(
      horizontal: AppTheme.spacingXl,
      vertical: AppTheme.spacingSm,
    ),
    this.borderRadius = AppTheme.borderRadiusFull,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppTheme.spacingMd),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return _FilterChip(
            label: filter,
            isSelected: isSelected,
            onTap: () => onFilterSelected(filter),
            padding: itemPadding,
            borderRadius: borderRadius,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            selectedTextColor: selectedTextColor,
            unselectedTextColor: unselectedTextColor,
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.padding,
    required this.borderRadius,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? AppTheme.primary)
              : (unselectedColor ?? AppTheme.surfaceContainerHigh),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppTheme.fontSizeLabel,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? (selectedTextColor ?? AppTheme.onPrimary)
                  : (unselectedTextColor ?? AppTheme.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }
}

// Versión más avanzada con soporte para íconos
class CustomFilterChipWithIcon extends StatelessWidget {
  final List<FilterChipData> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;
  final double height;
  final EdgeInsetsGeometry itemPadding;
  final double borderRadius;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final double iconSize;

  const CustomFilterChipWithIcon({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.height = 44,
    this.itemPadding = const EdgeInsets.symmetric(
      horizontal: AppTheme.spacingXl,
      vertical: AppTheme.spacingSm,
    ),
    this.borderRadius = AppTheme.borderRadiusFull,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppTheme.spacingMd),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter.value;

          return GestureDetector(
            onTap: () => onFilterSelected(filter.value),
            child: Container(
              padding: itemPadding,
              decoration: BoxDecoration(
                color: isSelected
                    ? (selectedColor ?? AppTheme.primary)
                    : (unselectedColor ?? AppTheme.surfaceContainerHigh),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filter.icon != null)
                    FaIcon(
                      filter.icon,
                      size: iconSize,
                      color: isSelected
                          ? (selectedTextColor ?? AppTheme.onPrimary)
                          : (unselectedTextColor ?? AppTheme.onSurfaceVariant),
                    ),
                  if (filter.icon != null) const SizedBox(width: AppTheme.spacingSm),
                  Text(
                    filter.label,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLabel,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? (selectedTextColor ?? AppTheme.onPrimary)
                          : (unselectedTextColor ?? AppTheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FilterChipData {
  final String label;
  final String value;
  final FaIconData? icon;

  const FilterChipData({
    required this.label,
    required this.value,
    this.icon,
  });
}