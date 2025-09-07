import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PaymentStatusDialog extends StatefulWidget {
  final String status; // 'processing', 'success', 'error'
  final String message;
  final String? transactionId;
  final double? amount;
  final VoidCallback? onClose;
  final VoidCallback? onRetry;
  final VoidCallback? onPrintReceipt;

  const PaymentStatusDialog({
    super.key,
    required this.status,
    required this.message,
    this.transactionId,
    this.amount,
    this.onClose,
    this.onRetry,
    this.onPrintReceipt,
  });

  @override
  State<PaymentStatusDialog> createState() => _PaymentStatusDialogState();
}

class _PaymentStatusDialogState extends State<PaymentStatusDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();

    // Trigger haptic feedback based on status
    if (widget.status == 'success') {
      HapticFeedback.lightImpact();
    } else if (widget.status == 'error') {
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 80.w,
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status icon
                _buildStatusIcon(colorScheme),
                SizedBox(height: 3.h),

                // Status title
                Text(
                  _getStatusTitle(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _getStatusColor(colorScheme),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),

                // Status message
                Text(
                  widget.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

                // Transaction details for success
                if (widget.status == 'success' &&
                    widget.transactionId != null) ...[
                  SizedBox(height: 3.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        if (widget.amount != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Monto:',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              Text(
                                '\$${widget.amount!.toStringAsFixed(2)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ID Transacción:',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: widget.transactionId!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ID copiado al portapapeles'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.transactionId!.length > 10
                                        ? '${widget.transactionId!.substring(0, 10)}...'
                                        : widget.transactionId!,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  CustomIconWidget(
                                    iconName: 'content_copy',
                                    color: colorScheme.primary,
                                    size: 4.w,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 4.h),

                // Action buttons
                _buildActionButtons(context, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(ColorScheme colorScheme) {
    Widget icon;
    Color backgroundColor;

    switch (widget.status) {
      case 'processing':
        icon = SizedBox(
          width: 12.w,
          height: 12.w,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        );
        backgroundColor = colorScheme.primary.withValues(alpha: 0.1);
        break;
      case 'success':
        icon = CustomIconWidget(
          iconName: 'check_circle',
          color: colorScheme.secondary,
          size: 12.w,
        );
        backgroundColor = colorScheme.secondary.withValues(alpha: 0.1);
        break;
      case 'error':
      default:
        icon = CustomIconWidget(
          iconName: 'error',
          color: colorScheme.error,
          size: 12.w,
        );
        backgroundColor = colorScheme.error.withValues(alpha: 0.1);
        break;
    }

    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(child: icon),
    );
  }

  String _getStatusTitle() {
    switch (widget.status) {
      case 'processing':
        return 'Procesando Pago...';
      case 'success':
        return '¡Pago Exitoso!';
      case 'error':
      default:
        return 'Error en el Pago';
    }
  }

  Color _getStatusColor(ColorScheme colorScheme) {
    switch (widget.status) {
      case 'processing':
        return colorScheme.primary;
      case 'success':
        return colorScheme.secondary;
      case 'error':
      default:
        return colorScheme.error;
    }
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme) {
    switch (widget.status) {
      case 'processing':
        return const SizedBox.shrink();

      case 'success':
        return Column(
          children: [
            if (widget.onPrintReceipt != null) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onPrintReceipt,
                  icon: CustomIconWidget(
                    iconName: 'print',
                    color: colorScheme.primary,
                    size: 5.w,
                  ),
                  label: const Text('Imprimir Recibo'),
                ),
              ),
              SizedBox(height: 2.h),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
                child: const Text('Continuar'),
              ),
            ),
          ],
        );

      case 'error':
      default:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
            ),
            if (widget.onRetry != null) ...[
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onRetry,
                  child: const Text('Reintentar'),
                ),
              ),
            ],
          ],
        );
    }
  }
}
