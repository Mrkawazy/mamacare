import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SystemConfigScreen extends StatefulWidget {
  const SystemConfigScreen({super.key});

  @override
  State<SystemConfigScreen> createState() => _SystemConfigScreenState();
}

class _SystemConfigScreenState extends State<SystemConfigScreen> {
  late Box _settingsBox;
  bool _maintenanceMode = false;
  bool _enableSync = true;
  int _syncInterval = 24;

  @override
  void initState() {
    super.initState();
    _settingsBox = Hive.box('app_settings');
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _maintenanceMode = _settingsBox.get('maintenanceMode', defaultValue: false);
      _enableSync = _settingsBox.get('enableSync', defaultValue: true);
      _syncInterval = _settingsBox.get('syncInterval', defaultValue: 24);
    });
  }

  Future<void> _saveSettings() async {
    await _settingsBox.putAll({
      'maintenanceMode': _maintenanceMode,
      'enableSync': _enableSync,
      'syncInterval': _syncInterval,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Configuration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Application Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Maintenance Mode'),
              subtitle: const Text('Put the app in maintenance mode'),
              value: _maintenanceMode,
              onChanged: (value) => setState(() => _maintenanceMode = value),
            ),
            const Divider(),
            const Text(
              'Data Sync Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Auto Sync'),
              subtitle: const Text('Automatically sync data with server'),
              value: _enableSync,
              onChanged: (value) => setState(() => _enableSync = value),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Sync Interval (hours)'),
              subtitle: Slider(
                value: _syncInterval.toDouble(),
                min: 1,
                max: 72,
                divisions: 23,
                label: '$_syncInterval hours',
                onChanged: (value) => setState(() => _syncInterval = value.round()),
              ),
              trailing: Text('$_syncInterval'),
            ),
            const Divider(),
            const Text(
              'Danger Zone',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Clear All Data',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                // Show confirmation dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}