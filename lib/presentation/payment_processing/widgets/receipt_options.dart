import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ReceiptOptions extends StatelessWidget {
  final List<String> selectedOptions;
  final Function(List<String>) onOptionsChanged;
  final String customerEmail;
  final String customerPhone;
  final Function(String) onEmailChanged;
  final Function(String) onPhoneChanged;

  const ReceiptOptions({
    super.key,
    required this.selectedOptions,
    required this.onOptionsChanged,
    required this.customerEmail,
    required this.customerPhone,
    required this.onEmailChanged,
    required this.onPhoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final receiptOptions = [
      {
        'id': 'print',
        'name': 'Imprimir',
        'icon': 'print',
        'description': 'Recibo físico'
      },
      {
        'id': 'email',
        'name': 'Email',
        'icon': 'email',
        'description': 'Enviar por correo'
      },
      {
        'id': 'sms',
        'name': 'SMS',
        'icon': 'sms',
        'description': 'Enviar por mensaje'
      },
      {
        'id': 'skip',
        'name': 'Omitir',
        'icon': 'close',
        'description': 'Sin recibo'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opciones de Recibo',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),

        // Receipt options grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 2.5,
          ),
          itemCount: receiptOptions.length,
          itemBuilder: (context, index) {
            final option = receiptOptions[index];
            final isSelected = selectedOptions.contains(option['id']);

            return GestureDetector(
              onTap: () => _toggleOption(option['id'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: option['icon'] as String,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            option['name'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            option['description'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Email input field
        if (selectedOptions.contains('email')) ...[
          SizedBox(height: 2.h),
          TextFormField(
            initialValue: customerEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Correo Electrónico',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: colorScheme.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            onChanged: onEmailChanged,
          ),
        ],

        // Phone input field
        if (selectedOptions.contains('sms')) ...[
          SizedBox(height: 2.h),
          TextFormField(
            initialValue: customerPhone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Número de Teléfono',
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: colorScheme.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
            onChanged: onPhoneChanged,
          ),
        ],

        // Print status indicator
        if (selectedOptions.contains('print')) ...[
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.1),
              border: Border.all(
                color: colorScheme.secondary.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: colorScheme.secondary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Impresora Conectada',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.secondary,
                        ),
                      ),
                      Text(
                        'Thermal Printer - Bluetooth',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _toggleOption(String optionId) {
    List<String> newOptions = List.from(selectedOptions);

    // Handle skip option - exclusive selection
    if (optionId == 'skip') {
      if (newOptions.contains('skip')) {
        newOptions.remove('skip');
      } else {
        newOptions = ['skip'];
      }
    } else {
      // Remove skip if selecting other options
      newOptions.remove('skip');

      if (newOptions.contains(optionId)) {
        newOptions.remove(optionId);
      } else {
        newOptions.add(optionId);
      }
    }

    onOptionsChanged(newOptions);
  }
}