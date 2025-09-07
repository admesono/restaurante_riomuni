import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/amount_input_section.dart';
import './widgets/order_summary_card.dart';
import './widgets/payment_method_selector.dart';
import './widgets/payment_status_dialog.dart';
import './widgets/receipt_options.dart';
import './widgets/tip_calculator.dart';

class PaymentProcessing extends StatefulWidget {
  const PaymentProcessing({super.key});

  @override
  State<PaymentProcessing> createState() => _PaymentProcessingState();
}

class _PaymentProcessingState extends State<PaymentProcessing>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Payment state
  String _selectedPaymentMethod = 'cash';
  double _paidAmount = 0.0;
  double _tipAmount = 0.0;
  double _tipPercentage = 0.0;
  List<String> _selectedReceiptOptions = ['print'];
  String _customerEmail = '';
  String _customerPhone = '';
  bool _isOrderExpanded = false;
  bool _isProcessing = false;

  // Mock order data
  final Map<String, dynamic> _orderData = {
    'orderNumber': 'ORD-2025-001',
    'tableNumber': '12',
    'subtotal': 45.50,
    'tax': 4.55,
    'total': 50.05,
    'items': [
      {
        'name': 'Paella Valenciana',
        'quantity': 2,
        'price': 24.00,
        'notes': 'Sin mariscos',
      },
      {
        'name': 'Sangría Tinto',
        'quantity': 1,
        'price': 12.50,
        'notes': '',
      },
      {
        'name': 'Crema Catalana',
        'quantity': 2,
        'price': 9.00,
        'notes': 'Extra canela',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get _totalWithTip => (_orderData['total'] as double) + _tipAmount;

  bool get _canProcessPayment {
    if (_selectedPaymentMethod == 'cash') {
      return _paidAmount >= _totalWithTip;
    }
    return true; // For card payments, assume validation happens during processing
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Procesar Pago'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Order summary header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Text(
                    'Total a Pagar',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '\$${_totalWithTip.toStringAsFixed(2)}',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  if (_tipAmount > 0) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      'Incluye propina: \$${_tipAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order summary card
                  OrderSummaryCard(
                    orderData: _orderData,
                    isExpanded: _isOrderExpanded,
                    onToggleExpanded: () {
                      setState(() {
                        _isOrderExpanded = !_isOrderExpanded;
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Payment method selector
                  PaymentMethodSelector(
                    selectedMethod: _selectedPaymentMethod,
                    onMethodSelected: (method) {
                      setState(() {
                        _selectedPaymentMethod = method;
                        _paidAmount =
                            0.0; // Reset paid amount when changing method
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Split payment handling
                  if (_selectedPaymentMethod == 'split_payment') ...[
                    _buildSplitPaymentSection(),
                    SizedBox(height: 3.h),
                  ],

                  // Amount input section
                  AmountInputSection(
                    totalAmount: _totalWithTip,
                    paidAmount: _paidAmount,
                    paymentMethod: _selectedPaymentMethod,
                    onAmountChanged: (amount) {
                      setState(() {
                        _paidAmount = amount;
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Tip calculator
                  TipCalculator(
                    orderTotal: _orderData['total'] as double,
                    tipAmount: _tipAmount,
                    tipPercentage: _tipPercentage,
                    onTipChanged: (amount, percentage) {
                      setState(() {
                        _tipAmount = amount;
                        _tipPercentage = percentage;
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Receipt options
                  ReceiptOptions(
                    selectedOptions: _selectedReceiptOptions,
                    customerEmail: _customerEmail,
                    customerPhone: _customerPhone,
                    onOptionsChanged: (options) {
                      setState(() {
                        _selectedReceiptOptions = options;
                      });
                    },
                    onEmailChanged: (email) {
                      setState(() {
                        _customerEmail = email;
                      });
                    },
                    onPhoneChanged: (phone) {
                      setState(() {
                        _customerPhone = phone;
                      });
                    },
                  ),

                  SizedBox(height: 10.h), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      // Process payment button
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Payment validation message
              if (!_canProcessPayment && _selectedPaymentMethod == 'cash') ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  margin: EdgeInsets.only(bottom: 2.h),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withValues(alpha: 0.1),
                    border: Border.all(
                      color: colorScheme.error.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'warning',
                        color: colorScheme.error,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Monto insuficiente. Faltan \$${(_totalWithTip - _paidAmount).toStringAsFixed(2)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Process payment button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canProcessPayment && !_isProcessing
                      ? _processPayment
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isProcessing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 5.w,
                              height: 5.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Procesando...',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Procesar Pago - \$${_totalWithTip.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSplitPaymentSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'call_split',
                color: colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Pago Dividido',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Divida el pago entre múltiples métodos o personas. Toque para configurar las divisiones.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 2.h),
          ElevatedButton.icon(
            onPressed: _showSplitPaymentDialog,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: colorScheme.onPrimary,
              size: 5.w,
            ),
            label: const Text('Configurar División'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PaymentStatusDialog(
        status: 'processing',
        message: 'Procesando su pago, por favor espere...',
      ),
    );

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));

    // Close processing dialog
    Navigator.of(context).pop();

    // Simulate payment result (90% success rate)
    final isSuccess = DateTime.now().millisecond % 10 != 0;

    if (isSuccess) {
      // Generate transaction ID
      final transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PaymentStatusDialog(
          status: 'success',
          message: 'Su pago ha sido procesado exitosamente.',
          transactionId: transactionId,
          amount: _totalWithTip,
          onClose: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Close payment screen
            _navigateToSuccess();
          },
          onPrintReceipt:
              _selectedReceiptOptions.contains('print') ? _printReceipt : null,
        ),
      );
    } else {
      // Show error dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PaymentStatusDialog(
          status: 'error',
          message: _getRandomErrorMessage(),
          onClose: () => Navigator.of(context).pop(),
          onRetry: () {
            Navigator.of(context).pop();
            _processPayment();
          },
        ),
      );
    }

    setState(() {
      _isProcessing = false;
    });
  }

  String _getRandomErrorMessage() {
    final errors = [
      'Tarjeta declinada. Verifique los fondos disponibles.',
      'Error de conexión. Verifique su conexión a internet.',
      'Impresora desconectada. Verifique la conexión Bluetooth.',
      'Tiempo de espera agotado. Intente nuevamente.',
      'Error del procesador de pagos. Contacte soporte técnico.',
    ];
    return errors[DateTime.now().millisecond % errors.length];
  }

  void _printReceipt() {
    // Simulate receipt printing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'print',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            const Text('Imprimiendo recibo...'),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void _navigateToSuccess() {
    // Navigate to dashboard or order management
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard',
      (route) => false,
    );
  }

  void _showSplitPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pago Dividido'),
        content: const Text(
          'Funcionalidad de pago dividido próximamente disponible. '
          'Podrá dividir el pago entre múltiples tarjetas, efectivo, '
          'o entre diferentes personas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda - Procesamiento de Pagos'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Métodos de Pago Disponibles:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('• Efectivo: Ingrese el monto recibido'),
              const Text('• Tarjeta: Procesamiento automático'),
              const Text('• Pago Móvil: Apple Pay / Google Pay'),
              const Text('• Pago Dividido: Múltiples métodos'),
              const SizedBox(height: 16),
              const Text(
                'Opciones de Recibo:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('• Imprimir: Recibo físico'),
              const Text('• Email: Envío por correo'),
              const Text('• SMS: Envío por mensaje'),
              const Text('• Omitir: Sin recibo'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
