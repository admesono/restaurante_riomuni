import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TipCalculator extends StatelessWidget {
  final double orderTotal;
  final double tipAmount;
  final double tipPercentage;
  final Function(double, double) onTipChanged;

  const TipCalculator({
    super.key,
    required this.orderTotal,
    required this.tipAmount,
    required this.tipPercentage,
    required this.onTipChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final tipOptions = [15.0, 18.0, 20.0, 25.0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Propina',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),

        // Tip percentage buttons
        Row(
          children: [
            ...tipOptions.map((percentage) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: percentage != tipOptions.last ? 2.w : 0),
                    child: _buildTipButton(
                      context,
                      '${percentage.toInt()}%',
                      percentage,
                      tipPercentage == percentage,
                    ),
                  ),
                )),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildCustomTipButton(context),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Tip amount display
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Propina',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    tipPercentage > 0
                        ? '${tipPercentage.toStringAsFixed(0)}%'
                        : 'Sin propina',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              Text(
                '\$${tipAmount.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 1.h),

        // Total with tip
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total con Propina',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '\$${(orderTotal + tipAmount).toStringAsFixed(2)}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipButton(
      BuildContext context, String label, double percentage, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        final newTipAmount = orderTotal * (percentage / 100);
        onTipChanged(newTipAmount, percentage);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCustomTipButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCustom = !([15.0, 18.0, 20.0, 25.0].contains(tipPercentage)) &&
        tipPercentage > 0;

    return GestureDetector(
      onTap: () => _showCustomTipDialog(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isCustom ? colorScheme.primary : colorScheme.surface,
          border: Border.all(
            color: isCustom
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          isCustom ? '${tipPercentage.toStringAsFixed(0)}%' : 'Otro',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isCustom ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showCustomTipDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Propina Personalizada',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ingrese el porcentaje de propina',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Porcentaje (%)',
                suffixText: '%',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final percentage = double.tryParse(controller.text) ?? 0;
              if (percentage >= 0 && percentage <= 100) {
                final newTipAmount = orderTotal * (percentage / 100);
                onTipChanged(newTipAmount, percentage);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }
}
