import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class TableWidget extends StatelessWidget {
  final Map<String, dynamic> table;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TableWidget({
    super.key,
    required this.table,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String status = table['status'] as String? ?? 'available';
    final int tableNumber = table['number'] as int? ?? 0;
    final String shape = table['shape'] as String? ?? 'circular';
    final int capacity = table['capacity'] as int? ?? 4;
    final String? customerName = table['customerName'] as String?;
    final bool hasReservation = table['hasReservation'] as bool? ?? false;
    final String? reservationTime = table['reservationTime'] as String?;

    return Positioned(
      left: (table['x'] as double? ?? 0.0) * 80.w / 100,
      top: (table['y'] as double? ?? 0.0) * 60.h / 100,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          width: shape == 'rectangular' ? 15.w : 12.w,
          height: shape == 'rectangular' ? 8.h : 12.w,
          decoration: BoxDecoration(
            color: _getTableColor(status),
            border: Border.all(
              color: _getTableBorderColor(status),
              width: 2,
            ),
            borderRadius: shape == 'rectangular'
                ? BorderRadius.circular(8)
                : BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tableNumber.toString(),
                style: GoogleFonts.roboto(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: _getTextColor(status),
                ),
              ),
              if (capacity > 0) ...[
                SizedBox(height: 0.5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      size: 8.sp,
                      color: _getTextColor(status).withValues(alpha: 0.7),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      capacity.toString(),
                      style: GoogleFonts.roboto(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w400,
                        color: _getTextColor(status).withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
              if (hasReservation && reservationTime != null) ...[
                SizedBox(height: 0.5.h),
                CustomIconWidget(
                  iconName: 'schedule',
                  size: 8.sp,
                  color: _getTextColor(status),
                ),
              ],
              if (customerName != null && status == 'occupied') ...[
                SizedBox(height: 0.5.h),
                Text(
                  customerName.split(' ').first,
                  style: GoogleFonts.roboto(
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w400,
                    color: _getTextColor(status).withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getTableColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return AppTheme.successGreen.withValues(alpha: 0.1);
      case 'occupied':
        return AppTheme.errorRed.withValues(alpha: 0.1);
      case 'cleaning':
        return AppTheme.warningOrange.withValues(alpha: 0.1);
      case 'reserved':
        return Colors.blue.withValues(alpha: 0.1);
      default:
        return AppTheme.lightGray;
    }
  }

  Color _getTableBorderColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return AppTheme.successGreen;
      case 'occupied':
        return AppTheme.errorRed;
      case 'cleaning':
        return AppTheme.warningOrange;
      case 'reserved':
        return Colors.blue;
      default:
        return AppTheme.mediumGray;
    }
  }

  Color _getTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return AppTheme.successGreen;
      case 'occupied':
        return AppTheme.errorRed;
      case 'cleaning':
        return AppTheme.warningOrange;
      case 'reserved':
        return Colors.blue;
      default:
        return AppTheme.neutralBlack;
    }
  }
}