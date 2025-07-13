import 'package:flutter/material.dart';

class SystemSettingsScreen extends StatelessWidget {
  const SystemSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsSection(context, 'App Settings', [
            _buildSettingsSwitch('Dark Mode', false),
            _buildSettingsSwitch('Notifications', true),
          ]),
          const Divider(),
          _buildSettingsSection(context, 'Data Management', [
            _buildSettingsItem('Backup Data', Icons.backup),
            _buildSettingsItem('Clear Cache', Icons.delete),
          ]),
          const Divider(),
          _buildSettingsSection(context, 'About', [
            _buildSettingsItem('App Version', Icons.info, trailing: '1.0.0'),
            _buildSettingsItem('Privacy Policy', Icons.privacy_tip),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, {String? trailing}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing != null ? Text(trailing) : null,
      onTap: () {
        // Handle tap
      },
    );
  }

  Widget _buildSettingsSwitch(String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (newValue) {
        // Handle switch change
      },
    );
  }
}