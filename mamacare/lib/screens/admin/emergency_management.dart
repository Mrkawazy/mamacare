import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/emergency.dart';
import 'package:mamacare/screens/admin/add_edit_emergency.dart';

class EmergencyManagementScreen extends StatefulWidget {
  const EmergencyManagementScreen({super.key});

  @override
  State<EmergencyManagementScreen> createState() => _EmergencyManagementScreenState();
}

class _EmergencyManagementScreenState extends State<EmergencyManagementScreen> {
  late Box<EmergencyContact> _emergencyBox;
  List<EmergencyContact> _contacts = [];
  String _searchQuery = '';
  EmergencyType? _filterType;

  @override
  void initState() {
    super.initState();
    _emergencyBox = Hive.box<EmergencyContact>('emergency_contacts');
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _contacts = _emergencyBox.values.where((contact) {
        final matchesSearch = contact.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            contact.phoneNumber.contains(_searchQuery);
        final matchesType = _filterType == null || contact.type == _filterType;
        return matchesSearch && matchesType;
      }).toList();
    });
  }

  Future<void> _deleteContact(String id) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this emergency contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _emergencyBox.delete(id);
              _loadContacts();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditEmergencyScreen(),
                ),
              );
              _loadContacts();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
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
                const SizedBox(height: 8),
                DropdownButtonFormField<EmergencyType>(
                  value: _filterType,
                  decoration: const InputDecoration(
                    labelText: 'Filter by Type',
                    border: OutlineInputBorder(),
                  ),
                  items: EmergencyType.values.map((type) {
                    return DropdownMenuItem<EmergencyType>(
                      value: type,
                      child: Text(_getEmergencyTypeName(type)),
                    );
                  }).toList(),
                  onChanged: (type) {
                    setState(() {
                      _filterType = type;
                    });
                    _loadContacts();
                  },
                  isExpanded: true,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: Icon(_getEmergencyIcon(contact.type),
                        color: _getEmergencyColor(contact.type)),
                    title: Text(contact.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(contact.phoneNumber),
                        if (contact.location != null) Text(contact.location!),
                        if (contact.province != null) 
                          Chip(label: Text(contact.province!)),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                      onSelected: (value) async {
                        if (value == 'edit') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditEmergencyScreen(
                                existingContact: contact,
                              ),
                            ),
                          );
                          _loadContacts();
                        } else if (value == 'delete') {
                          _deleteContact(contact.id);
                        }
                      },
                    ),
                    onTap: () {
                      // Show contact details
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getEmergencyTypeName(EmergencyType type) {
    switch (type) {
      case EmergencyType.medical:
        return 'Medical Emergency';
      case EmergencyType.police:
        return 'Police';
      case EmergencyType.fire:
        return 'Fire Brigade';
      case EmergencyType.ambulance:
        return 'Ambulance Service';
    }
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
}