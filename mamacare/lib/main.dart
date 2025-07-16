import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mamacare/models/child.dart';
import 'package:mamacare/models/emergency.dart';
import 'package:mamacare/models/facility.dart';
import 'package:mamacare/models/health_education.dart';
import 'package:mamacare/models/pregnancy.dart';
import 'package:mamacare/models/user.dart';
import 'package:mamacare/screens/auth/auth_wrapper.dart';
import 'package:mamacare/screens/auth/login_screen.dart';
import 'package:mamacare/screens/auth/register_screen.dart';
import 'package:mamacare/services/auth_service.dart';
import 'package:mamacare/services/service_provider.dart';
import 'package:mamacare/utils/app_theme.dart';
import 'package:mamacare/utils/constants.dart';
import 'package:mamacare/bloc/auth/auth_cubit.dart'; // Ensure this path is correct and AuthCubit is defined in this file

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services and Hive
  await _initializeApp();

  // Run the application
  runApp(const MamaCareApp());
}

Future<void> _initializeApp() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(UserRoleAdapter());
  // Register other adapters as needed...

  // Open Hive boxes
  await Future.wait([
    Hive.openBox<User>('users'),
    Hive.openBox('app_settings'),
    Hive.openBox<Pregnancy>('pregnancies'),
    Hive.openBox<Child>('children'),
    Hive.openBox<HealthEducation>('health_education'),
    Hive.openBox<HealthFacility>('facilities'),
    Hive.openBox<EmergencyContact>('emergency_contacts'),
    Hive.openBox<EmergencyReport>('emergency_reports'),
  ]);

  // Initialize other services
  await ServiceProvider().initialize();
}

class MamaCareApp extends StatelessWidget {
  const MamaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthService>(
          create: (context) => ServiceProvider().authService,
        ),
        // Add other services as needed
      ],
      child: BlocProvider(
        create: (context) => AuthCubit(), // Make sure AuthCubit is defined and imported correctly
        child: MaterialApp(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: const AuthWrapper(),
          // Define routes if needed
          routes: {
             '/login': (context) => LoginScreen(),
             '/register': (context) => RegisterScreen(),
            // Add other routes...
          },
        ),
      ),
    );
  }
}