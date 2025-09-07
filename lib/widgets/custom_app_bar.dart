import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar widget for restaurant sales management application
/// Provides consistent navigation and branding across all screens
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (defaults to true when there's a previous route)
  final bool showBackButton;

  /// Custom leading widget (overrides back button if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to show the notification icon with badge
  final bool showNotifications;

  /// Number of unread notifications (shows badge if > 0)
  final int notificationCount;

  /// Callback for notification icon tap
  final VoidCallback? onNotificationTap;

  /// Whether to show the sync status indicator
  final bool showSyncStatus;

  /// Sync status (true = synced, false = pending, null = error)
  final bool? syncStatus;

  /// Callback for sync status tap
  final VoidCallback? onSyncTap;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom background color (uses theme primary if null)
  final Color? backgroundColor;

  /// Custom foreground color (uses theme onPrimary if null)
  final Color? foregroundColor;

  /// Custom elevation (uses theme default if null)
  final double? elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.leading,
    this.actions,
    this.showNotifications = false,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.showSyncStatus = false,
    this.syncStatus,
    this.onSyncTap,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build actions list
    final List<Widget> appBarActions = [];

    // Add sync status indicator if enabled
    if (showSyncStatus) {
      appBarActions.add(_buildSyncStatusIcon(context));
    }

    // Add notification icon if enabled
    if (showNotifications) {
      appBarActions.add(_buildNotificationIcon(context));
    }

    // Add custom actions
    if (actions != null) {
      appBarActions.addAll(actions!);
    }

    // Add spacing at the end
    if (appBarActions.isNotEmpty) {
      appBarActions.add(const SizedBox(width: 8));
    }

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: foregroundColor ?? colorScheme.onPrimary,
          letterSpacing: 0.15,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.primary,
      foregroundColor: foregroundColor ?? colorScheme.onPrimary,
      elevation: elevation ?? 2.0,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      leading: _buildLeading(context),
      actions: appBarActions.isNotEmpty ? appBarActions : null,
      automaticallyImplyLeading: false,
    );
  }

  /// Builds the leading widget (back button or custom leading)
  Widget? _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading;
    }

    if (showBackButton && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }

    return null;
  }

  /// Builds the sync status icon with appropriate color and icon
  Widget _buildSyncStatusIcon(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData iconData;
    Color iconColor;
    String tooltip;

    switch (syncStatus) {
      case true:
        iconData = Icons.cloud_done;
        iconColor = Colors.green;
        tooltip = 'Data synced';
        break;
      case false:
        iconData = Icons.cloud_sync;
        iconColor = Colors.orange;
        tooltip = 'Syncing data...';
        break;
      case null:
      default:
        iconData = Icons.cloud_off;
        iconColor = Colors.red;
        tooltip = 'Sync error';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        icon: Icon(
          iconData,
          color: iconColor,
          size: 20,
        ),
        onPressed: onSyncTap,
        tooltip: tooltip,
      ),
    );
  }

  /// Builds the notification icon with badge if there are unread notifications
  Widget _buildNotificationIcon(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: onNotificationTap ??
                () {
                  // Default navigation to notifications or show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications feature coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
            tooltip: 'Notifications',
          ),
          if (notificationCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colorScheme.primary,
                    width: 1,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  notificationCount > 99 ? '99+' : notificationCount.toString(),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Specialized app bar for dashboard screen with quick action buttons
class CustomDashboardAppBar extends CustomAppBar {
  const CustomDashboardAppBar({
    super.key,
    super.title = 'Restaurant Dashboard',
    super.showNotifications = true,
    super.notificationCount = 0,
    super.showSyncStatus = true,
    super.syncStatus = true,
    super.onNotificationTap,
    super.onSyncTap,
  }) : super(
          showBackButton: false,
          actions: const [
            _QuickActionButton(
              icon: Icons.add_circle_outline,
              tooltip: 'Quick Add Order',
              route: '/menu-management',
            ),
            _QuickActionButton(
              icon: Icons.receipt_long,
              tooltip: 'View Reports',
              route: '/sales-reports',
            ),
          ],
        );
}

/// Specialized app bar for order management screens
class CustomOrderAppBar extends CustomAppBar {
  const CustomOrderAppBar({
    super.key,
    required super.title,
    super.showBackButton = true,
    super.showSyncStatus = true,
    super.syncStatus,
    super.onSyncTap,
  }) : super(
          actions: const [
            _QuickActionButton(
              icon: Icons.print,
              tooltip: 'Print Receipt',
            ),
            _QuickActionButton(
              icon: Icons.payment,
              tooltip: 'Process Payment',
              route: '/payment-processing',
            ),
          ],
        );
}

/// Quick action button for app bar actions
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final String? route;
  final VoidCallback? onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.tooltip,
    this.route,
    this.onPressed,  // Add this parameter to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: IconButton(
        icon: Icon(icon, size: 22),
        onPressed: onPressed ??
            () {
              if (route != null) {
                Navigator.pushNamed(context, route!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$tooltip feature coming soon'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
        tooltip: tooltip,
      ),
    );
  }
}