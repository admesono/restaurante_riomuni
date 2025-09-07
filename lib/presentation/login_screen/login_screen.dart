import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/restaurant_logo_widget.dart';
import './widgets/role_selector_widget.dart';

/// Login Screen for restaurant staff authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  String _selectedRole = 'manager';
  bool _showRoleSelector = false;
  bool _keyboardVisible = false;

  // Mock credentials for different roles
  final Map<String, Map<String, String>> _mockCredentials = {
    'manager': {
      'email': 'gerente@riomuni.com',
      'password': 'admin123',
      'username': 'gerente',
    },
    'cashier': {
      'email': 'cajero@riomuni.com',
      'password': 'cash123',
      'username': 'cajero',
    },
    'waiter': {
      'email': 'mesero@riomuni.com',
      'password': 'waiter123',
      'username': 'mesero',
    },
    'kitchen': {
      'email': 'cocina@riomuni.com',
      'password': 'kitchen123',
      'username': 'cocina',
    },
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  void _setupKeyboardListener() {
    // Keyboard visibility will be handled in the build method through MediaQuery.of(context).viewInsets.bottom
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check credentials against mock data
      final roleCredentials = _mockCredentials[_selectedRole];
      final isValidEmail =
          email.toLowerCase() == roleCredentials?['email']?.toLowerCase();
      final isValidUsername =
          email.toLowerCase() == roleCredentials?['username']?.toLowerCase();
      final isValidPassword = password == roleCredentials?['password'];

      if ((isValidEmail || isValidUsername) && isValidPassword) {
        // Success - trigger haptic feedback
        HapticFeedback.lightImpact();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Bienvenido, ${_getRoleDisplayName(_selectedRole)}'),
              backgroundColor: AppTheme.successGreen,
              duration: const Duration(seconds: 2),
            ),
          );

          // Navigate to dashboard
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        // Invalid credentials
        HapticFeedback.heavyImpact();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Credenciales incorrectas. Verifica tu email/usuario y contraseña.'),
              backgroundColor: AppTheme.errorRed,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Ver Credenciales',
                textColor: Colors.white,
                onPressed: _showMockCredentials,
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Network or other error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error de conexión. Intenta nuevamente.'),
            backgroundColor: AppTheme.errorRed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMockCredentials() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Credenciales de Prueba'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: _mockCredentials.entries.map((entry) {
              final role = entry.key;
              final credentials = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getRoleDisplayName(role),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Email: ${credentials['email']}'),
                    Text('Usuario: ${credentials['username']}'),
                    Text('Contraseña: ${credentials['password']}'),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'manager':
        return 'Gerente';
      case 'cashier':
        return 'Cajero';
      case 'waiter':
        return 'Mesero';
      case 'kitchen':
        return 'Cocina';
      default:
        return 'Usuario';
    }
  }

  void _handleBiometricSuccess() {
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _handleBackPress() {
    if (_showRoleSelector) {
      setState(() {
        _showRoleSelector = false;
      });
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackPress();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isTablet = constraints.maxWidth > 600;
                      final contentWidth =
                          isTablet ? 400.0 : constraints.maxWidth;

                      return Center(
                        child: Container(
                          width: contentWidth,
                          constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight,
                          ),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: keyboardHeight > 0 ? 2.h : 4.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Restaurant Logo
                                if (!_keyboardVisible) ...[
                                  Center(
                                    child: RestaurantLogoWidget(
                                      isCompact: keyboardHeight > 0,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                ],

                                // Welcome Text
                                Text(
                                  'Bienvenido',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Inicia sesión para acceder al sistema',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),

                                SizedBox(height: 4.h),

                                // Role Selector
                                if (_showRoleSelector) ...[
                                  RoleSelectorWidget(
                                    selectedRole: _selectedRole,
                                    onRoleChanged: (role) {
                                      setState(() {
                                        _selectedRole = role;
                                      });
                                    },
                                    isEnabled: !_isLoading,
                                  ),
                                  SizedBox(height: 4.h),
                                ] else ...[
                                  // Role Selection Button
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: colorScheme.outline
                                            .withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(2.w),
                                    ),
                                    child: InkWell(
                                      onTap: _isLoading
                                          ? null
                                          : () {
                                              setState(() {
                                                _showRoleSelector = true;
                                              });
                                            },
                                      child: Row(
                                        children: [
                                          CustomIconWidget(
                                            iconName:
                                                _getRoleIcon(_selectedRole),
                                            color: colorScheme.primary,
                                            size: 6.w,
                                          ),
                                          SizedBox(width: 3.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Rol seleccionado',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: colorScheme.onSurface
                                                        .withValues(alpha: 0.6),
                                                  ),
                                                ),
                                                Text(
                                                  _getRoleDisplayName(
                                                      _selectedRole),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        colorScheme.onSurface,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomIconWidget(
                                            iconName: 'keyboard_arrow_down',
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.6),
                                            size: 6.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                ],

                                // Login Form
                                LoginFormWidget(
                                  onLogin: _handleLogin,
                                  isLoading: _isLoading,
                                ),

                                SizedBox(height: 4.h),

                                // Biometric Authentication
                                if (!_keyboardVisible)
                                  BiometricAuthWidget(
                                    onBiometricSuccess: _handleBiometricSuccess,
                                    isEnabled: !_isLoading,
                                  ),

                                // Bottom spacing for keyboard
                                if (keyboardHeight > 0) SizedBox(height: 2.h),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _getRoleIcon(String role) {
    switch (role) {
      case 'manager':
        return 'business_center';
      case 'cashier':
        return 'point_of_sale';
      case 'waiter':
        return 'restaurant_menu';
      case 'kitchen':
        return 'restaurant';
      default:
        return 'person';
    }
  }
}