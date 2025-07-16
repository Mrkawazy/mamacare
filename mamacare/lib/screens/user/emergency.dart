// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/emergency.dart';


class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  late Box<EmergencyContact> _emergencyBox;
  late Box<EmergencyReport> _reportBox;
  List<EmergencyContact> _contacts = [];
  EmergencyType? _selectedType;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _emergencyBox = Hive.box<EmergencyContact>('emergency_contacts');
    _reportBox = Hive.box<EmergencyReport>('emergency_reports');
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _contacts = _emergencyBox.values.where((contact) {
        final matchesType = _selectedType == null || contact.type == _selectedType;
        final matchesSearch = contact.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            contact.phoneNumber.contains(_searchQuery);
        return matchesType && matchesSearch;
      }).toList();
    });
  }

  Future<void> _makeCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch phone app');
    }
  }

  Future<void> _reportEmergency(EmergencyType type) async {
    // Show dialog to get emergency details
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EmergencyReportDialog(),
    );

    if (result != null) {
      final report = EmergencyReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user_id', // Replace with actual user ID
        type: type,
        reportedAt: DateTime.now(),
        description: result['description'],
        location: result['location'],
      );

      await _reportBox.put(report.id, report);

      // Call the appropriate emergency number
      final contact = _contacts.firstWhere((c) => c.type == type);
      _makeCall(contact.phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Services'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Contacts',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _loadContacts();
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildEmergencyButtons(),
                const SizedBox(height: 16),
                _buildEmergencyContacts(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButtons() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Quick Emergency Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildEmergencyButton(
                  context,
                  icon: Icons.medical_services,
                  label: 'Medical',
                  color: Colors.red,
                  onTap: () => _reportEmergency(EmergencyType.medical),
                ),
                _buildEmergencyButton(
                  context,
                  icon: Icons.local_police,
                  label: 'Police',
                  color: Colors.blue,
                  onTap: () => _reportEmergency(EmergencyType.police),
                ),
                _buildEmergencyButton(
                  context,
                  icon: Icons.fire_truck,
                  label: 'Fire',
                  color: Colors.orange,
                  onTap: () => _reportEmergency(EmergencyType.fire),
                ),
                _buildEmergencyButton(
                  context,
                  icon: Icons.airport_shuttle,
                  label: 'Ambulance',
                  color: Colors.green,
                  onTap: () => _reportEmergency(EmergencyType.ambulance),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      icon: Icon(icon),
      label: Text(label),
      onPressed: onTap,
    );
  }

  Widget _buildEmergencyContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Emergency Contacts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ..._contacts.map((contact) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Icon(
                _getEmergencyIcon(contact.type),
                color: _getEmergencyColor(contact.type),
              ),
              title: Text(contact.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact.phoneNumber),
                  if (contact.location != null) Text(contact.location!),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call),
                color: Colors.green,
                onPressed: () => _makeCall(contact.phoneNumber),
              ),
            ),
          );
        // ignore: unnecessary_to_list_in_spreads
        }).toList(),
      ],
    );
  }

  IconData _getEmergencyIcon(EmergencyType type) {
    switch (type) {
      case EmergencyType.medical:
        return Icons.medical_services;
      case EmergencyType.police:
        return Icons.local_police;
      case EmergencyType.fire:
        return Icons.fire_truck;
      case EmergencyType.ambulance:
        return Icons.airport_shuttle;
    }
  }

  Color _getEmergencyColor(EmergencyType type) {
    switch (type) {
      case EmergencyType.medical:
        return Colors.red;
      case EmergencyType.police:
        return Colors.blue;
      case EmergencyType.fire:
        return Colors.orange;
      case EmergencyType.ambulance:
        return Colors.green;
    }
  }
  
  launchUrl(Uri uri) {}
}

class EmergencyReportDialog extends StatefulWidget {
  const EmergencyReportDialog({super.key});

  @override
  State<EmergencyReportDialog> createState() => _EmergencyReportDialogState();
}

class _EmergencyReportDialogState extends State<EmergencyReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Report Emergency'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Emergency Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe the emergency';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Your Location (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'description': _descriptionController.text,
                'location': _locationController.text,
              });
            }
          },
          child: const Text('Report'),
        ),
      ],
    );
  }
}