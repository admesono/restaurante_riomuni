import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TopSellingItemsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> topItems;
  final VoidCallback? onViewAll;

  const TopSellingItemsWidget({
    super.key,
    required this.topItems,
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
                'Productos Más Vendidos',
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
          topItems.isEmpty ? _buildEmptyState() : _buildItemsList(),
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
              iconName: 'restaurant_menu',
              color: AppTheme.mediumGray,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No hay productos vendidos',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Los productos aparecerán cuando se registren ventas',
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

  Widget _buildItemsList() {
    final maxQuantity = topItems.isNotEmpty
        ? topItems.fold<int>(
            0,
            (max, item) => (item['quantity'] as int) > max
                ? (item['quantity'] as int)
                : max)
        : 1;

    return Column(
      children: topItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _buildItemCard(item, index + 1, maxQuantity);
      }).toList(),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, int rank, int maxQuantity) {
    final quantity = item['quantity'] as int;
    final revenue = item['revenue'] as double;
    final progressValue = maxQuantity > 0 ? quantity / maxQuantity : 0.0;

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
                  child: Text(
                    rank.toString(),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.pureWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              // Item image
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme.mediumGray.withValues(alpha: 0.2),
                ),
                child: item['image'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: item['image'],
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: CustomIconWidget(
                          iconName: 'restaurant',
                          color: AppTheme.mediumGray,
                          size: 20,
                        ),
                      ),
              ),
              SizedBox(width: 3.w),
              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      item['category'] as String,
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
                    '${quantity} vendidos',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryRed,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '€${revenue.toStringAsFixed(2)}',
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
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Contribución a ventas',
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
                      color: _getRankColor(rank),
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
}
