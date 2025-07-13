import 'package:flutter/material.dart';
import 'package:mamacare/screens/auth/login_screen.dart';
import 'package:mamacare/services/auth_service.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 40),
                ),
                SizedBox(height: 10),
                Text(
                  'MamaCare',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.pregnant_woman),
            title: const Text('Pregnancy Tracker'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to pregnancy tracker
            },
          ),
          ListTile(
            leading: const Icon(Icons.child_friendly),
            title: const Text('Growth Monitor'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to growth monitor
            },
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text('Health Education'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to health education
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Facility Locator'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to facility locator
            },
          ),
          ListTile(
            leading: const Icon(Icons.emergency),
            title: const Text('Emergency'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to emergency
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await authService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}