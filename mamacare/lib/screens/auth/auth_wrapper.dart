import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamacare/models/user.dart'; // Ensure this import exists
import 'package:mamacare/screens/admin/admin_dashboard.dart';
import 'package:mamacare/screens/auth/login_screen.dart';
import 'package:mamacare/screens/user/dashboard.dart';
import 'package:mamacare/services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthService, User?>(
      builder: (context, user) {
        // Show loading indicator while auth state is being determined
        if (user == null) {
          return const LoginScreen();
        }

        // Handle different user roles
        switch (user.role) {
          case UserRole.superuser:
          case UserRole.admin:
            return const AdminDashboard();
          case UserRole.user:
            return const UserDashboard();
          default:
            // Fallback for any unhandled roles
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Unknown user role'),
                    TextButton(
                      onPressed: () => context.read<AuthService>().logout(),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}