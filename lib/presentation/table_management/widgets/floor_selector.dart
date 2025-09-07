import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FloorSelector extends StatelessWidget {
  final List<String> floors;
  final int currentFloorIndex;
  final Function(int) onFloorChanged;

  const FloorSelector({
    super.key,
    required this.floors,
    required this.currentFloorIndex,
    required this.onFloorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (floors.length <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'layers',
            size: 20,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: floors.length,
              separatorBuilder: (context, index) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final isSelected = index == currentFloorIndex;
                return GestureDetector(
                  onTap: () => onFloorChanged(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        floors[index],
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}