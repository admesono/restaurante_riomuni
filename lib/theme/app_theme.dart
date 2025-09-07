import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the restaurant sales management application.
class AppTheme {
  AppTheme._();

  // Restaurant-focused color palette optimized for various lighting conditions
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color secondaryRed = Color(0xFFF44336);
  static const Color neutralBlack = Color(0xFF212121);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color darkGray = Color(0xFF424242);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);

  // Additional semantic colors for restaurant operations
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color shadowColor = Color(0x33000000); // 20% opacity black
  static const Color overlayColor = Color(0x80000000); // 50% opacity black

  // Text emphasis colors for optimal readability
  static const Color textHighEmphasisLight = Color(0xDE000000); // 87% opacity
  static const Color textMediumEmphasisLight = Color(0x99000000); // 60% opacity
  static const Color textDisabledLight = Color(0x61000000); // 38% opacity

  static const Color textHighEmphasisDark = Color(0xDEFFFFFF); // 87% opacity
  static const Color textMediumEmphasisDark = Color(0x99FFFFFF); // 60% opacity
  static const Color textDisabledDark = Color(0x61FFFFFF); // 38% opacity

  /// Light theme optimized for restaurant environments
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryRed,
      onPrimary: pureWhite,
      primaryContainer: secondaryRed,
      onPrimaryContainer: pureWhite,
      secondary: successGreen,
      onSecondary: pureWhite,
      secondaryContainer: successGreen.withValues(alpha: 0.1),
      onSecondaryContainer: neutralBlack,
      tertiary: warningOrange,
      onTertiary: pureWhite,
      tertiaryContainer: warningOrange.withValues(alpha: 0.1),
      onTertiaryContainer: neutralBlack,
      error: errorRed,
      onError: pureWhite,
      surface: pureWhite,
      onSurface: neutralBlack,
      onSurfaceVariant: darkGray,
      outline: borderColor,
      outlineVariant: mediumGray,
      shadow: shadowColor,
      scrim: overlayColor,
      inverseSurface: neutralBlack,
      onInverseSurface: pureWhite,
      inversePrimary: secondaryRed,
    ),
    scaffoldBackgroundColor: pureWhite,
    cardColor: lightGray,
    dividerColor: borderColor,

    // AppBar theme for restaurant management interface
    appBarTheme: AppBarTheme(
      backgroundColor: primaryRed,
      foregroundColor: pureWhite,
      elevation: 2.0,
      shadowColor: shadowColor,
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: pureWhite,
        letterSpacing: 0.15,
      ),
      toolbarTextStyle: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: pureWhite,
      ),
      iconTheme: const IconThemeData(
        color: pureWhite,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: pureWhite,
        size: 24,
      ),
    ),

    // Card theme for order cards and information panels
    cardTheme: CardTheme(
      color: lightGray,
      elevation: 2.0,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),

    // Bottom navigation for mobile restaurant staff
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: pureWhite,
      selectedItemColor: primaryRed,
      unselectedItemColor: mediumGray,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Navigation rail for tablet interfaces
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: pureWhite,
      selectedIconTheme: const IconThemeData(
        color: primaryRed,
        size: 24,
      ),
      unselectedIconTheme: const IconThemeData(
        color: mediumGray,
        size: 24,
      ),
      selectedLabelTextStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primaryRed,
      ),
      unselectedLabelTextStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: mediumGray,
      ),
      elevation: 2.0,
    ),

    // Floating action button for quick actions
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryRed,
      foregroundColor: pureWhite,
      elevation: 4.0,
      shape: CircleBorder(),
    ),

    // Button themes optimized for restaurant operations
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: pureWhite,
        backgroundColor: primaryRed,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryRed,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: primaryRed, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryRed,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    // Text theme using restaurant-optimized typography
    textTheme: _buildTextTheme(isLight: true),

    // Input decoration for order entry and data input
    inputDecorationTheme: InputDecorationTheme(
      fillColor: pureWhite,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryRed, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      labelStyle: GoogleFonts.openSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasisLight,
      ),
      hintStyle: GoogleFonts.openSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textDisabledLight,
      ),
      errorStyle: GoogleFonts.openSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: errorRed,
      ),
    ),

    // Switch theme for settings and toggles
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryRed;
        }
        return mediumGray;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryRed.withValues(alpha: 0.5);
        }
        return mediumGray.withValues(alpha: 0.3);
      }),
    ),

    // Checkbox theme for order selections
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryRed;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(pureWhite),
      side: const BorderSide(color: borderColor, width: 2),
    ),

    // Radio theme for option selections
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryRed;
        }
        return mediumGray;
      }),
    ),

    // Progress indicators for loading states
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryRed,
      linearTrackColor: lightGray,
      circularTrackColor: lightGray,
    ),

    // Slider theme for quantity adjustments
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryRed,
      thumbColor: primaryRed,
      overlayColor: primaryRed.withValues(alpha: 0.2),
      inactiveTrackColor: mediumGray.withValues(alpha: 0.3),
      valueIndicatorColor: primaryRed,
      valueIndicatorTextStyle: GoogleFonts.robotoMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: pureWhite,
      ),
    ),

    // Tab bar theme for section navigation
    tabBarTheme: TabBarTheme(
      labelColor: primaryRed,
      unselectedLabelColor: mediumGray,
      indicatorColor: primaryRed,
      indicatorSize: TabBarIndicatorSize.label,
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
    ),

    // Tooltip theme for help information
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: neutralBlack.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: pureWhite,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),

    // Snackbar theme for notifications
    snackBarTheme: SnackBarThemeData(
      backgroundColor: neutralBlack,
      contentTextStyle: GoogleFonts.openSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: pureWhite,
      ),
      actionTextColor: secondaryRed,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
    ),

    // List tile theme for menu items and orders
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titleTextStyle: GoogleFonts.openSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textHighEmphasisLight,
      ),
      subtitleTextStyle: GoogleFonts.openSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasisLight,
      ),
      leadingAndTrailingTextStyle: GoogleFonts.robotoMono(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasisLight,
      ),
    ),

    // Chip theme for tags and filters
    chipTheme: ChipThemeData(
      backgroundColor: lightGray,
      selectedColor: primaryRed.withValues(alpha: 0.1),
      labelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textHighEmphasisLight,
      ),
      secondaryLabelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: primaryRed,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ), dialogTheme: DialogThemeData(backgroundColor: pureWhite),
  );

  /// Dark theme for low-light restaurant environments
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: secondaryRed,
      onPrimary: neutralBlack,
      primaryContainer: primaryRed,
      onPrimaryContainer: pureWhite,
      secondary: successGreen,
      onSecondary: neutralBlack,
      secondaryContainer: successGreen.withValues(alpha: 0.2),
      onSecondaryContainer: pureWhite,
      tertiary: warningOrange,
      onTertiary: neutralBlack,
      tertiaryContainer: warningOrange.withValues(alpha: 0.2),
      onTertiaryContainer: pureWhite,
      error: errorRed,
      onError: pureWhite,
      surface: neutralBlack,
      onSurface: pureWhite,
      onSurfaceVariant: lightGray,
      outline: darkGray,
      outlineVariant: mediumGray,
      shadow: shadowColor,
      scrim: overlayColor,
      inverseSurface: pureWhite,
      onInverseSurface: neutralBlack,
      inversePrimary: primaryRed,
    ),
    scaffoldBackgroundColor: neutralBlack,
    cardColor: darkGray,
    dividerColor: mediumGray,

    // AppBar theme for dark environments
    appBarTheme: AppBarTheme(
      backgroundColor: neutralBlack,
      foregroundColor: pureWhite,
      elevation: 2.0,
      shadowColor: shadowColor,
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: pureWhite,
        letterSpacing: 0.15,
      ),
      toolbarTextStyle: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: pureWhite,
      ),
      iconTheme: const IconThemeData(
        color: pureWhite,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: pureWhite,
        size: 24,
      ),
    ),

    // Card theme for dark mode
    cardTheme: CardTheme(
      color: darkGray,
      elevation: 2.0,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),

    // Bottom navigation for dark mode
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: neutralBlack,
      selectedItemColor: secondaryRed,
      unselectedItemColor: mediumGray,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      selectedLabelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Navigation rail for dark mode tablets
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: neutralBlack,
      selectedIconTheme: const IconThemeData(
        color: secondaryRed,
        size: 24,
      ),
      unselectedIconTheme: const IconThemeData(
        color: mediumGray,
        size: 24,
      ),
      selectedLabelTextStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryRed,
      ),
      unselectedLabelTextStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: mediumGray,
      ),
      elevation: 2.0,
    ),

    // Floating action button for dark mode
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryRed,
      foregroundColor: neutralBlack,
      elevation: 4.0,
      shape: CircleBorder(),
    ),

    // Button themes for dark mode
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: neutralBlack,
        backgroundColor: secondaryRed,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: secondaryRed,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: secondaryRed, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: secondaryRed,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),

    // Text theme for dark mode
    textTheme: _buildTextTheme(isLight: false),

    // Input decoration for dark mode
    inputDecorationTheme: InputDecorationTheme(
      fillColor: darkGray,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: mediumGray, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: mediumGray, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: secondaryRed, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      labelStyle: GoogleFonts.openSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasisDark,
      ),
      hintStyle: GoogleFonts.openSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textDisabledDark,
      ),
      errorStyle: GoogleFonts.openSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: errorRed,
      ),
    ),

    // Switch theme for dark mode
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return secondaryRed;
        }
        return mediumGray;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return secondaryRed.withValues(alpha: 0.5);
        }
        return mediumGray.withValues(alpha: 0.3);
      }),
    ),

    // Checkbox theme for dark mode
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return secondaryRed;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(neutralBlack),
      side: const BorderSide(color: mediumGray, width: 2),
    ),

    // Radio theme for dark mode
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return secondaryRed;
        }
        return mediumGray;
      }),
    ),

    // Progress indicators for dark mode
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: secondaryRed,
      linearTrackColor: darkGray,
      circularTrackColor: darkGray,
    ),

    // Slider theme for dark mode
    sliderTheme: SliderThemeData(
      activeTrackColor: secondaryRed,
      thumbColor: secondaryRed,
      overlayColor: secondaryRed.withValues(alpha: 0.2),
      inactiveTrackColor: mediumGray.withValues(alpha: 0.3),
      valueIndicatorColor: secondaryRed,
      valueIndicatorTextStyle: GoogleFonts.robotoMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: neutralBlack,
      ),
    ),

    // Tab bar theme for dark mode
    tabBarTheme: TabBarTheme(
      labelColor: secondaryRed,
      unselectedLabelColor: mediumGray,
      indicatorColor: secondaryRed,
      indicatorSize: TabBarIndicatorSize.label,
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
    ),

    // Tooltip theme for dark mode
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: pureWhite.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: neutralBlack,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),

    // Snackbar theme for dark mode
    snackBarTheme: SnackBarThemeData(
      backgroundColor: pureWhite,
      contentTextStyle: GoogleFonts.openSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: neutralBlack,
      ),
      actionTextColor: primaryRed,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
    ),

    // List tile theme for dark mode
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titleTextStyle: GoogleFonts.openSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textHighEmphasisDark,
      ),
      subtitleTextStyle: GoogleFonts.openSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasisDark,
      ),
      leadingAndTrailingTextStyle: GoogleFonts.robotoMono(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasisDark,
      ),
    ),

    // Chip theme for dark mode
    chipTheme: ChipThemeData(
      backgroundColor: darkGray,
      selectedColor: secondaryRed.withValues(alpha: 0.2),
      labelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textHighEmphasisDark,
      ),
      secondaryLabelStyle: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryRed,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ), dialogTheme: DialogThemeData(backgroundColor: darkGray),
  );

  /// Helper method to build text theme based on brightness using restaurant-optimized typography
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis =
        isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.roboto(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
      ),

      // Title styles for cards and dialogs
      titleLarge: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),

      // Body styles for main content using Open Sans for readability
      bodyLarge: GoogleFonts.openSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.openSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.openSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
      ),

      // Label styles for buttons and small text
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 1.25,
      ),
      labelMedium: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textDisabled,
        letterSpacing: 1.5,
      ),
    );
  }

  /// Helper method to get monospace text style for numerical data
  static TextStyle getMonospaceStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final Color textColor =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    return GoogleFonts.robotoMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      letterSpacing: 0.25,
    );
  }

  /// Helper method to get caption style for timestamps and metadata
  static TextStyle getCaptionStyle({
    required bool isLight,
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final Color textColor =
        isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      letterSpacing: 0.4,
    );
  }
}
