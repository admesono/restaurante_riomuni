import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExportOptionsWidget extends StatelessWidget {
  final VoidCallback? onPdfExport;
  final VoidCallback? onEmailShare;
  final VoidCallback? onPrint;
  final VoidCallback? onCsvExport;

  const ExportOptionsWidget({
    super.key,
    this.onPdfExport,
    this.onEmailShare,
    this.onPrint,
    this.onCsvExport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            'Exportar Reportes',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildExportButton(
                  'PDF',
                  'picture_as_pdf',
                  AppTheme.primaryRed,
                  onPdfExport ?? () => _showComingSoon(context, 'Exportar PDF'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildExportButton(
                  'Email',
                  'email',
                  AppTheme.successGreen,
                  onEmailShare ??
                      () => _showComingSoon(context, 'Compartir por Email'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildExportButton(
                  'Imprimir',
                  'print',
                  AppTheme.warningOrange,
                  onPrint ?? () => _showComingSoon(context, 'Imprimir'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildExportButton(
                  'CSV',
                  'table_chart',
                  AppTheme.mediumGray,
                  onCsvExport ?? () => _showComingSoon(context, 'Exportar CSV'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(
    String label,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature estará disponible próximamente'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.primaryRed,
      ),
    );
  }
}
