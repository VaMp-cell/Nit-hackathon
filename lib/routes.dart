import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/report/report_screen.dart';
import 'screens/map/map_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/myissues/my_issues_screen.dart';
import 'screens/admin/admin_dashboard.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/home': (context) => const HomeScreen(),
  '/report': (context) => const ReportScreen(),
  '/map': (context) => const MapScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/myissues': (context) => const MyIssuesScreen(),
  '/admin': (context) => const AdminDashboard(),
};
