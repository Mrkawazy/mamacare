import 'package:flutter/material.dart';
import 'package:mamacare/screens/admin/content_management.dart';
import 'package:mamacare/screens/admin/emergency_management.dart';
import 'package:mamacare/screens/admin/facility_management.dart';
import 'package:mamacare/screens/admin/reports_screen.dart';
import 'package:mamacare/screens/admin/user_management.dart';
import 'package:mamacare/screens/admin/system_settings.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              // Sync with online database
              _showSyncDialog(context);
            },
            tooltip: 'Sync Data',
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        childAspectRatio: 1.0,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          // User Management
          _buildDashboardItem(
            context,
            icon: Icons.people,
            label: 'User Management',
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserManagementScreen()),
            ),
          ),
          
          // Content Management
          _buildDashboardItem(
            context,
            icon: Icons.article,
            label: 'Health Content',
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContentManagementScreen()),
            ),
          ),
          
          // Facility Management
          _buildDashboardItem(
            context,
            icon: Icons.local_hospital,
            label: 'Health Facilities',
            color: Colors.red,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FacilityManagementScreen()),
            ),
          ),
          
          // Emergency Contacts
          _buildDashboardItem(
            context,
            icon: Icons.emergency,
            label: 'Emergency Contacts',
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmergencyManagementScreen()),
            ),
          ),
          
          // Reports
          _buildDashboardItem(
            context,
            icon: Icons.assessment,
            label: 'Reports',
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportsScreen()),
            ),
          ),
          
          // System Settings
          _buildDashboardItem(
            context,
            icon: Icons.settings,
            label: 'System Settings',
            color: Colors.teal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SystemSettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSyncDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Data'),
        content: const Text('Do you want to synchronize all local data with the online database?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement sync functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data synchronization started')),
              );
            },
            child: const Text('Sync Now'),
          ),
        ],
      ),
    );
  }
}