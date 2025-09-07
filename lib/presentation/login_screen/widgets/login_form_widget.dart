import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Login form widget containing email/username and password fields
class LoginFormWidget extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final bool isLoading;

  const LoginFormWidget({
    super.key,
    required this.onLogin,
    this.isLoading = false,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    setState(() {
      _isEmailValid =
          email.isNotEmpty && (email.contains('@') || email.length >= 3);
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _isPasswordValid = password.length >= 4;
    });
  }

  String? _validateEmailField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email o usuario requerido';
    }
    final email = value.trim();
    if (email.contains('@')) {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return 'Formato de email inválido';
      }
    } else if (email.length < 3) {
      return 'Usuario debe tener al menos 3 caracteres';
    }
    return null;
  }

  String? _validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contraseña requerida';
    }
    if (value.length < 4) {
      return 'Contraseña debe tener al menos 4 caracteres';
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLogin(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email/Username Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Email o Usuario',
              hintText: 'Ingresa tu email o usuario',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: _isEmailValid
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 5.w,
                ),
              ),
              suffixIcon: _isEmailValid
                  ? Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successGreen,
                        size: 5.w,
                      ),
                    )
                  : null,
            ),
            validator: _validateEmailField,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),

          SizedBox(height: 3.h),

          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              hintText: 'Ingresa tu contraseña',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: _isPasswordValid
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 5.w,
                ),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isPasswordValid)
                    Padding(
                      padding: EdgeInsets.only(right: 1.w),
                      child: CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successGreen,
                        size: 5.w,
                      ),
                    ),
                  IconButton(
                    onPressed: widget.isLoading
                        ? null
                        : () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible),
                    icon: CustomIconWidget(
                      iconName:
                          _isPasswordVisible ? 'visibility_off' : 'visibility',
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 5.w,
                    ),
                  ),
                ],
              ),
            ),
            validator: _validatePasswordField,
            onFieldSubmitted: (_) => _handleLogin(),
          ),

          SizedBox(height: 2.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Función de recuperación de contraseña próximamente'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
              child: Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Login Button
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed:
                  (_isEmailValid && _isPasswordValid && !widget.isLoading)
                      ? _handleLogin
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor:
                    colorScheme.onSurface.withValues(alpha: 0.12),
                disabledForegroundColor:
                    colorScheme.onSurface.withValues(alpha: 0.38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      height: 5.w,
                      width: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary),
                      ),
                    )
                  : Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.25,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
