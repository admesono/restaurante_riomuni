import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/export_options_widget.dart';
import './widgets/payment_breakdown_widget.dart';
import './widgets/revenue_chart_widget.dart';
import './widgets/staff_performance_widget.dart';
import './widgets/time_period_selector_widget.dart';
import './widgets/top_selling_items_widget.dart';

class SalesReports extends StatefulWidget {
  const SalesReports({super.key});

  @override
  State<SalesReports> createState() => _SalesReportsState();
}

class _SalesReportsState extends State<SalesReports>
    with TickerProviderStateMixin {
  String _selectedPeriod = 'today';
  bool _isLoading = false;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  // Mock data for sales reports
  final List<Map<String, dynamic>> _todayRevenueData = [
    {'label': '9:00', 'shortLabel': '9h', 'value': 150.0},
    {'label': '10:00', 'shortLabel': '10h', 'value': 280.0},
    {'label': '11:00', 'shortLabel': '11h', 'value': 420.0},
    {'label': '12:00', 'shortLabel': '12h', 'value': 680.0},
    {'label': '13:00', 'shortLabel': '13h', 'value': 950.0},
    {'label': '14:00', 'shortLabel': '14h', 'value': 1200.0},
    {'label': '15:00', 'shortLabel': '15h', 'value': 890.0},
    {'label': '16:00', 'shortLabel': '16h', 'value': 650.0},
    {'label': '17:00', 'shortLabel': '17h', 'value': 480.0},
    {'label': '18:00', 'shortLabel': '18h', 'value': 320.0},
  ];

  final List<Map<String, dynamic>> _weekRevenueData = [
    {'label': 'Lunes', 'shortLabel': 'Lun', 'value': 2450.0},
    {'label': 'Martes', 'shortLabel': 'Mar', 'value': 2680.0},
    {'label': 'Miércoles', 'shortLabel': 'Mié', 'value': 3120.0},
    {'label': 'Jueves', 'shortLabel': 'Jue', 'value': 2890.0},
    {'label': 'Viernes', 'shortLabel': 'Vie', 'value': 3450.0},
    {'label': 'Sábado', 'shortLabel': 'Sáb', 'value': 4200.0},
    {'label': 'Domingo', 'shortLabel': 'Dom', 'value': 3800.0},
  ];

  final List<Map<String, dynamic>> _monthRevenueData = [
    {'label': 'Semana 1', 'shortLabel': 'S1', 'value': 18500.0},
    {'label': 'Semana 2', 'shortLabel': 'S2', 'value': 22300.0},
    {'label': 'Semana 3', 'shortLabel': 'S3', 'value': 19800.0},
    {'label': 'Semana 4', 'shortLabel': 'S4', 'value': 25600.0},
  ];

  final List<Map<String, dynamic>> _topSellingItems = [
    {
      'name': 'Paella Valenciana',
      'category': 'Platos Principales',
      'quantity': 45,
      'revenue': 1350.0,
      'image':
          'https://images.unsplash.com/photo-1534080564583-6be75777b70a?w=400&h=300&fit=crop',
    },
    {
      'name': 'Jamón Ibérico',
      'category': 'Entrantes',
      'quantity': 38,
      'revenue': 950.0,
      'image':
          'https://images.unsplash.com/photo-1549888834-3ec93abae044?w=400&h=300&fit=crop',
    },
    {
      'name': 'Gazpacho Andaluz',
      'category': 'Sopas',
      'quantity': 32,
      'revenue': 480.0,
      'image':
          'https://images.unsplash.com/photo-1571197119282-7c4e2b2a5b5a?w=400&h=300&fit=crop',
    },
    {
      'name': 'Tortilla Española',
      'category': 'Platos Principales',
      'quantity': 28,
      'revenue': 420.0,
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
    },
    {
      'name': 'Sangría de la Casa',
      'category': 'Bebidas',
      'quantity': 52,
      'revenue': 390.0,
      'image':
          'https://images.unsplash.com/photo-1571104508999-893933ded431?w=400&h=300&fit=crop',
    },
  ];

  final List<Map<String, dynamic>> _paymentData = [
    {
      'method': 'card',
      'amount': 3450.0,
      'transactions': 45,
    },
    {
      'method': 'cash',
      'amount': 1890.0,
      'transactions': 28,
    },
    {
      'method': 'digital',
      'amount': 1260.0,
      'transactions': 18,
    },
  ];

  final List<Map<String, dynamic>> _staffData = [
    {
      'name': 'María González',
      'role': 'Camarera Senior',
      'sales': 2450.0,
      'orders': 32,
      'efficiency': 94.5,
      'avatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=200&h=200&fit=crop&crop=face',
    },
    {
      'name': 'Carlos Rodríguez',
      'role': 'Camarero',
      'sales': 2180.0,
      'orders': 28,
      'efficiency': 89.2,
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
    },
    {
      'name': 'Ana Martínez',
      'role': 'Cajera',
      'sales': 1950.0,
      'orders': 35,
      'efficiency': 92.8,
      'avatar':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop&crop=face',
    },
    {
      'name': 'Luis Fernández',
      'role': 'Camarero',
      'sales': 1680.0,
      'orders': 22,
      'efficiency': 87.3,
      'avatar':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: CustomAppBar(
        title: 'Reportes de Ventas',
        showBackButton: false,
        showNotifications: true,
        notificationCount: 3,
        showSyncStatus: true,
        syncStatus: true,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.pureWhite,
              size: 24,
            ),
            onPressed: _refreshData,
            tooltip: 'Actualizar datos',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: AppTheme.pureWhite,
              size: 24,
            ),
            onPressed: _showExportOptions,
            tooltip: 'Exportar reportes',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.primaryRed,
        child: _isLoading ? _buildLoadingState() : _buildContent(),
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 3,
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Time period selector
          TimePeriodSelectorWidget(
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: _onPeriodChanged,
            onCustomDateTap: _showCustomDatePicker,
          ),

          // Custom date range display
          if (_selectedPeriod == 'custom' &&
              _customStartDate != null &&
              _customEndDate != null)
            _buildCustomDateDisplay(),

          // Revenue chart
          RevenueChartWidget(
            selectedPeriod: _selectedPeriod,
            revenueData: _getRevenueDataForPeriod(),
            onChartTap: _showFullScreenChart,
          ),

          // Top selling items
          TopSellingItemsWidget(
            topItems: _topSellingItems,
            onViewAll: _showAllTopItems,
          ),

          // Payment breakdown
          PaymentBreakdownWidget(
            paymentData: _paymentData,
            onChartTap: _showFullScreenPaymentChart,
          ),

          // Staff performance
          StaffPerformanceWidget(
            staffData: _staffData,
            onViewAll: _showAllStaffPerformance,
          ),

          // Export options
          ExportOptionsWidget(
            onPdfExport: _exportToPdf,
            onEmailShare: _shareViaEmail,
            onPrint: _printReport,
            onCsvExport: _exportToCsv,
          ),

          // Bottom spacing
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryRed,
          ),
          SizedBox(height: 2.h),
          Text(
            'Cargando reportes...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDateDisplay() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primaryRed.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'date_range',
            color: AppTheme.primaryRed,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Text(
            '${_formatDate(_customStartDate!)} - ${_formatDate(_customEndDate!)}',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryRed,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getRevenueDataForPeriod() {
    switch (_selectedPeriod) {
      case 'today':
        return _todayRevenueData;
      case 'week':
        return _weekRevenueData;
      case 'month':
        return _monthRevenueData;
      case 'custom':
        return _weekRevenueData; // Use week data as placeholder for custom
      default:
        return _todayRevenueData;
    }
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Datos actualizados correctamente'),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCustomDatePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _customStartDate != null && _customEndDate != null
          ? DateTimeRange(start: _customStartDate!, end: _customEndDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primaryRed,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _customStartDate = picked.start;
        _customEndDate = picked.end;
        _selectedPeriod = 'custom';
      });
      _refreshData();
    }
  }

  void _showFullScreenChart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Vista completa del gráfico próximamente'),
        backgroundColor: AppTheme.primaryRed,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showFullScreenPaymentChart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Vista completa de métodos de pago próximamente'),
        backgroundColor: AppTheme.primaryRed,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAllTopItems() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lista completa de productos próximamente'),
        backgroundColor: AppTheme.primaryRed,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAllStaffPerformance() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Rendimiento completo del personal próximamente'),
        backgroundColor: AppTheme.primaryRed,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ExportOptionsWidget(
          onPdfExport: () {
            Navigator.pop(context);
            _exportToPdf();
          },
          onEmailShare: () {
            Navigator.pop(context);
            _shareViaEmail();
          },
          onPrint: () {
            Navigator.pop(context);
            _printReport();
          },
          onCsvExport: () {
            Navigator.pop(context);
            _exportToCsv();
          },
        ),
      ),
    );
  }

  void _exportToPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exportando reporte a PDF...'),
        backgroundColor: AppTheme.primaryRed,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareViaEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Compartiendo reporte por email...'),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _printReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Imprimiendo reporte...'),
        backgroundColor: AppTheme.warningOrange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _exportToCsv() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exportando datos a CSV...'),
        backgroundColor: AppTheme.mediumGray,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
