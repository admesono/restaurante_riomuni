import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyMenuState extends StatelessWidget {
  final String category;
  final VoidCallback onAddItem;
  final bool isSearchResult;
  final String? searchQuery;

  const EmptyMenuState({
    super.key,
    required this.category,
    required this.onAddItem,
    this.isSearchResult = false,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: isSearchResult ? 'search_off' : 'restaurant_menu',
                  color: colorScheme.primary.withValues(alpha: 0.6),
                  size: 60,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            // Title
            Text(
              isSearchResult
                  ? 'Sin Resultados'
                  : category == 'Todos'
                      ? 'Menú Vacío'
                      : 'Sin Platos en $category',
              style: GoogleFonts.roboto(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            // Description
            Text(
              isSearchResult
                  ? 'No encontramos platos que coincidan con "${searchQuery ?? ''}".\nIntenta con otros términos de búsqueda.'
                  : category == 'Todos'
                      ? 'Aún no has agregado ningún plato a tu menú.\n¡Comienza creando tu primer plato!'
                      : 'No hay platos en la categoría $category.\n¡Agrega el primer plato de esta categoría!',
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            // Action button
            if (!isSearchResult) ...[
              ElevatedButton.icon(
                onPressed: onAddItem,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text(
                  category == 'Todos'
                      ? 'Agregar Primer Plato'
                      : 'Agregar Plato a $category',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),
            ] else ...[
              // Search suggestions
              OutlinedButton.icon(
                onPressed: () {
                  // Clear search or show suggestions
                },
                icon: CustomIconWidget(
                  iconName: 'clear',
                  color: colorScheme.primary,
                  size: 18,
                ),
                label: Text(
                  'Limpiar Búsqueda',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            SizedBox(height: 2.h),
            // Suggestions for empty category
            if (!isSearchResult && category != 'Todos')
              _buildCategorySuggestions(context, category),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySuggestions(BuildContext context, String category) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final suggestions = _getSuggestionsForCategory(category);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'lightbulb_outline',
                color: colorScheme.tertiary,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'Sugerencias para $category',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: suggestions
                .map((suggestion) => GestureDetector(
                      onTap: () {
                        // Pre-fill new item form with suggestion
                        onAddItem();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          suggestion,
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  List<String> _getSuggestionsForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'aperitivos':
        return [
          'Nachos',
          'Alitas de Pollo',
          'Quesadillas',
          'Guacamole',
          'Empanadas'
        ];
      case 'platos principales':
        return ['Paella', 'Bistec', 'Pollo Asado', 'Pasta Carbonara', 'Tacos'];
      case 'postres':
        return [
          'Flan',
          'Tiramisu',
          'Helado',
          'Tarta de Chocolate',
          'Crema Catalana'
        ];
      case 'bebidas':
        return ['Agua', 'Refrescos', 'Cerveza', 'Vino', 'Café', 'Jugos'];
      default:
        return ['Plato Especial', 'Plato del Día', 'Especialidad de la Casa'];
    }
  }
}