import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab item data for custom tab bar
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? customIcon;
  final String? route;
  final bool showBadge;
  final int badgeCount;
  final bool enabled;

  const TabItem({
    required this.label,
    this.icon,
    this.customIcon,
    this.route,
    this.showBadge = false,
    this.badgeCount = 0,
    this.enabled = true,
  });
}

/// Custom tab bar widget for restaurant sales management application
/// Provides section navigation within screens
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// List of tab items
  final List<TabItem> tabs;

  /// Current selected tab index
  final int currentIndex;

  /// Callback when tab is tapped
  final Function(int)? onTap;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Tab alignment for scrollable tabs
  final TabAlignment tabAlignment;

  /// Custom indicator color
  final Color? indicatorColor;

  /// Custom label color for selected tab
  final Color? labelColor;

  /// Custom label color for unselected tabs
  final Color? unselectedLabelColor;

  /// Custom background color
  final Color? backgroundColor;

  /// Indicator size
  final TabBarIndicatorSize indicatorSize;

  /// Custom indicator weight
  final double indicatorWeight;

  /// Whether to show icons
  final bool showIcons;

  /// Tab controller (optional, for external control)
  final TabController? controller;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    this.onTap,
    this.isScrollable = false,
    this.tabAlignment = TabAlignment.center,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.backgroundColor,
    this.indicatorSize = TabBarIndicatorSize.label,
    this.indicatorWeight = 2.0,
    this.showIcons = true,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          return _buildTab(context, tab, index == currentIndex);
        }).toList(),
        onTap: (index) => _handleTabTap(context, index),
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        indicatorColor: indicatorColor ?? colorScheme.primary,
        labelColor: labelColor ?? colorScheme.primary,
        unselectedLabelColor: unselectedLabelColor ??
            colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorSize: indicatorSize,
        indicatorWeight: indicatorWeight,
        labelStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  /// Builds individual tab with badge support
  Widget _buildTab(BuildContext context, TabItem tab, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget tabContent;

    if (showIcons && (tab.icon != null || tab.customIcon != null)) {
      // Tab with icon and label
      tabContent = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              tab.customIcon ??
                  Icon(
                    tab.icon,
                    size: 20,
                  ),
              // Badge
              if (tab.showBadge && tab.badgeCount > 0)
                Positioned(
                  right: -8,
                  top: -8,
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
                      tab.badgeCount > 99 ? '99+' : tab.badgeCount.toString(),
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
          const SizedBox(height: 4),
          Text(
            tab.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else {
      // Text-only tab
      tabContent = Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            tab.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Badge
          if (tab.showBadge && tab.badgeCount > 0)
            Positioned(
              right: -16,
              top: -8,
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
                  tab.badgeCount > 99 ? '99+' : tab.badgeCount.toString(),
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
      );
    }

    return Tab(
      child: Opacity(
        opacity: tab.enabled ? 1.0 : 0.5,
        child: tabContent,
      ),
    );
  }

  /// Handles tab tap
  void _handleTabTap(BuildContext context, int index) {
    final tab = tabs[index];

    if (!tab.enabled) return;

    // Call custom onTap if provided
    if (onTap != null) {
      onTap!(index);
      return;
    }

    // Default navigation behavior
    if (tab.route != null && index != currentIndex) {
      Navigator.pushNamed(context, tab.route!);
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(showIcons ? 72.0 : 48.0);
}

/// Specialized tab bar for menu management with category tabs
class CustomMenuTabBar extends CustomTabBar {
  CustomMenuTabBar({
    super.key,
    super.currentIndex = 0,
    super.onTap,
    super.controller,
  }) : super(
          tabs: const [
            TabItem(
              label: 'All Items',
              icon: Icons.restaurant_menu,
            ),
            TabItem(
              label: 'Appetizers',
              icon: Icons.local_dining,
            ),
            TabItem(
              label: 'Main Course',
              icon: Icons.dinner_dining,
            ),
            TabItem(
              label: 'Desserts',
              icon: Icons.cake,
            ),
            TabItem(
              label: 'Beverages',
              icon: Icons.local_cafe,
            ),
          ],
          isScrollable: true,
          tabAlignment: TabAlignment.start,
        );
}

/// Specialized tab bar for sales reports with time period tabs
class CustomReportsTabBar extends CustomTabBar {
  CustomReportsTabBar({
    super.key,
    super.currentIndex = 0,
    super.onTap,
    super.controller,
  }) : super(
          tabs: const [
            TabItem(
              label: 'Today',
              icon: Icons.today,
            ),
            TabItem(
              label: 'Week',
              icon: Icons.date_range,
            ),
            TabItem(
              label: 'Month',
              icon: Icons.calendar_month,
            ),
            TabItem(
              label: 'Custom',
              icon: Icons.tune,
            ),
          ],
          isScrollable: false,
          showIcons: false,
        );
}

/// Specialized tab bar for table management with status tabs
class CustomTableTabBar extends CustomTabBar {
  CustomTableTabBar({
    super.key,
    super.currentIndex = 0,
    super.onTap,
    super.controller,
    int availableTables = 0,
    int occupiedTables = 0,
    int reservedTables = 0,
  }) : super(
          tabs: [
            const TabItem(
              label: 'All Tables',
              icon: Icons.table_restaurant,
            ),
            TabItem(
              label: 'Available',
              icon: Icons.check_circle_outline,
              showBadge: availableTables > 0,
              badgeCount: availableTables,
            ),
            TabItem(
              label: 'Occupied',
              icon: Icons.people,
              showBadge: occupiedTables > 0,
              badgeCount: occupiedTables,
            ),
            TabItem(
              label: 'Reserved',
              icon: Icons.schedule,
              showBadge: reservedTables > 0,
              badgeCount: reservedTables,
            ),
          ],
          isScrollable: true,
          tabAlignment: TabAlignment.start,
        );
}

/// Specialized tab bar for order status tracking
class CustomOrderStatusTabBar extends CustomTabBar {
  CustomOrderStatusTabBar({
    super.key,
    super.currentIndex = 0,
    super.onTap,
    super.controller,
    int pendingOrders = 0,
    int preparingOrders = 0,
    int readyOrders = 0,
  }) : super(
          tabs: [
            TabItem(
              label: 'Pending',
              icon: Icons.pending_actions,
              showBadge: pendingOrders > 0,
              badgeCount: pendingOrders,
            ),
            TabItem(
              label: 'Preparing',
              icon: Icons.restaurant,
              showBadge: preparingOrders > 0,
              badgeCount: preparingOrders,
            ),
            TabItem(
              label: 'Ready',
              icon: Icons.check_circle,
              showBadge: readyOrders > 0,
              badgeCount: readyOrders,
            ),
            const TabItem(
              label: 'Completed',
              icon: Icons.done_all,
            ),
          ],
          isScrollable: false,
          indicatorSize: TabBarIndicatorSize.tab,
        );
}

/// Specialized tab bar for payment methods
class CustomPaymentTabBar extends CustomTabBar {
  CustomPaymentTabBar({
    super.key,
    super.currentIndex = 0,
    super.onTap,
    super.controller,
  }) : super(
          tabs: const [
            TabItem(
              label: 'Cash',
              icon: Icons.payments,
            ),
            TabItem(
              label: 'Card',
              icon: Icons.credit_card,
            ),
            TabItem(
              label: 'Digital',
              icon: Icons.qr_code,
            ),
            TabItem(
              label: 'Split',
              icon: Icons.call_split,
            ),
          ],
          isScrollable: false,
          showIcons: true,
        );
}
