import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class DataBackupScreen extends StatefulWidget {
  const DataBackupScreen({super.key});

  @override
  State<DataBackupScreen> createState() => _DataBackupScreenState();
}

class _DataBackupScreenState extends State<DataBackupScreen> {
  bool _isBackingUp = false;
  bool _isRestoring = false;
  String _backupStatus = '';
  String _restoreStatus = '';

  Future<void> _backupData() async {
    setState(() {
      _isBackingUp = true;
      _backupStatus = 'Preparing backup...';
    });

    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        setState(() => _backupStatus = 'Storage permission denied');
        return;
      }

      final appDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${appDir.path}/backups');
      if (!backupDir.existsSync()) {
        backupDir.createSync(recursive: true);
      }

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final backupFile = File('${backupDir.path}/mamacare_backup_$timestamp.hive');

      // Get all box files
      final hiveDir = Directory('${appDir.path}/hive');
      if (!hiveDir.existsSync()) {
        setState(() => _backupStatus = 'No data to backup');
        return;
      }

      // Copy all hive files to backup location
      final hiveFiles = hiveDir.listSync();
      int filesCopied = 0;

      for (var file in hiveFiles) {
        if (file is File && file.path.endsWith('.hive')) {
          final contents = await file.readAsBytes();
          await backupFile.writeAsBytes(contents, mode: FileMode.append);
          filesCopied++;
        }
      }

      setState(() {
        _backupStatus = 'Backup completed: $filesCopied databases backed up\nLocation: ${backupFile.path}';
      });
    } catch (e) {
      setState(() => _backupStatus = 'Backup failed: ${e.toString()}');
    } finally {
      setState(() => _isBackingUp = false);
    }
  }

  Future<void> _restoreData() async {
    setState(() {
      _isRestoring = true;
      _restoreStatus = 'Selecting backup file...';
    });

    try {
      // TODO: Implement file picker to select backup file
      // For now, we'll just demonstrate with a dummy file
      setState(() => _restoreStatus = 'Restore functionality needs file picker implementation');
    } catch (e) {
      setState(() => _restoreStatus = 'Restore failed: ${e.toString()}');
    } finally {
      setState(() => _isRestoring = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Backup & Restore'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.backup, size: 50, color: Colors.blue),
                    const SizedBox(height: 16),
                    const Text(
                      'Backup Application Data',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create a backup of all user data and settings',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isBackingUp ? null : _backupData,
                      icon: _isBackingUp
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(Icons.backup),
                      label: Text(_isBackingUp ? 'Backing Up...' : 'Create Backup'),
                    ),
                    const SizedBox(height: 16),
                    if (_backupStatus.isNotEmpty)
                      Text(
                        _backupStatus,
                        style: TextStyle(
                          color: _backupStatus.contains('failed') ? Colors.red : Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.restore, size: 50, color: Colors.green),
                    const SizedBox(height: 16),
                    const Text(
                      'Restore Application Data',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Restore data from a previous backup',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isRestoring ? null : _restoreData,
                      icon: _isRestoring
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(Icons.restore),
                      label: Text(_isRestoring ? 'Restoring...' : 'Restore Data'),
                    ),
                    const SizedBox(height: 16),
                    if (_restoreStatus.isNotEmpty)
                      Text(
                        _restoreStatus,
                        style: TextStyle(
                          color: _restoreStatus.contains('failed') ? Colors.red : Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}