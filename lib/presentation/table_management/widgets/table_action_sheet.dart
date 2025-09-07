import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class TableActionSheet extends StatelessWidget {
  final Map<String, dynamic> table;
  final Function(String) onActionSelected;

  const TableActionSheet({
    super.key,
    required this.table,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String status = table['status'] as String? ?? 'available';
    final int tableNumber = table['number'] as int? ?? 0;
    final int capacity = table['capacity'] as int? ?? 4;
    final String? customerName = table['customerName'] as String?;
    final String? orderTime = table['orderTime'] as String?;
    final double? orderTotal = table['orderTotal'] as double?;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Table info header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  child: Center(
                    child: Text(
                      tableNumber.toString(),
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mesa $tableNumber',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'person',
                            size: 14,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '$capacity personas',
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusLabel(status),
                              style: GoogleFonts.roboto(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: _getStatusColor(status),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Customer info (if occupied)
          if (status == 'occupied' && customerName != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información del Cliente',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'person_outline',
                        size: 16,
                        color: colorScheme.onSurface,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        customerName,
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  if (orderTime != null) ...[
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'access_time',
                          size: 16,
                          color: colorScheme.onSurface,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Desde: $orderTime',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (orderTotal != null) ...[
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'receipt',
                          size: 16,
                          color: colorScheme.onSurface,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Total: \$${orderTotal.toStringAsFixed(2)}',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Action buttons
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              children: _buildActionButtons(context, status),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context, String status) {
    final List<Widget> buttons = [];

    switch (status.toLowerCase()) {
      case 'available':
        buttons.addAll([
          _buildActionButton(
            context,
            'Asignar Pedido',
            'restaurant_menu',
            AppTheme.primaryRed,
            () => onActionSelected('assign_order'),
          ),
          SizedBox(height: 2.h),
          _buildActionButton(
            context,
            'Agregar Reserva',
            'schedule',
            Colors.blue,
            () => onActionSelected('add_reservation'),
          ),
        ]);
        break;

      case 'occupied':
        buttons.addAll([
          _buildActionButton(
            context,
            'Ver Pedido',
            'receipt_long',
            AppTheme.primaryRed,
            () => onActionSelected('view_order'),
          ),
          SizedBox(height: 2.h),
          _buildActionButton(
            context,
            'Procesar Pago',
            'payment',
            AppTheme.successGreen,
            () => onActionSelected('process_payment'),
          ),
          SizedBox(height: 2.h),
          _buildActionButton(
            context,
            'Liberar Mesa',
            'check_circle',
            AppTheme.warningOrange,
            () => onActionSelected('free_table'),
          ),
        ]);
        break;

      case 'cleaning':
        buttons.addAll([
          _buildActionButton(
            context,
            'Marcar como Limpia',
            'check_circle',
            AppTheme.successGreen,
            () => onActionSelected('mark_clean'),
          ),
        ]);
        break;

      case 'reserved':
        buttons.addAll([
          _buildActionButton(
            context,
            'Confirmar Llegada',
            'people',
            AppTheme.primaryRed,
            () => onActionSelected('confirm_arrival'),
          ),
          SizedBox(height: 2.h),
          _buildActionButton(
            context,
            'Cancelar Reserva',
            'cancel',
            AppTheme.errorRed,
            () => onActionSelected('cancel_reservation'),
          ),
        ]);
        break;
    }

    // Always add history button
    if (buttons.isNotEmpty) {
      buttons.add(SizedBox(height: 2.h));
    }
    buttons.add(
      _buildActionButton(
        context,
        'Ver Historial',
        'history',
        AppTheme.mediumGray,
        () => onActionSelected('view_history'),
        isOutlined: true,
      ),
    );

    return buttons;
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    String iconName,
    Color color,
    VoidCallback onPressed, {
    bool isOutlined = false,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: CustomIconWidget(
                iconName: iconName,
                size: 18,
                color: color,
              ),
              label: Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: CustomIconWidget(
                iconName: iconName,
                size: 18,
                color: Colors.white,
              ),
              label: Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return AppTheme.successGreen;
      case 'occupied':
        return AppTheme.errorRed;
      case 'cleaning':
        return AppTheme.warningOrange;
      case 'reserved':
        return Colors.blue;
      default:
        return AppTheme.mediumGray;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return 'Disponible';
      case 'occupied':
        return 'Ocupada';
      case 'cleaning':
        return 'Limpieza';
      case 'reserved':
        return 'Reservada';
      default:
        return 'Desconocido';
    }
  }
}