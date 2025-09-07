import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RevenueChartWidget extends StatefulWidget {
  final String selectedPeriod;
  final List<Map<String, dynamic>> revenueData;
  final VoidCallback? onChartTap;

  const RevenueChartWidget({
    super.key,
    required this.selectedPeriod,
    required this.revenueData,
    this.onChartTap,
  });

  @override
  State<RevenueChartWidget> createState() => _RevenueChartWidgetState();
}

class _RevenueChartWidgetState extends State<RevenueChartWidget> {
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
                'Ingresos por ${_getPeriodLabel()}',
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
          SizedBox(height: 2.h),
          Container(
            height: 30.h,
            child:
                widget.revenueData.isEmpty ? _buildEmptyState() : _buildChart(),
          ),
          SizedBox(height: 2.h),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _getHorizontalInterval(),
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.borderColor.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: AppTheme.borderColor.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return _buildBottomTitle(value.toInt());
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _getHorizontalInterval(),
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return _buildLeftTitle(value);
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: AppTheme.borderColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        minX: 0,
        maxX: (widget.revenueData.length - 1).toDouble(),
        minY: 0,
        maxY: _getMaxY(),
        lineBarsData: [
          LineChartBarData(
            spots: _getSpots(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryRed,
                AppTheme.secondaryRed,
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: touchedIndex == index ? 6 : 4,
                  color: AppTheme.primaryRed,
                  strokeWidth: 2,
                  strokeColor: AppTheme.pureWhite,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryRed.withValues(alpha: 0.3),
                  AppTheme.primaryRed.withValues(alpha: 0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) {
            setState(() {
              if (touchResponse == null || touchResponse.lineBarSpots == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = touchResponse.lineBarSpots!.first.spotIndex;
            });
          },
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((spotIndex) {
              return TouchedSpotIndicatorData(
                FlLine(
                  color: AppTheme.primaryRed,
                  strokeWidth: 2,
                ),
                FlDotData(
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 8,
                      color: AppTheme.primaryRed,
                      strokeWidth: 2,
                      strokeColor: AppTheme.pureWhite,
                    );
                  },
                ),
              );
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppTheme.neutralBlack.withValues(alpha: 0.8),
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                final dataPoint = widget.revenueData[flSpot.x.toInt()];
                return LineTooltipItem(
                  '${dataPoint['label']}\n€${flSpot.y.toStringAsFixed(2)}',
                  TextStyle(
                    color: AppTheme.pureWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'trending_up',
            color: AppTheme.mediumGray,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No hay datos de ingresos',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Los datos aparecerán cuando se registren ventas',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    if (widget.revenueData.isEmpty) return const SizedBox.shrink();

    final totalRevenue = widget.revenueData.fold<double>(
      0.0,
      (sum, item) => sum + (item['value'] as double),
    );

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total ${_getPeriodLabel()}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.mediumGray,
                ),
              ),
              Text(
                '€${totalRevenue.toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.primaryRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Promedio',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.mediumGray,
                ),
              ),
              Text(
                '€${(totalRevenue / widget.revenueData.length).toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.successGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomTitle(int value) {
    if (value < 0 || value >= widget.revenueData.length) {
      return const SizedBox.shrink();
    }

    final data = widget.revenueData[value];
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Text(
        data['shortLabel'] ?? data['label'],
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildLeftTitle(double value) {
    return Text(
      '€${(value / 1000).toStringAsFixed(0)}k',
      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
        fontSize: 10.sp,
      ),
    );
  }

  List<FlSpot> _getSpots() {
    return widget.revenueData.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        (entry.value['value'] as double),
      );
    }).toList();
  }

  double _getMaxY() {
    if (widget.revenueData.isEmpty) return 1000;

    final maxValue = widget.revenueData.fold<double>(
      0.0,
      (max, item) =>
          (item['value'] as double) > max ? (item['value'] as double) : max,
    );

    return (maxValue * 1.2).ceilToDouble();
  }

  double _getHorizontalInterval() {
    final maxY = _getMaxY();
    return (maxY / 5).ceilToDouble();
  }

  String _getPeriodLabel() {
    switch (widget.selectedPeriod.toLowerCase()) {
      case 'today':
        return 'Hoy';
      case 'week':
        return 'Semana';
      case 'month':
        return 'Mes';
      default:
        return 'Período';
    }
  }
}