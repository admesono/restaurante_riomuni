import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class MenuItemCard extends StatelessWidget {
  final Map<String, dynamic> menuItem;
  final VoidCallback onTap;
  final VoidCallback? onToggleAvailability;
  final VoidCallback? onLongPress;
  final VoidCallback? onEditSwipe;
  final VoidCallback? onDeleteSwipe;

  const MenuItemCard({
    super.key,
    required this.menuItem,
    required this.onTap,
    this.onToggleAvailability,
    this.onLongPress,
    this.onEditSwipe,
    this.onDeleteSwipe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAvailable = (menuItem["available"] as bool?) ?? true;
    final isSpecialPrice = (menuItem["hasSpecialPrice"] as bool?) ?? false;
    final originalPrice = (menuItem["originalPrice"] as double?) ?? 0.0;

    return Dismissible(
      key: Key(menuItem["id"].toString()),
      background: _buildSwipeBackground(
        context,
        colorScheme.secondary,
        Icons.edit,
        'Editar',
        Alignment.centerLeft,
      ),
      secondaryBackground: _buildSwipeBackground(
        context,
        colorScheme.error,
        Icons.delete,
        'Eliminar',
        Alignment.centerRight,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEditSwipe?.call();
        } else if (direction == DismissDirection.endToStart) {
          onDeleteSwipe?.call();
        }
        return false; // Don't actually dismiss
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isAvailable
                  ? colorScheme.surface
                  : colorScheme.surface.withValues(alpha: 0.7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: CustomImageWidget(
                        imageUrl: (menuItem["image"] as String?) ??
                            "https://images.unsplash.com/photo-1546833999-b9f581a1996d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
                        width: double.infinity,
                        height: 20.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Availability overlay
                    if (!isAvailable)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.error,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'No Disponible',
                                style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Special price badge
                    if (isSpecialPrice)
                      Positioned(
                        top: 1.h,
                        left: 3.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Oferta',
                            style: GoogleFonts.roboto(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    // Availability toggle
                    Positioned(
                      top: 1.h,
                      right: 3.w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Switch(
                          value: isAvailable,
                          onChanged: (value) => onToggleAvailability?.call(),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                ),
                // Content section
                Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and category
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              (menuItem["name"] as String?) ??
                                  'Nombre del Plato',
                              style: GoogleFonts.openSans(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              (menuItem["category"] as String?) ?? 'Categoría',
                              style: GoogleFonts.roboto(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      // Description
                      Text(
                        (menuItem["description"] as String?) ??
                            'Descripción del plato con ingredientes principales.',
                        style: GoogleFonts.openSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.5.h),
                      // Price section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isSpecialPrice) ...[
                                Text(
                                  '\$${originalPrice.toStringAsFixed(2)}',
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                              ],
                              Text(
                                '\$${((menuItem["price"] as double?) ?? 0.0).toStringAsFixed(2)}',
                                style: GoogleFonts.robotoMono(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSpecialPrice
                                      ? colorScheme.tertiary
                                      : colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          // Quick actions
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => onEditSwipe?.call(),
                                icon: CustomIconWidget(
                                  iconName: 'edit',
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                                tooltip: 'Editar',
                              ),
                              IconButton(
                                onPressed: onLongPress,
                                icon: CustomIconWidget(
                                  iconName: 'more_vert',
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  size: 20,
                                ),
                                tooltip: 'Más opciones',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(
    BuildContext context,
    Color color,
    IconData icon,
    String label,
    Alignment alignment,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}