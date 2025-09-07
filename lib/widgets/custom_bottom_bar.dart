import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data for bottom navigation bar
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;
  final bool showBadge;
  final int badgeCount;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
    this.showBadge = false,
    this.badgeCount = 0,
  });
}

/// Custom bottom navigation bar for restaurant sales management application
/// Provides quick access to main application sections
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final Function(int)? onTap;

  /// Custom navigation items (uses default restaurant items if null)
  final List<BottomNavItem>? items;

  /// Whether to show labels on navigation items
  final bool showLabels;

  /// Navigation bar type
  final BottomNavigationBarType type;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected item color
  final Color? selectedItemColor;

  /// Custom unselected item color
  final Color? unselectedItemColor;

  /// Custom elevation
  final double elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.items,
    this.showLabels = true,
    this.type = BottomNavigationBarType.fixed,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8.0,
  });

  /// Default navigation items for restaurant management
  static const List<BottomNavItem> _defaultItems = [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/dashboard',
    ),
    BottomNavItem(
      icon: Icons.restaurant_menu_outlined,
      activeIcon: Icons.restaurant_menu,
      label: 'Menu',
      route: '/menu-management',
    ),
    BottomNavItem(
      icon: Icons.table_restaurant_outlined,
      activeIcon: Icons.table_restaurant,
      label: 'Tables',
      route: '/table-management',
    ),
    BottomNavItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: 'Reports',
      route: '/sales-reports',
    ),
    BottomNavItem(
      icon: Icons.payment_outlined,
      activeIcon: Icons.payment,
      label: 'Payment',
      route: '/payment-processing',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final navigationItems = items ?? _defaultItems;

    // Ensure currentIndex is within bounds
    final safeCurrentIndex = currentIndex.clamp(0, navigationItems.length - 1);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ??
            theme.bottomNavigationBarTheme.backgroundColor ??
            colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: kBottomNavigationBarHeight + (showLabels ? 8 : 0),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == safeCurrentIndex;

              return Expanded(
                child: _buildNavigationItem(
                  context,
                  item,
                  isSelected,
                  index,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Builds individual navigation item with badge support
  Widget _buildNavigationItem(
    BuildContext context,
    BottomNavItem item,
    bool isSelected,
    int index,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final itemColor = isSelected
        ? (selectedItemColor ??
            theme.bottomNavigationBarTheme.selectedItemColor ??
            colorScheme.primary)
        : (unselectedItemColor ??
            theme.bottomNavigationBarTheme.unselectedItemColor ??
            colorScheme.onSurface.withValues(alpha: 0.6));

    return InkWell(
      onTap: () => _handleItemTap(context, index, item.route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(4),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: itemColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: Icon(
                    isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                    color: itemColor,
                    size: 24,
                  ),
                ),
                // Badge
                if (item.showBadge && item.badgeCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: backgroundColor ?? colorScheme.surface,
                          width: 1,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        item.badgeCount > 99
                            ? '99+'
                            : item.badgeCount.toString(),
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            // Label
            if (showLabels) ...[
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.roboto(
                  fontSize: isSelected ? 12 : 11,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: itemColor,
                  letterSpacing: 0.4,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Handles navigation item tap
  void _handleItemTap(BuildContext context, int index, String route) {
    // Call custom onTap if provided
    if (onTap != null) {
      onTap!(index);
      return;
    }

    // Default navigation behavior
    if (index != currentIndex) {
      // Use pushReplacementNamed to replace current route
      Navigator.pushReplacementNamed(context, route);
    }
  }
}

/// Specialized bottom bar for order management with contextual actions
class CustomOrderBottomBar extends StatelessWidget {
  /// Current order status
  final String orderStatus;

  /// Callback for primary action (varies by status)
  final VoidCallback? onPrimaryAction;

  /// Callback for secondary action
  final VoidCallback? onSecondaryAction;

  /// Whether to show the floating action button
  final bool showFloatingAction;

  /// Floating action button callback
  final VoidCallback? onFloatingAction;

  const CustomOrderBottomBar({
    super.key,
    required this.orderStatus,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.showFloatingAction = true,
    this.onFloatingAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Secondary action button
              Expanded(
                child: OutlinedButton(
                  onPressed: onSecondaryAction ??
                      () {
                        Navigator.pop(context);
                      },
                  child: Text(_getSecondaryActionText()),
                ),
              ),
              const SizedBox(width: 16),
              // Primary action button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onPrimaryAction ??
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${_getPrimaryActionText()} feature coming soon'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                  child: Text(_getPrimaryActionText()),
                ),
              ),
              // Floating action button
              if (showFloatingAction) ...[
                const SizedBox(width: 16),
                FloatingActionButton.small(
                  onPressed: onFloatingAction ??
                      () {
                        Navigator.pushNamed(context, '/payment-processing');
                      },
                  child: const Icon(Icons.payment),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Gets primary action text based on order status
  String _getPrimaryActionText() {
    switch (orderStatus.toLowerCase()) {
      case 'pending':
        return 'Confirm Order';
      case 'confirmed':
        return 'Start Preparation';
      case 'preparing':
        return 'Mark Ready';
      case 'ready':
        return 'Serve Order';
      case 'served':
        return 'Complete Order';
      default:
        return 'Update Status';
    }
  }

  /// Gets secondary action text
  String _getSecondaryActionText() {
    return 'Cancel';
  }
}

/// Specialized bottom bar for payment processing
class CustomPaymentBottomBar extends StatelessWidget {
  /// Total amount to be paid
  final double totalAmount;

  /// Selected payment method
  final String paymentMethod;

  /// Callback for payment processing
  final VoidCallback? onProcessPayment;

  /// Callback for payment method change
  final VoidCallback? onChangePaymentMethod;

  const CustomPaymentBottomBar({
    super.key,
    required this.totalAmount,
    required this.paymentMethod,
    this.onProcessPayment,
    this.onChangePaymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Payment summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      Text(
                        '\$${totalAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.robotoMono(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Payment Method',
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      GestureDetector(
                        onTap: onChangePaymentMethod,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              paymentMethod,
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Process payment button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onProcessPayment ??
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Processing payment...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Process Payment - \$${totalAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
}
