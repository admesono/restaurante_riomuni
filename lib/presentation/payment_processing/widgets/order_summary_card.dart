import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class OrderSummaryCard extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;

  const OrderSummaryCard({
    super.key,
    required this.orderData,
    required this.isExpanded,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final orderItems =
        (orderData['items'] as List).cast<Map<String, dynamic>>();
    final subtotal = (orderData['subtotal'] as double);
    final tax = (orderData['tax'] as double);
    final total = (orderData['total'] as double);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with order info and expand button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedido #${orderData['orderNumber']}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Mesa ${orderData['tableNumber']} • ${orderItems.length} artículos',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    GestureDetector(
                      onTap: onToggleExpanded,
                      child: AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: CustomIconWidget(
                          iconName: 'keyboard_arrow_down',
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 6.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Expandable order details
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  SizedBox(height: 2.h),
                  Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
                  SizedBox(height: 1.h),

                  // Order items list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderItems.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final item = orderItems[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] as String,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (item['notes'] != null &&
                                    (item['notes'] as String).isNotEmpty)
                                  Text(
                                    item['notes'] as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                      fontStyle: FontStyle.italic,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '${item['quantity']}x',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '\$${(item['price'] as double).toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 2.h),
                  Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
                  SizedBox(height: 1.h),

                  // Order totals
                  Column(
                    children: [
                      _buildTotalRow(
                        context,
                        'Subtotal',
                        '\$${subtotal.toStringAsFixed(2)}',
                        false,
                      ),
                      SizedBox(height: 0.5.h),
                      _buildTotalRow(
                        context,
                        'Impuestos',
                        '\$${tax.toStringAsFixed(2)}',
                        false,
                      ),
                      SizedBox(height: 1.h),
                      _buildTotalRow(
                        context,
                        'Total',
                        '\$${total.toStringAsFixed(2)}',
                        true,
                      ),
                    ],
                  ),
                ],
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(
      BuildContext context, String label, String amount, bool isTotal) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          amount,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
