import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StaffPerformanceWidget extends StatelessWidget {
  final List<Map<String, dynamic>> staffData;
  final VoidCallback? onViewAll;

  const StaffPerformanceWidget({
    super.key,
    required this.staffData,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rendimiento del Personal',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    'Ver Todo',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),
          staffData.isEmpty ? _buildEmptyState() : _buildStaffList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 20.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'people',
              color: AppTheme.mediumGray,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No hay datos del personal',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Los datos del personal aparecerán cuando se registren ventas',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffList() {
    final sortedStaff = List<Map<String, dynamic>>.from(staffData);
    sortedStaff
        .sort((a, b) => (b['sales'] as double).compareTo(a['sales'] as double));

    final maxSales =
        sortedStaff.isNotEmpty ? sortedStaff.first['sales'] as double : 1.0;

    return Column(
      children: sortedStaff.asMap().entries.map((entry) {
        final index = entry.key;
        final staff = entry.value;
        return _buildStaffCard(staff, index + 1, maxSales);
      }).toList(),
    );
  }

  Widget _buildStaffCard(
      Map<String, dynamic> staff, int rank, double maxSales) {
    final sales = staff['sales'] as double;
    final orders = staff['orders'] as int;
    final progressValue = maxSales > 0 ? sales / maxSales : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(8),
        border: rank <= 3
            ? Border.all(
                color: _getRankColor(rank),
                width: 2,
              )
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Rank badge
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: _getRankColor(rank),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: rank <= 3
                      ? CustomIconWidget(
                          iconName: _getRankIcon(rank),
                          color: AppTheme.pureWhite,
                          size: 16,
                        )
                      : Text(
                          rank.toString(),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.pureWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 3.w),
              // Staff avatar
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.mediumGray.withValues(alpha: 0.2),
                ),
                child: staff['avatar'] != null
                    ? ClipOval(
                        child: CustomImageWidget(
                          imageUrl: staff['avatar'],
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.mediumGray,
                          size: 20,
                        ),
                      ),
              ),
              SizedBox(width: 3.w),
              // Staff details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff['name'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      staff['role'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              // Stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '€${sales.toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryRed,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '$orders órdenes',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.successGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Performance metrics
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Promedio/Orden',
                  '€${orders > 0 ? (sales / orders).toStringAsFixed(2) : '0.00'}',
                  AppTheme.warningOrange,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildMetricItem(
                  'Eficiencia',
                  '${(staff['efficiency'] as double).toStringAsFixed(1)}%',
                  AppTheme.successGreen,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rendimiento relativo',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                  Text(
                    '${(progressValue * 100).toStringAsFixed(1)}%',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressValue,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getRankColor(rank),
                          _getRankColor(rank).withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppTheme.primaryRed;
    }
  }

  String _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return 'emoji_events';
      case 2:
        return 'military_tech';
      case 3:
        return 'workspace_premium';
      default:
        return 'star';
    }
  }
}
