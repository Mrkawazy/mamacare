import 'package:flutter/material.dart';
import 'package:mamacare/screens/superuser/admin_management.dart';
import 'package:mamacare/screens/superuser/system_config.dart';
import 'package:mamacare/screens/superuser/audit_logs.dart';
import 'package:mamacare/screens/superuser/data_backup.dart';

class SuperuserDashboard extends StatelessWidget {
  const SuperuserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Superuser Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.security),
            tooltip: 'System Security',
            onPressed: () {
              // Navigate to security settings
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        childAspectRatio: 1.2,
        children: [
          _buildDashboardCard(
            context,
            icon: Icons.admin_panel_settings,
            title: 'Admin Management',
            subtitle: 'Create and manage admin accounts',
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminManagementScreen()),
            ),
          ),
          _buildDashboardCard(
            context,
            icon: Icons.settings_suggest,
            title: 'System Config',
            subtitle: 'Configure application settings',
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SystemConfigScreen()),
            ),
          ),
          _buildDashboardCard(
            context,
            icon: Icons.assignment,
            title: 'Audit Logs',
            subtitle: 'View system activity logs',
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AuditLogsScreen()),
            ),
          ),
          _buildDashboardCard(
            context,
            icon: Icons.backup,
            title: 'Data Backup',
            subtitle: 'Backup and restore data',
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DataBackupScreen()),
            ),
          ),
          _buildDashboardCard(
            context,
            icon: Icons.verified_user,
            title: 'Permissions',
            subtitle: 'Manage role permissions',
            color: Colors.teal,
            onTap: () {
              // Navigate to permissions management
            },
          ),
          _buildDashboardCard(
            context,
            icon: Icons.analytics,
            title: 'System Health',
            subtitle: 'Monitor app performance',
            color: Colors.red,
            onTap: () {
              // Navigate to system health
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}