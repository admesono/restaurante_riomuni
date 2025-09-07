import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './table_widget.dart';
import 'table_widget.dart';

class FloorPlanWidget extends StatefulWidget {
  final List<Map<String, dynamic>> tables;
  final Function(Map<String, dynamic>) onTableTap;
  final Function(Map<String, dynamic>) onTableLongPress;
  final String floorName;

  const FloorPlanWidget({
    super.key,
    required this.tables,
    required this.onTableTap,
    required this.onTableLongPress,
    required this.floorName,
  });

  @override
  State<FloorPlanWidget> createState() => _FloorPlanWidgetState();
}

class _FloorPlanWidgetState extends State<FloorPlanWidget> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 60.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InteractiveViewer(
          transformationController: _transformationController,
          boundaryMargin: EdgeInsets.all(4.w),
          minScale: 0.5,
          maxScale: 3.0,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              image: DecorationImage(
                image: const AssetImage('assets/images/no-image.jpg'),
                fit: BoxFit.cover,
                opacity: 0.1,
                onError: (exception, stackTrace) {},
              ),
            ),
            child: Stack(
              children: [
                // Floor plan background elements
                _buildFloorElements(context),

                // Tables
                ...widget.tables
                    .map((table) => TableWidget(
                          table: table,
                          onTap: () => widget.onTableTap(table),
                          onLongPress: () => widget.onTableLongPress(table),
                        ))
                    .toList(),

                // Floor name label
                Positioned(
                  top: 2.h,
                  left: 4.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.floorName,
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),

                // Reset zoom button
                Positioned(
                  bottom: 2.h,
                  right: 4.w,
                  child: FloatingActionButton.small(
                    onPressed: _resetZoom,
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    child: CustomIconWidget(
                      iconName: 'zoom_out_map',
                      size: 20,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloorElements(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        // Kitchen area
        Positioned(
          top: 5.h,
          right: 5.w,
          child: Container(
            width: 20.w,
            height: 15.h,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.secondary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'restaurant',
                    size: 20,
                    color: colorScheme.secondary,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Cocina',
                    style: GoogleFonts.roboto(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bar area
        Positioned(
          bottom: 5.h,
          left: 5.w,
          child: Container(
            width: 25.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.tertiary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'local_bar',
                    size: 18,
                    color: colorScheme.tertiary,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Bar',
                    style: GoogleFonts.roboto(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Entrance
        Positioned(
          bottom: 0,
          left: 40.w,
          child: Container(
            width: 20.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                'Entrada',
                style: GoogleFonts.roboto(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }
}