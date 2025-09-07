import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class AmountInputSection extends StatelessWidget {
  final double totalAmount;
  final double paidAmount;
  final Function(double) onAmountChanged;
  final String paymentMethod;

  const AmountInputSection({
    super.key,
    required this.totalAmount,
    required this.paidAmount,
    required this.onAmountChanged,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final TextEditingController controller = TextEditingController(
      text: paidAmount > 0 ? paidAmount.toStringAsFixed(2) : '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monto a Pagar',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),

        // Amount display for non-cash payments
        if (paymentMethod != 'cash') ...[
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
            child: Column(
              children: [
                Text(
                  'Total a Cobrar',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],

        // Cash payment input
        if (paymentMethod == 'cash') ...[
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              labelText: 'Monto Recibido',
              prefixText: '\$ ',
              prefixStyle: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(4.w),
            ),
            onChanged: (value) {
              final amount = double.tryParse(value) ?? 0;
              onAmountChanged(amount);
            },
            autofocus: true,
          ),

          SizedBox(height: 2.h),

          // Quick amount buttons for cash
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _getQuickAmounts(totalAmount).map((amount) {
              return GestureDetector(
                onTap: () {
                  controller.text = amount.toStringAsFixed(2);
                  onAmountChanged(amount);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '\$${amount.toStringAsFixed(0)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 2.h),

          // Change calculation
          if (paidAmount > 0) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: paidAmount >= totalAmount
                    ? colorScheme.secondary.withValues(alpha: 0.1)
                    : colorScheme.error.withValues(alpha: 0.1),
                border: Border.all(
                  color: paidAmount >= totalAmount
                      ? colorScheme.secondary.withValues(alpha: 0.3)
                      : colorScheme.error.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        '\$${totalAmount.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recibido:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        '\$${paidAmount.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        paidAmount >= totalAmount ? 'Cambio:' : 'Faltante:',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: paidAmount >= totalAmount
                              ? colorScheme.secondary
                              : colorScheme.error,
                        ),
                      ),
                      Text(
                        '\$${(paidAmount - totalAmount).abs().toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: paidAmount >= totalAmount
                              ? colorScheme.secondary
                              : colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  List<double> _getQuickAmounts(double total) {
    final baseAmounts = [10, 20, 50, 100, 200, 500];
    final List<double> amounts = [];

    // Add exact amount
    amounts.add(total);

    // Add rounded up amounts
    final roundedUp = (total / 10).ceil() * 10;
    if (roundedUp > total) amounts.add(roundedUp.toDouble());

    // Add common denominations that are larger than total
    for (final amount in baseAmounts) {
      if (amount > total && !amounts.contains(amount.toDouble())) {
        amounts.add(amount.toDouble());
      }
    }

    // Sort and take first 6
    amounts.sort();
    return amounts.take(6).toList();
  }
}
