import 'package:flutter/material.dart';
import '../presentation/payment_processing/payment_processing.dart';
import '../presentation/menu_management/menu_management.dart';
import '../presentation/table_management/table_management.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/sales_reports/sales_reports.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String paymentProcessing = '/payment-processing';
  static const String menuManagement = '/menu-management';
  static const String tableManagement = '/table-management';
  static const String login = '/login-screen';
  static const String dashboard = '/dashboard';
  static const String salesReports = '/sales-reports';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    paymentProcessing: (context) => const PaymentProcessing(),
    menuManagement: (context) => const MenuManagement(),
    tableManagement: (context) => const TableManagement(),
    login: (context) => const LoginScreen(),
    dashboard: (context) => const Dashboard(),
    salesReports: (context) => const SalesReports(),
    // TODO: Add your other routes here
  };
}
