import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MenuSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String) onSearchChanged;
  final VoidCallback? onFilterTap;
  final bool showFilter;
  final TextEditingController? controller;

  const MenuSearchBar({
    super.key,
    this.hintText = 'Buscar platos, ingredientes...',
    required this.onSearchChanged,
    this.onFilterTap,
    this.showFilter = true,
    this.controller,
  });

  @override
  State<MenuSearchBar> createState() => _MenuSearchBarState();
}

class _MenuSearchBarState extends State<MenuSearchBar> {
  late TextEditingController _controller;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text;
    setState(() {
      _isSearchActive = query.isNotEmpty;
    });
    widget.onSearchChanged(query);
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isSearchActive
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.3),
                  width: _isSearchActive ? 2 : 1,
                ),
                boxShadow: _isSearchActive
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: TextField(
                controller: _controller,
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: _isSearchActive
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ),
                  suffixIcon: _isSearchActive
                      ? IconButton(
                          onPressed: _clearSearch,
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            size: 20,
                          ),
                          tooltip: 'Limpiar búsqueda',
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) => widget.onSearchChanged(value),
              ),
            ),
          ),
          if (widget.showFilter) ...[
            SizedBox(width: 3.w),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: widget.onFilterTap ??
                    () {
                      _showFilterBottomSheet(context);
                    },
                icon: CustomIconWidget(
                  iconName: 'tune',
                  color: colorScheme.primary,
                  size: 22,
                ),
                tooltip: 'Filtros',
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 12.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  // Title
                  Text(
                    'Filtros de Búsqueda',
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  // Filter options
                  _buildFilterSection(
                    context,
                    'Categoría',
                    [
                      'Todas',
                      'Aperitivos',
                      'Platos Principales',
                      'Postres',
                      'Bebidas'
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildFilterSection(
                    context,
                    'Disponibilidad',
                    ['Todos', 'Disponibles', 'No Disponibles'],
                  ),
                  SizedBox(height: 2.h),
                  _buildFilterSection(
                    context,
                    'Precio',
                    ['Todos', 'Menos de \$10', '\$10 - \$20', 'Más de \$20'],
                  ),
                  SizedBox(height: 4.h),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Limpiar'),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Aplicar Filtros'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(
      BuildContext context, String title, List<String> options) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options
              .map((option) => FilterChip(
                    label: Text(option),
                    selected: option == options.first,
                    onSelected: (selected) {
                      // Handle filter selection
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}