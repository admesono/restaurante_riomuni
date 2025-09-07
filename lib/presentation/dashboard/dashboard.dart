import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dashboard_header.dart';
import './widgets/dashboard_metrics_card.dart';
import './widgets/quick_action_button.dart';
import './widgets/recent_order_item.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  int _currentTabIndex = 0;

  // Mock data for dashboard
  final List<Map<String, dynamic>> _recentOrders = [
    {
      "id": 1,
      "orderNumber": "#RM001",
      "tableNumber": "Mesa 5",
      "timestamp": "Hace 15 min",
      "status": "preparing",
      "total": 45.50,
      "items": ["Paella Valenciana", "Sangría", "Pan con Tomate"]
    },
    {
      "id": 2,
      "orderNumber": "#RM002",
      "tableNumber": "Mesa 12",
      "timestamp": "Hace 32 min",
      "status": "ready",
      "total": 78.25,
      "items": ["Jamón Ibérico", "Gazpacho", "Flan Casero", "Vino Tinto"]
    },
    {
      "id": 3,
      "orderNumber": "#RM003",
      "tableNumber": "Mesa 3",
      "timestamp": "Hace 1 hora",
      "status": "served",
      "total": 32.75,
      "items": ["Tortilla Española", "Café con Leche"]
    },
    {
      "id": 4,
      "orderNumber": "#RM004",
      "tableNumber": "Mesa 8",
      "timestamp": "Hace 1.5 horas",
      "status": "completed",
      "total": 95.00,
      "items": [
        "Cochinillo Asado",
        "Ensalada Mixta",
        "Crema Catalana",
        "Rioja Reserva"
      ]
    },
    {
      "id": 5,
      "orderNumber": "#RM005",
      "tableNumber": "Mesa 15",
      "timestamp": "Hace 2 min",
      "status": "pending",
      "total": 28.50,
      "items": ["Croquetas de Jamón", "Cerveza Estrella"]
    }
  ];

  final Map<String, dynamic> _todayMetrics = {
    "totalSales": 1247.85,
    "orderCount": 23,
    "averageTicket": 54.25,
    "tablesOccupied": 8,
    "totalTables": 20,
    "pendingOrders": 3,
    "completedOrders": 20
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });
    _loadDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshDashboard() async {
    await _loadDashboardData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dashboard actualizado'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToScreen(String route) {
    Navigator.pushNamed(context, route);
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOrderDetailsSheet(order),
    );
  }

  void _showOrderActions(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOrderActionsSheet(order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Tab Bar
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: colorScheme.primary,
                labelColor: colorScheme.primary,
                unselectedLabelColor:
                    colorScheme.onSurface.withValues(alpha: 0.6),
                labelStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
                unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
                tabs: const [
                  Tab(text: 'Dashboard'),
                  Tab(text: 'Pedidos'),
                  Tab(text: 'Menú'),
                  Tab(text: 'Reportes'),
                  Tab(text: 'Más'),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDashboardTab(),
                  _buildPlaceholderTab('Pedidos', Icons.receipt_long),
                  _buildPlaceholderTab('Menú', Icons.restaurant_menu),
                  _buildPlaceholderTab('Reportes', Icons.analytics),
                  _buildPlaceholderTab('Más', Icons.more_horiz),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _currentTabIndex == 0
          ? FloatingActionButton(
              onPressed: () => _navigateToScreen('/menu-management'),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              child: CustomIconWidget(
                iconName: 'add',
                color: colorScheme.onPrimary,
                size: 6.w,
              ),
            )
          : null,
    );
  }

  Widget _buildDashboardTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: _refreshDashboard,
      color: colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            DashboardHeader(
              staffName: 'Carlos Rodríguez',
              currentDate: 'Viernes, 6 de Septiembre 2024',
              notificationCount: 3,
              onNotificationTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('3 notificaciones pendientes'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),

            SizedBox(height: 3.h),

            // Metrics Cards
            Text(
              'Resumen de Hoy',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),

            SizedBox(height: 2.h),

            if (_isLoading) _buildLoadingMetrics() else _buildMetricsGrid(),

            SizedBox(height: 3.h),

            // Quick Actions
            Text(
              'Acciones Rápidas',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),

            SizedBox(height: 2.h),

            _buildQuickActions(),

            SizedBox(height: 3.h),

            // Recent Orders
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pedidos Recientes',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigateToScreen('/sales-reports'),
                  child: Text(
                    'Ver todos',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            if (_isLoading) _buildLoadingOrders() else _buildRecentOrdersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String title, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: icon.codePoint.toString(),
            color: colorScheme.onSurface.withValues(alpha: 0.3),
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            '$title próximamente',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Esta sección estará disponible pronto',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMetrics() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 4.w,
      mainAxisSpacing: 2.h,
      childAspectRatio: 1.5,
      children: List.generate(4, (index) => _buildLoadingCard()),
    );
  }

  Widget _buildLoadingCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20.w,
            height: 2.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            width: 15.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 0.5.h),
          Container(
            width: 25.w,
            height: 1.5.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 4.w,
      mainAxisSpacing: 2.h,
      childAspectRatio: 1.5,
      children: [
        DashboardMetricsCard(
          title: 'Ventas de Hoy',
          value: '\$${_todayMetrics['totalSales'].toStringAsFixed(2)}',
          subtitle: '+12% vs ayer',
          icon: Icons.attach_money,
          onTap: () => _navigateToScreen('/sales-reports'),
        ),
        DashboardMetricsCard(
          title: 'Pedidos',
          value: '${_todayMetrics['orderCount']}',
          subtitle: '${_todayMetrics['pendingOrders']} pendientes',
          icon: Icons.receipt_long,
          onTap: () => _navigateToScreen('/sales-reports'),
        ),
        DashboardMetricsCard(
          title: 'Ticket Promedio',
          value: '\$${_todayMetrics['averageTicket'].toStringAsFixed(2)}',
          subtitle: '+5% vs ayer',
          icon: Icons.trending_up,
          onTap: () => _navigateToScreen('/sales-reports'),
        ),
        DashboardMetricsCard(
          title: 'Mesas Ocupadas',
          value:
              '${_todayMetrics['tablesOccupied']}/${_todayMetrics['totalTables']}',
          subtitle:
              '${((_todayMetrics['tablesOccupied'] / _todayMetrics['totalTables']) * 100).toInt()}% ocupación',
          icon: Icons.table_restaurant,
          onTap: () => _navigateToScreen('/table-management'),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 2.h,
      childAspectRatio: 1.0,
      children: [
        QuickActionButton(
          title: 'Nuevo Pedido',
          icon: Icons.add_circle_outline,
          onTap: () => _navigateToScreen('/menu-management'),
        ),
        QuickActionButton(
          title: 'Ver Mesas',
          icon: Icons.table_restaurant,
          backgroundColor: Colors.blue,
          onTap: () => _navigateToScreen('/table-management'),
        ),
        QuickActionButton(
          title: 'Inventario',
          icon: Icons.inventory,
          backgroundColor: Colors.green,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Inventario próximamente'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingOrders() {
    return Column(
      children: List.generate(3, (index) => _buildLoadingOrderCard()),
    );
  }

  Widget _buildLoadingOrderCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              Container(
                width: 20.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 15.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            width: 15.w,
            height: 1.5.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 25.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 12.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersList() {
    if (_recentOrders.isEmpty) {
      return _buildEmptyOrdersState();
    }

    return Column(
      children: (_recentOrders as List)
          .take(5)
          .map((order) => RecentOrderItem(
                order: order as Map<String, dynamic>,
                onTap: () => _showOrderDetails(order),
                onLongPress: () =>
                    _showOrderActions(order),
              ))
          .toList(),
    );
  }

  Widget _buildEmptyOrdersState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'receipt_long',
            color: colorScheme.onSurface.withValues(alpha: 0.3),
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            '¡Comienza tu día!',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Crea tu primer pedido del día para comenzar a generar ventas',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _navigateToScreen('/menu-management'),
              child: Text(
                'Crear Primer Pedido',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailsSheet(Map<String, dynamic> order) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String orderNumber = (order['orderNumber'] as String?) ?? '#0000';
    final String tableNumber = (order['tableNumber'] as String?) ?? 'Mesa 0';
    final String status = (order['status'] as String?) ?? 'pending';
    final double total = (order['total'] as num?)?.toDouble() ?? 0.0;
    final List<String> items =
        ((order['items'] as List?)?.cast<String>()) ?? [];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 10.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Order header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderNumber,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          tableNumber,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getStatusColor(status).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _getStatusText(status),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Items list
                Text(
                  'Artículos del Pedido',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),

                SizedBox(height: 2.h),

                ...items.map((item) => Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'restaurant',
                            color: colorScheme.primary,
                            size: 5.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              item,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                SizedBox(height: 3.h),

                // Total
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cerrar',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _navigateToScreen('/payment-processing');
                        },
                        child: Text(
                          'Procesar Pago',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderActionsSheet(Map<String, dynamic> order) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String orderNumber = (order['orderNumber'] as String?) ?? '#0000';

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              SizedBox(height: 3.h),

              Text(
                'Acciones para $orderNumber',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),

              SizedBox(height: 3.h),

              _buildActionTile(
                context,
                'Ver Detalles',
                Icons.visibility,
                () {
                  Navigator.pop(context);
                  _showOrderDetails(order);
                },
              ),

              _buildActionTile(
                context,
                'Imprimir Recibo',
                Icons.print,
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Imprimiendo recibo...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              _buildActionTile(
                context,
                'Modificar Estado',
                Icons.edit,
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Modificar estado próximamente'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              SizedBox(height: 2.h),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancelar',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 14.sp,
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

  Widget _buildActionTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CustomIconWidget(
        iconName: icon.codePoint.toString(),
        color: colorScheme.primary,
        size: 6.w,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
          fontSize: 14.sp,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'ready':
        return Colors.green;
      case 'served':
        return AppTheme.primaryRed;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pendiente';
      case 'preparing':
        return 'Preparando';
      case 'ready':
        return 'Listo';
      case 'served':
        return 'Servido';
      case 'completed':
        return 'Completado';
      default:
        return 'Desconocido';
    }
  }
}
