import 'package:flutter/material.dart';
import 'package:mamacare/screens/user/pregnancy_tracker.dart';
import 'package:mamacare/screens/user/growth_monitor.dart';
import 'package:mamacare/screens/user/health_education.dart';
import 'package:mamacare/screens/user/facility_locator.dart';
import 'package:mamacare/screens/user/emergency.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HealthEducationScreen(),
    const PregnancyTrackerScreen(),
    const GrowthMonitorScreen(),
    const FacilityLocatorScreen(),
    const EmergencyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MamaCare'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _syncData,
            tooltip: 'Sync Data',
          ),
        ],
      ),
      drawer: const UserDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Education',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pregnant_woman),
            label: 'Pregnancy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care),
            label: 'Child',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Facilities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency),
            label: 'Emergency',
          ),
        ],
      ),
    );
  }

  Future<void> _syncData() async {
    // Implement data synchronization logic
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to MamaCare',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildQuickAccessGrid(context),
          const SizedBox(height: 24),
          const Text(
            'Recent Activities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildRecentActivities(),
        ],
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildQuickAccessItem(
          context,
          icon: Icons.calendar_today,
          label: 'Appointments',
          onTap: () {},
        ),
        _buildQuickAccessItem(
          context,
          icon: Icons.medical_services,
          label: 'Medications',
          onTap: () {},
        ),
        _buildQuickAccessItem(
          context,
          icon: Icons.monitor_weight,
          label: 'Weight Tracker',
          onTap: () {},
        ),
        _buildQuickAccessItem(
          context,
          icon: Icons.assignment,
          label: 'Health Records',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildQuickAccessItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    // Replace with actual recent activities from database
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Next appointment'),
          subtitle: const Text('July 20, 2023 at 10:00 AM'),
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {},
          ),
        ),
        ListTile(
          leading: const Icon(Icons.medical_services),
          title: const Text('Medication reminder'),
          subtitle: const Text('Take prenatal vitamins'),
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 8),
                Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'user@example.com',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthService>().logout();
            },
          ),
        ],
      ),
    );
  }
}