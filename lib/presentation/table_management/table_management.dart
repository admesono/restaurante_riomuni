import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/floor_plan_widget.dart';
import './widgets/floor_selector.dart';
import './widgets/table_action_sheet.dart';
import './widgets/table_filters.dart';
import './widgets/table_status_legend.dart';
import 'widgets/floor_plan_widget.dart';
import 'widgets/floor_selector.dart';
import 'widgets/table_action_sheet.dart';
import 'widgets/table_filters.dart';
import 'widgets/table_status_legend.dart';

class TableManagement extends StatefulWidget {
  const TableManagement({super.key});

  @override
  State<TableManagement> createState() => _TableManagementState();
}

class _TableManagementState extends State<TableManagement>
    with TickerProviderStateMixin {
  int _currentBottomIndex = 2; // Table management index
  int _currentFloorIndex = 0;
  String _selectedFilter = 'all';
  bool _isLoading = false;

  late PageController _pageController;
  late AnimationController _refreshController;

  // Mock data for floors
  final List<String> _floors = [
    'Planta Baja',
    'Primer Piso',
    'Terraza',
  ];

  // Mock data for tables by floor
  final Map<int, List<Map<String, dynamic>>> _tablesByFloor = {
    0: [
      // Planta Baja
      {
        'id': 1,
        'number': 1,
        'status': 'available',
        'capacity': 4,
        'shape': 'circular',
        'x': 20.0,
        'y': 15.0,
      },
      {
        'id': 2,
        'number': 2,
        'status': 'occupied',
        'capacity': 2,
        'shape': 'circular',
        'x': 45.0,
        'y': 15.0,
        'customerName': 'Carlos Mendoza',
        'orderTime': '19:30',
        'orderTotal': 45.50,
      },
      {
        'id': 3,
        'number': 3,
        'status': 'reserved',
        'capacity': 6,
        'shape': 'rectangular',
        'x': 70.0,
        'y': 15.0,
        'hasReservation': true,
        'reservationTime': '20:00',
        'customerName': 'Ana García',
      },
      {
        'id': 4,
        'number': 4,
        'status': 'cleaning',
        'capacity': 4,
        'shape': 'circular',
        'x': 20.0,
        'y': 40.0,
      },
      {
        'id': 5,
        'number': 5,
        'status': 'available',
        'capacity': 2,
        'shape': 'circular',
        'x': 45.0,
        'y': 40.0,
      },
      {
        'id': 6,
        'number': 6,
        'status': 'occupied',
        'capacity': 8,
        'shape': 'rectangular',
        'x': 70.0,
        'y': 40.0,
        'customerName': 'Familia Rodríguez',
        'orderTime': '18:45',
        'orderTotal': 125.75,
      },
      {
        'id': 7,
        'number': 7,
        'status': 'available',
        'capacity': 4,
        'shape': 'circular',
        'x': 20.0,
        'y': 65.0,
      },
      {
        'id': 8,
        'number': 8,
        'status': 'available',
        'capacity': 2,
        'shape': 'circular',
        'x': 45.0,
        'y': 65.0,
      },
    ],
    1: [
      // Primer Piso
      {
        'id': 9,
        'number': 9,
        'status': 'occupied',
        'capacity': 4,
        'shape': 'circular',
        'x': 25.0,
        'y': 20.0,
        'customerName': 'Miguel Santos',
        'orderTime': '19:15',
        'orderTotal': 67.25,
      },
      {
        'id': 10,
        'number': 10,
        'status': 'available',
        'capacity': 6,
        'shape': 'rectangular',
        'x': 55.0,
        'y': 20.0,
      },
      {
        'id': 11,
        'number': 11,
        'status': 'reserved',
        'capacity': 2,
        'shape': 'circular',
        'x': 25.0,
        'y': 50.0,
        'hasReservation': true,
        'reservationTime': '21:00',
        'customerName': 'Laura Jiménez',
      },
      {
        'id': 12,
        'number': 12,
        'status': 'available',
        'capacity': 4,
        'shape': 'circular',
        'x': 55.0,
        'y': 50.0,
      },
    ],
    2: [
      // Terraza
      {
        'id': 13,
        'number': 13,
        'status': 'available',
        'capacity': 4,
        'shape': 'circular',
        'x': 30.0,
        'y': 25.0,
      },
      {
        'id': 14,
        'number': 14,
        'status': 'available',
        'capacity': 2,
        'shape': 'circular',
        'x': 60.0,
        'y': 25.0,
      },
      {
        'id': 15,
        'number': 15,
        'status': 'occupied',
        'capacity': 6,
        'shape': 'rectangular',
        'x': 45.0,
        'y': 55.0,
        'customerName': 'Pedro Martín',
        'orderTime': '20:00',
        'orderTotal': 89.00,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _loadTableData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadTableData() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isLoading = false);
  }

  Future<void> _refreshData() async {
    _refreshController.forward();
    await _loadTableData();
    _refreshController.reset();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Estado de mesas actualizado'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }

  List<Map<String, dynamic>> get _currentFloorTables {
    final allTables = _tablesByFloor[_currentFloorIndex] ?? [];

    if (_selectedFilter == 'all') {
      return allTables;
    }

    return allTables
        .where((table) =>
            (table['status'] as String).toLowerCase() ==
            _selectedFilter.toLowerCase())
        .toList();
  }

  Map<String, int> get _statusCounts {
    final allTables = _tablesByFloor[_currentFloorIndex] ?? [];
    final Map<String, int> counts = {
      'available': 0,
      'occupied': 0,
      'cleaning': 0,
      'reserved': 0,
    };

    for (final table in allTables) {
      final status = (table['status'] as String).toLowerCase();
      counts[status] = (counts[status] ?? 0) + 1;
    }

    return counts;
  }

  void _onTableTap(Map<String, dynamic> table) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TableActionSheet(
        table: table,
        onActionSelected: (action) => _handleTableAction(table, action),
      ),
    );
  }

  void _onTableLongPress(Map<String, dynamic> table) {
    _showTableContextMenu(table);
  }

  void _showTableContextMenu(Map<String, dynamic> table) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + 50.w,
        position.dy + 30.h,
        position.dx + 50.w,
        position.dy + 30.h,
      ),
      items: [
        PopupMenuItem(
          value: 'details',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                size: 18,
                color: AppTheme.primaryRed,
              ),
              SizedBox(width: 2.w),
              const Text('Ver Detalles'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'history',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'history',
                size: 18,
                color: AppTheme.mediumGray,
              ),
              SizedBox(width: 2.w),
              const Text('Ver Historial'),
            ],
          ),
        ),
        if ((table['status'] as String).toLowerCase() == 'occupied')
          PopupMenuItem(
            value: 'payment',
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'payment',
                  size: 18,
                  color: AppTheme.successGreen,
                ),
                SizedBox(width: 2.w),
                const Text('Procesar Pago'),
              ],
            ),
          ),
      ],
    ).then((value) {
      if (value != null) {
        _handleTableAction(table, value);
      }
    });
  }

  void _handleTableAction(Map<String, dynamic> table, String action) {
    Navigator.pop(context); // Close bottom sheet

    switch (action) {
      case 'assign_order':
        Navigator.pushNamed(context, '/menu-management');
        break;
      case 'view_order':
        _showOrderDetails(table);
        break;
      case 'process_payment':
        Navigator.pushNamed(context, '/payment-processing');
        break;
      case 'free_table':
        _freeTable(table);
        break;
      case 'mark_clean':
        _markTableClean(table);
        break;
      case 'add_reservation':
        _showReservationDialog(table);
        break;
      case 'confirm_arrival':
        _confirmReservationArrival(table);
        break;
      case 'cancel_reservation':
        _cancelReservation(table);
        break;
      case 'view_history':
        _showTableHistory(table);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Función "$action" próximamente disponible'),
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }

  void _showOrderDetails(Map<String, dynamic> table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mesa ${table['number']} - Detalles del Pedido'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: ${table['customerName'] ?? 'N/A'}'),
            SizedBox(height: 1.h),
            Text('Hora de llegada: ${table['orderTime'] ?? 'N/A'}'),
            SizedBox(height: 1.h),
            Text(
                'Total actual: \$${(table['orderTotal'] ?? 0.0).toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/menu-management');
            },
            child: const Text('Ver Menú'),
          ),
        ],
      ),
    );
  }

  void _freeTable(Map<String, dynamic> table) {
    setState(() {
      final floorTables = _tablesByFloor[_currentFloorIndex]!;
      final index = floorTables.indexWhere((t) => t['id'] == table['id']);
      if (index != -1) {
        floorTables[index] = {
          ...floorTables[index],
          'status': 'cleaning',
          'customerName': null,
          'orderTime': null,
          'orderTotal': null,
        };
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mesa ${table['number']} marcada para limpieza'),
        backgroundColor: AppTheme.warningOrange,
      ),
    );
  }

  void _markTableClean(Map<String, dynamic> table) {
    setState(() {
      final floorTables = _tablesByFloor[_currentFloorIndex]!;
      final index = floorTables.indexWhere((t) => t['id'] == table['id']);
      if (index != -1) {
        floorTables[index] = {
          ...floorTables[index],
          'status': 'available',
        };
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mesa ${table['number']} disponible'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _showReservationDialog(Map<String, dynamic> table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reservar Mesa ${table['number']}'),
        content: const Text('Función de reservas próximamente disponible'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Reservar'),
          ),
        ],
      ),
    );
  }

  void _confirmReservationArrival(Map<String, dynamic> table) {
    setState(() {
      final floorTables = _tablesByFloor[_currentFloorIndex]!;
      final index = floorTables.indexWhere((t) => t['id'] == table['id']);
      if (index != -1) {
        floorTables[index] = {
          ...floorTables[index],
          'status': 'occupied',
          'orderTime': DateTime.now().toString().substring(11, 16),
        };
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cliente confirmado en Mesa ${table['number']}'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _cancelReservation(Map<String, dynamic> table) {
    setState(() {
      final floorTables = _tablesByFloor[_currentFloorIndex]!;
      final index = floorTables.indexWhere((t) => t['id'] == table['id']);
      if (index != -1) {
        floorTables[index] = {
          ...floorTables[index],
          'status': 'available',
          'hasReservation': false,
          'reservationTime': null,
          'customerName': null,
        };
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reserva cancelada para Mesa ${table['number']}'),
        backgroundColor: AppTheme.warningOrange,
      ),
    );
  }

  void _showTableHistory(Map<String, dynamic> table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Historial Mesa ${table['number']}'),
        content: const Text('Historial de mesa próximamente disponible'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showTableAssignmentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6.w),
              child: Text(
                'Asignar Mesa a Cliente',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Formulario de asignación próximamente disponible'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const CustomAppBar(
        title: 'Gestión de Mesas',
        showNotifications: true,
        notificationCount: 3,
        showSyncStatus: true,
        syncStatus: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    // Floor selector
                    FloorSelector(
                      floors: _floors,
                      currentFloorIndex: _currentFloorIndex,
                      onFloorChanged: (index) {
                        setState(() => _currentFloorIndex = index);
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Table filters
                    TableFilters(
                      selectedFilter: _selectedFilter,
                      onFilterChanged: (filter) {
                        setState(() => _selectedFilter = filter);
                      },
                      statusCounts: _statusCounts,
                    ),

                    SizedBox(height: 2.h),

                    // Floor plan
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: SizedBox(
                        height: 60.h,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() => _currentFloorIndex = index);
                          },
                          itemCount: _floors.length,
                          itemBuilder: (context, index) {
                            return FloorPlanWidget(
                              tables: _currentFloorTables,
                              onTableTap: _onTableTap,
                              onTableLongPress: _onTableLongPress,
                              floorName: _floors[index],
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Status legend
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: TableStatusLegend(
                        statusCounts: _statusCounts,
                      ),
                    ),

                    SizedBox(height: 10.h), // Space for bottom navigation
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTableAssignmentModal,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: CustomIconWidget(
          iconName: 'add',
          size: 24,
          color: colorScheme.onPrimary,
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() => _currentBottomIndex = index);

          // Navigate to different screens based on index
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/menu-management');
              break;
            case 2:
              // Current screen - do nothing
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/sales-reports');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/payment-processing');
              break;
          }
        },
      ),
    );
  }
}