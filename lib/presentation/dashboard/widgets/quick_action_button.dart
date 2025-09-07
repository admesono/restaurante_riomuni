import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool isEnabled;

  const QuickActionButton({
    super.key,
    required this.title,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.6,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: backgroundColor ?? colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (backgroundColor ?? colorScheme.primary)
                    .withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: icon.codePoint.toString(),
                color: iconColor ?? colorScheme.onPrimary,
                size: 8.w,
              ),
              SizedBox(height: 1.h),
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: textColor ?? colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
