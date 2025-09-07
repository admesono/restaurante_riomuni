import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Biometric authentication widget for Face ID/Touch ID/Fingerprint
class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback? onBiometricSuccess;
  final bool isEnabled;

  const BiometricAuthWidget({
    super.key,
    this.onBiometricSuccess,
    this.isEnabled = true,
  });

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget> {
  bool _isBiometricAvailable = false;
  bool _isAuthenticating = false;
  String _biometricType = '';

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      // Simulate biometric availability check
      // In real implementation, use local_auth package
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _isBiometricAvailable = true;
          // Simulate different biometric types based on platform
          if (Theme.of(context).platform == TargetPlatform.iOS) {
            _biometricType = 'Face ID';
          } else {
            _biometricType = 'Huella Digital';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBiometricAvailable = false;
        });
      }
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (!widget.isEnabled || _isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Simulate biometric authentication
      // In real implementation, use local_auth package
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful authentication
      if (mounted) {
        HapticFeedback.lightImpact();
        widget.onBiometricSuccess?.call();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Autenticación $_biometricType exitosa'),
            backgroundColor: AppTheme.successGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en autenticación $_biometricType'),
            backgroundColor: AppTheme.errorRed,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!_isBiometricAvailable) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Divider with "O" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: colorScheme.outline.withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'O',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: colorScheme.outline.withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Biometric Authentication Button
        Container(
          width: double.infinity,
          height: 6.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: InkWell(
            onTap: widget.isEnabled ? _authenticateWithBiometrics : null,
            borderRadius: BorderRadius.circular(2.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isAuthenticating)
                    SizedBox(
                      height: 5.w,
                      width: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      ),
                    )
                  else
                    CustomIconWidget(
                      iconName: Theme.of(context).platform == TargetPlatform.iOS
                          ? 'face'
                          : 'fingerprint',
                      color: widget.isEnabled
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.38),
                      size: 6.w,
                    ),
                  SizedBox(width: 3.w),
                  Text(
                    _isAuthenticating
                        ? 'Autenticando...'
                        : 'Usar $_biometricType',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: widget.isEnabled
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.38),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Biometric Info Text
        Text(
          'Usa $_biometricType para acceso rápido y seguro',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
