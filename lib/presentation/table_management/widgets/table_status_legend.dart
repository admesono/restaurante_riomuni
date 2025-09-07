import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class TableStatusLegend extends StatelessWidget {
  final Map<String, int> statusCounts;

  const TableStatusLegend({
    super.key,
    required this.statusCounts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> statusItems = [
      {
        'status': 'available',
        'label': 'Disponible',
        'color': AppTheme.successGreen,
        'icon': 'check_circle',
        'count': statusCounts['available'] ?? 0,
      },
      {
        'status': 'occupied',
        'label': 'Ocupada',
        'color': AppTheme.errorRed,
        'icon': 'people',
        'count': statusCounts['occupied'] ?? 0,
      },
      {
        'status': 'cleaning',
        'label': 'Limpieza',
        'color': AppTheme.warningOrange,
        'icon': 'cleaning_services',
        'count': statusCounts['cleaning'] ?? 0,
      },
      {
        'status': 'reserved',
        'label': 'Reservada',
        'color': Colors.blue,
        'icon': 'schedule',
        'count': statusCounts['reserved'] ?? 0,
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado de las Mesas',
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          Wrap(
            spacing: 4.w,
            runSpacing: 2.h,
            children: statusItems
                .map((item) => _buildStatusItem(
                      context,
                      item['status'] as String,
                      item['label'] as String,
                      item['color'] as Color,
                      item['icon'] as String,
                      item['count'] as int,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String status,
    String label,
    Color color,
    String iconName,
    int count,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(minWidth: 20.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),
          SizedBox(width: 2.w),
          CustomIconWidget(
            iconName: iconName,
            size: 16,
            color: color,
          ),
          SizedBox(width: 2.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.roboto(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '$count mesa${count != 1 ? 's' : ''}',
                  style: GoogleFonts.roboto(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
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