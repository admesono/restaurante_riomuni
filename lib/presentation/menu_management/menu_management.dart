import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_menu_state.dart';
import './widgets/menu_item_card.dart';
import './widgets/menu_search_bar.dart';
import 'widgets/empty_menu_state.dart';
import 'widgets/menu_category_chip.dart';
import 'widgets/menu_context_menu.dart';
import 'widgets/menu_item_card.dart';
import 'widgets/menu_search_bar.dart';

class MenuManagement extends StatefulWidget {
  const MenuManagement({super.key});

  @override
  State<MenuManagement> createState() => _MenuManagementState();
}

class _MenuManagementState extends State<MenuManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Mock data for menu items
  final List<Map<String, dynamic>> _allMenuItems = [
    {
      "id": 1,
      "name": "Paella Valenciana",
      "description":
          "Arroz tradicional con pollo, conejo, judías verdes, garrofón y azafrán. Especialidad de la casa.",
      "price": 18.50,
      "originalPrice": 22.00,
      "category": "Platos Principales",
      "image":
          "https://images.unsplash.com/photo-1534080564583-6be75777b70a?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "available": true,
      "hasSpecialPrice": true,
      "ingredients": ["arroz", "pollo", "conejo", "judías", "azafrán"],
      "preparationTime": 25,
      "calories": 450,
    },
    {
      "id": 2,
      "name": "Gazpacho Andaluz",
      "description":
          "Sopa fría tradicional con tomate, pepino, pimiento y aceite de oliva virgen extra.",
      "price": 8.90,
      "category": "Aperitivos",
      "image":
          "https://images.unsplash.com/photo-1571197119282-7c4a2b8b8c8a?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "available": true,
      "hasSpecialPrice": false,
      "ingredients": ["tomate", "pepino", "pimiento", "aceite de oliva"],
      "preparationTime": 5,
      "calories": 120,
    },
    {
      "id": 3,
      "name": "Pulpo a la Gallega",
      "description":
          "Pulpo cocido con patatas, pimentón dulce y aceite de oliva. Servido caliente.",
      "price": 16.75,
      "category": "Platos Principales",
      "image":
          "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "available": false,
      "hasSpecialPrice": false,
      "ingredients": ["pulpo", "patatas", "pimentón", "aceite de oliva"],
      "preparationTime": 20,
      "calories": 320,
    },
    {
      "id": 4,
      "name": "Crema Catalana",
      "description":
          "Postre tradicional catalán con crema pastelera y azúcar caramelizado por encima.",
      "price": 6.50,
      "category": "Postres",
      "image":
          "https://images.unsplash.com/photo-1551024506-0bccd828d307?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "available": true,
      "hasSpecialPrice": false,
      "ingredients": ["leche", "huevos", "azúcar", "canela"],
      "preparationTime": 10,
      "calories": 280,
    },
    {
      "id": 5,
      "name": "Sangría de la Casa",
      "description":
          "Bebida refrescante con vino tinto, frutas frescas y un toque de brandy español.",
      "price": 12.00,
      "originalPrice": 15.00,
      "category": "Bebidas",
      "image":
          "https://images.unsplash.com/photo-1571104508999-893933ded431?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "available": true,
      "hasSpecialPrice": true,
      "ingredients": ["vino tinto", "frutas", "brandy", "azúcar"],
      "preparationTime": 5,
      "calories": 180,
    },
    {
      "id": 6,
      "name": "Jamón Ibérico",
      "description":
          "Jamón ibérico de bellota cortado a mano, servido con pan tostado y tomate rallado.",
      "price": 24.90,
      "category": "Aperitivos",
      "image":
          "https://images.unsplash.com/photo-1549611012-65c3c20906c9?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "available": true,
      "hasSpecialPrice": false,
      "ingredients": ["jamón ibérico", "pan", "tomate", "aceite"],
      "preparationTime": 5,
      "calories": 350,
    },
  ];

  final List<String> _categories = [
    'Todos',
    'Aperitivos',
    'Platos Principales',
    'Postres',
    'Bebidas',
  ];

  List<Map<String, dynamic>> _filteredItems = [];
  int _currentBottomNavIndex = 1; // Menu tab is active

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _filteredItems = List.from(_allMenuItems);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategory = _categories[_tabController.index];
      });
      _filterItems();
    }
  }

  void _filterItems() {
    setState(() {
      _filteredItems = _allMenuItems.where((item) {
        final matchesCategory = _selectedCategory == 'Todos' ||
            (item["category"] as String) == _selectedCategory;

        final matchesSearch = _searchQuery.isEmpty ||
            (item["name"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (item["description"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            ((item["ingredients"] as List<dynamic>?)?.any((ingredient) =>
                    ingredient
                        .toString()
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase())) ??
                false);

        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
    });
    _filterItems();
  }

  void _onCategorySelected(String category) {
    final index = _categories.indexOf(category);
    if (index != -1) {
      _tabController.animateTo(index);
    }
  }

  Future<void> _refreshMenu() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menú sincronizado correctamente'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleItemAvailability(Map<String, dynamic> item) {
    setState(() {
      item["available"] = !(item["available"] as bool);
    });

    final status = (item["available"] as bool) ? 'disponible' : 'no disponible';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item["name"]} marcado como $status'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showItemContextMenu(Map<String, dynamic> item) {
    showMenuContextMenu(
      context,
      item,
      onDuplicate: () => _duplicateItem(item),
      onArchive: () => _archiveItem(item),
      onViewAnalytics: () => _viewItemAnalytics(item),
      onSetSpecialPrice: () => _setSpecialPrice(item),
      onEdit: () => _editItem(item),
      onDelete: () => _deleteItem(item),
    );
  }

  void _duplicateItem(Map<String, dynamic> item) {
    final newItem = Map<String, dynamic>.from(item);
    newItem["id"] = _allMenuItems.length + 1;
    newItem["name"] = "${item["name"]} (Copia)";

    setState(() {
      _allMenuItems.add(newItem);
    });
    _filterItems();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item["name"]} duplicado correctamente'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _archiveItem(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item["name"]} archivado'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            // Restore item
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _viewItemAnalytics(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mostrando analíticas de ${item["name"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _setSpecialPrice(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => _buildSpecialPriceDialog(item),
    );
  }

  void _editItem(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editando ${item["name"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteItem(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => _buildDeleteConfirmationDialog(item),
    );
  }

  void _addNewItem() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo formulario para nuevo plato'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  int _getCategoryItemCount(String category) {
    if (category == 'Todos') return _allMenuItems.length;
    return _allMenuItems
        .where((item) => (item["category"] as String) == category)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Gestión de Menú',
          style: GoogleFonts.roboto(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: _refreshMenu,
            icon: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'sync',
                    color: colorScheme.onPrimary,
                    size: 24,
                  ),
            tooltip: 'Sincronizar menú',
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Configuración de categorías'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: colorScheme.onPrimary,
              size: 24,
            ),
            tooltip: 'Configuración',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: colorScheme.onPrimary,
          labelColor: colorScheme.onPrimary,
          unselectedLabelColor: colorScheme.onPrimary.withValues(alpha: 0.7),
          labelStyle: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          tabs: _categories
              .map((category) => Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(category),
                        if (_getCategoryItemCount(category) > 0) ...[
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.5.w, vertical: 0.3.h),
                            decoration: BoxDecoration(
                              color:
                                  colorScheme.onPrimary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _getCategoryItemCount(category).toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          MenuSearchBar(
            controller: _searchController,
            onSearchChanged: _onSearchChanged,
            onFilterTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filtros avanzados'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshMenu,
              child: _filteredItems.isEmpty
                  ? EmptyMenuState(
                      category: _selectedCategory,
                      onAddItem: _addNewItem,
                      isSearchResult: _isSearching,
                      searchQuery: _searchQuery,
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 10.h),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return MenuItemCard(
                          menuItem: item,
                          onTap: () => _editItem(item),
                          onToggleAvailability: () =>
                              _toggleItemAvailability(item),
                          onLongPress: () => _showItemContextMenu(item),
                          onEditSwipe: () => _editItem(item),
                          onDeleteSwipe: () => _deleteItem(item),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewItem,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'add',
          color: colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Agregar Plato',
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
        selectedLabelStyle: GoogleFonts.roboto(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case 1:
              // Already on menu management
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/table-management');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/sales-reports');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/payment-processing');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentBottomNavIndex == 0
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'restaurant_menu',
              color: _currentBottomNavIndex == 1
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'Menú',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'table_restaurant',
              color: _currentBottomNavIndex == 2
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'Mesas',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: _currentBottomNavIndex == 3
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'Reportes',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'payment',
              color: _currentBottomNavIndex == 4
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'Pagos',
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialPriceDialog(Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final TextEditingController priceController = TextEditingController();

    return AlertDialog(
      title: Text(
        'Precio Especial',
        style: GoogleFonts.roboto(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plato: ${item["name"]}',
            style: GoogleFonts.openSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Precio actual: \$${((item["price"] as double?) ?? 0.0).toStringAsFixed(2)}',
            style: GoogleFonts.robotoMono(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Nuevo precio especial',
              prefixText: '\$ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Precio especial aplicado a ${item["name"]}'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: Text('Aplicar'),
        ),
      ],
    );
  }

  Widget _buildDeleteConfirmationDialog(Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(
        'Eliminar Plato',
        style: GoogleFonts.roboto(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: colorScheme.error,
        ),
      ),
      content: Text(
        '¿Estás seguro de que deseas eliminar "${item["name"]}" del menú?\n\nEsta acción no se puede deshacer.',
        style: GoogleFonts.openSans(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _allMenuItems
                  .removeWhere((menuItem) => menuItem["id"] == item["id"]);
            });
            _filterItems();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${item["name"]} eliminado del menú'),
                action: SnackBarAction(
                  label: 'Deshacer',
                  onPressed: () {
                    setState(() {
                      _allMenuItems.add(item);
                    });
                    _filterItems();
                  },
                ),
                duration: const Duration(seconds: 4),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          child: Text('Eliminar'),
        ),
      ],
    );
  }
}