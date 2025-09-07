import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimePeriodSelectorWidget extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;
  final VoidCallback? onCustomDateTap;

  const TimePeriodSelectorWidget({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.onCustomDateTap,
  });

  static const List<Map<String, String>> _periods = [
    {'key': 'today', 'label': 'Hoy'},
    {'key': 'week', 'label': 'Semana'},
    {'key': 'month', 'label': 'Mes'},
    {'key': 'custom', 'label': 'Personalizado'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _periods.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final period = _periods[index];
          final isSelected = selectedPeriod == period['key'];

          return _buildPeriodChip(
            period['key']!,
            period['label']!,
            isSelected,
          );
        },
      ),
    );
  }

  Widget _buildPeriodChip(String key, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (key == 'custom' && onCustomDateTap != null) {
          onCustomDateTap!();
        } else {
          onPeriodChanged(key);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryRed
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryRed : AppTheme.borderColor,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryRed.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (key == 'custom')
              Padding(
                padding: EdgeInsets.only(right: 1.w),
                child: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: isSelected ? AppTheme.pureWhite : AppTheme.mediumGray,
                  size: 16,
                ),
              ),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? AppTheme.pureWhite : AppTheme.neutralBlack,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
