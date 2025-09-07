import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Role selector widget for staff position selection
class RoleSelectorWidget extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleChanged;
  final bool isEnabled;

  const RoleSelectorWidget({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    this.isEnabled = true,
  });

  static const List<Map<String, dynamic>> _roles = [
    {
      'value': 'manager',
      'label': 'Gerente',
      'icon': 'business_center',
      'description': 'Acceso completo al sistema',
    },
    {
      'value': 'cashier',
      'label': 'Cajero',
      'icon': 'point_of_sale',
      'description': 'Procesamiento de pagos y órdenes',
    },
    {
      'value': 'waiter',
      'label': 'Mesero',
      'icon': 'restaurant_menu',
      'description': 'Gestión de mesas y órdenes',
    },
    {
      'value': 'kitchen',
      'label': 'Cocina',
      'icon': 'restaurant',
      'description': 'Preparación de alimentos',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona tu rol',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Column(
            children: _roles.asMap().entries.map((entry) {
              final index = entry.key;
              final role = entry.value;
              final isSelected = selectedRole == role['value'];
              final isLast = index == _roles.length - 1;

              return InkWell(
                onTap: isEnabled
                    ? () => onRoleChanged(role['value'] as String)
                    : null,
                borderRadius: BorderRadius.vertical(
                  top: index == 0 ? Radius.circular(2.w) : Radius.zero,
                  bottom: isLast ? Radius.circular(2.w) : Radius.zero,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: !isLast
                        ? Border(
                            bottom: BorderSide(
                              color: colorScheme.outline.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Role Icon
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: CustomIconWidget(
                          iconName: role['icon'] as String,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 6.w,
                        ),
                      ),

                      SizedBox(width: 3.w),

                      // Role Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              role['label'] as String,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              role['description'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Selection Indicator
                      CustomIconWidget(
                        iconName: isSelected
                            ? 'radio_button_checked'
                            : 'radio_button_unchecked',
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.4),
                        size: 6.w,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
