import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentBreakdownWidget extends StatefulWidget {
  final List<Map<String, dynamic>> paymentData;
  final VoidCallback? onChartTap;

  const PaymentBreakdownWidget({
    super.key,
    required this.paymentData,
    this.onChartTap,
  });

  @override
  State<PaymentBreakdownWidget> createState() => _PaymentBreakdownWidgetState();
}

class _PaymentBreakdownWidgetState extends State<PaymentBreakdownWidget> {
  int touchedIndex = -1;

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
                'Métodos de Pago',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: widget.onChartTap,
                child: CustomIconWidget(
                  iconName: 'fullscreen',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          widget.paymentData.isEmpty ? _buildEmptyState() : _buildChart(),
          SizedBox(height: 3.h),
          if (widget.paymentData.isNotEmpty) _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 25.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'payment',
              color: AppTheme.mediumGray,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No hay datos de pagos',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Los métodos de pago aparecerán cuando se procesen transacciones',
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

  Widget _buildChart() {
    return Container(
      height: 25.h,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 8.w,
                sections: _buildPieChartSections(),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            flex: 2,
            child: _buildPaymentStats(),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final totalAmount = widget.paymentData.fold<double>(
      0.0,
      (sum, item) => sum + (item['amount'] as double),
    );

    return widget.paymentData.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 14.sp : 12.sp;
      final radius = isTouched ? 12.w : 10.w;
      final amount = item['amount'] as double;
      final percentage = totalAmount > 0 ? (amount / totalAmount) * 100 : 0.0;

      return PieChartSectionData(
        color: _getPaymentMethodColor(item['method'] as String),
        value: amount,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: AppTheme.pureWhite,
        ),
        badgeWidget: isTouched
            ? Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: AppTheme.pureWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowColor,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: _getPaymentMethodIcon(item['method'] as String),
                  color: _getPaymentMethodColor(item['method'] as String),
                  size: 16,
                ),
              )
            : null,
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();
  }

  Widget _buildPaymentStats() {
    final totalAmount = widget.paymentData.fold<double>(
      0.0,
      (sum, item) => sum + (item['amount'] as double),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Total',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.mediumGray,
          ),
        ),
        Text(
          '€${totalAmount.toStringAsFixed(2)}',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryRed,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Transacciones',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.mediumGray,
          ),
        ),
        Text(
          widget.paymentData
              .fold<int>(
                0,
                (sum, item) => sum + (item['transactions'] as int),
              )
              .toString(),
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.successGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Column(
      children: widget.paymentData.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final method = item['method'] as String;
        final amount = item['amount'] as double;
        final transactions = item['transactions'] as int;
        final isHighlighted = index == touchedIndex;

        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: isHighlighted
                ? _getPaymentMethodColor(method).withValues(alpha: 0.1)
                : AppTheme.lightGray,
            borderRadius: BorderRadius.circular(8),
            border: isHighlighted
                ? Border.all(
                    color: _getPaymentMethodColor(method),
                    width: 2,
                  )
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: _getPaymentMethodColor(method),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: _getPaymentMethodIcon(method),
                    color: AppTheme.pureWhite,
                    size: 16,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getPaymentMethodName(method),
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$transactions transacciones',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '€${amount.toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getPaymentMethodColor(method),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getPaymentMethodColor(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
      case 'efectivo':
        return AppTheme.successGreen;
      case 'card':
      case 'tarjeta':
        return AppTheme.primaryRed;
      case 'digital':
      case 'digital_wallet':
        return AppTheme.warningOrange;
      default:
        return AppTheme.mediumGray;
    }
  }

  String _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
      case 'efectivo':
        return 'payments';
      case 'card':
      case 'tarjeta':
        return 'credit_card';
      case 'digital':
      case 'digital_wallet':
        return 'qr_code';
      default:
        return 'payment';
    }
  }

  String _getPaymentMethodName(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return 'Efectivo';
      case 'card':
        return 'Tarjeta';
      case 'digital':
      case 'digital_wallet':
        return 'Pago Digital';
      default:
        return method;
    }
  }
}
