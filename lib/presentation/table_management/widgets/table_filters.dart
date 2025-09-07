import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TableFilters extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final Map<String, int> statusCounts;

  const TableFilters({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.statusCounts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> filters = [
      {
        'key': 'all',
        'label': 'Todas',
        'icon': 'table_restaurant',
        'count': statusCounts.values.fold(0, (sum, count) => sum + count),
      },
      {
        'key': 'available',
        'label': 'Disponibles',
        'icon': 'check_circle',
        'count': statusCounts['available'] ?? 0,
      },
      {
        'key': 'occupied',
        'label': 'Ocupadas',
        'icon': 'people',
        'count': statusCounts['occupied'] ?? 0,
      },
      {
        'key': 'reserved',
        'label': 'Reservadas',
        'icon': 'schedule',
        'count': statusCounts['reserved'] ?? 0,
      },
    ];

    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 3.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['key'];
          final count = filter['count'] as int;

          return GestureDetector(
            onTap: () => onFilterChanged(filter['key'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: filter['icon'] as String,
                    size: 16,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    filter['label'] as String,
                    style: GoogleFonts.roboto(
                      fontSize: 11.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  if (count > 0) ...[
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: GoogleFonts.roboto(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}