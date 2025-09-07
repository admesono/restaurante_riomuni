import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class MenuContextMenu extends StatelessWidget {
  final Map<String, dynamic> menuItem;
  final VoidCallback onDuplicate;
  final VoidCallback onArchive;
  final VoidCallback onViewAnalytics;
  final VoidCallback onSetSpecialPrice;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MenuContextMenu({
    super.key,
    required this.menuItem,
    required this.onDuplicate,
    required this.onArchive,
    required this.onViewAnalytics,
    required this.onSetSpecialPrice,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: (menuItem["image"] as String?) ??
                        "https://images.unsplash.com/photo-1546833999-b9f581a1996d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (menuItem["name"] as String?) ?? 'Nombre del Plato',
                        style: GoogleFonts.openSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '\$${((menuItem["price"] as double?) ?? 0.0).toStringAsFixed(2)}',
                        style: GoogleFonts.robotoMono(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Menu options
          _buildMenuItem(
            context,
            'Editar Plato',
            'edit',
            colorScheme.primary,
            onEdit,
          ),
          _buildMenuItem(
            context,
            'Duplicar Plato',
            'content_copy',
            colorScheme.secondary,
            onDuplicate,
          ),
          _buildMenuItem(
            context,
            'Precio Especial',
            'local_offer',
            colorScheme.tertiary,
            onSetSpecialPrice,
          ),
          _buildMenuItem(
            context,
            'Ver Analíticas',
            'analytics',
            Colors.blue,
            onViewAnalytics,
          ),
          _buildMenuItem(
            context,
            'Archivar',
            'archive',
            Colors.orange,
            onArchive,
          ),
          _buildMenuItem(
            context,
            'Eliminar',
            'delete',
            colorScheme.error,
            onDelete,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    String iconName,
    Color color,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 18,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color:
                      isDestructive ? colorScheme.error : colorScheme.onSurface,
                ),
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

void showMenuContextMenu(
  BuildContext context,
  Map<String, dynamic> menuItem, {
  required VoidCallback onDuplicate,
  required VoidCallback onArchive,
  required VoidCallback onViewAnalytics,
  required VoidCallback onSetSpecialPrice,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.all(4.w),
      child: MenuContextMenu(
        menuItem: menuItem,
        onDuplicate: onDuplicate,
        onArchive: onArchive,
        onViewAnalytics: onViewAnalytics,
        onSetSpecialPrice: onSetSpecialPrice,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    ),
  );
}