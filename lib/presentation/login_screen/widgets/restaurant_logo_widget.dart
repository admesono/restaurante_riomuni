import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Restaurant logo widget with brand recognition
class RestaurantLogoWidget extends StatelessWidget {
  final bool isCompact;

  const RestaurantLogoWidget({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Container
        Container(
          width: isCompact ? 20.w : 25.w,
          height: isCompact ? 20.w : 25.w,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Pattern
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.w),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      AppTheme.secondaryRed,
                    ],
                  ),
                ),
              ),

              // Restaurant Icon
              CustomIconWidget(
                iconName: 'restaurant',
                color: colorScheme.onPrimary,
                size: isCompact ? 8.w : 10.w,
              ),

              // Decorative Elements
              Positioned(
                top: 2.w,
                right: 2.w,
                child: Container(
                  width: 1.5.w,
                  height: 1.5.w,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 2.w,
                left: 2.w,
                child: Container(
                  width: 1.w,
                  height: 1.w,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (!isCompact) ...[
          SizedBox(height: 3.h),

          // Restaurant Name
          Text(
            'RIOMUNI',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              letterSpacing: 2,
            ),
          ),

          SizedBox(height: 1.h),

          // Subtitle
          Text(
            'Sistema de Gestión',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              letterSpacing: 1,
            ),
          ),

          SizedBox(height: 0.5.h),

          // Version or tagline
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(1.w),
            ),
            child: Text(
              'Restaurante',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
