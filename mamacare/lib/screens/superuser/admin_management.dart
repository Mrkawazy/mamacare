import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/user.dart';
import 'package:mamacare/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamacare/screens/superuser/add_admin_screen.dart';

class AdminManagementScreen extends StatefulWidget {
  const AdminManagementScreen({super.key});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen> {
  late Box<User> _usersBox;
  List<User> _admins = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _usersBox = Hive.box<User>('users');
    _loadAdmins();
  }

  Future<void> _loadAdmins() async {
    setState(() {
      _admins = _usersBox.values.where((user) {
        final isAdmin = user.role == UserRole.admin;
        final matchesSearch = user.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.email.toLowerCase().contains(_searchQuery.toLowerCase());
        return isAdmin && matchesSearch;
      }).toList();
    });
  }

  Future<void> _toggleAdminStatus(User admin) async {
    await _usersBox.put(admin.id, User(
      id: admin.id,
      fullName: admin.fullName,
      email: admin.email,
      phoneNumber: admin.phoneNumber,
      passwordHash: admin.passwordHash,
      role: admin.role,
      registeredAt: admin.registeredAt,
      province: admin.province,
      isActive: !admin.isActive,
    ));
    _loadAdmins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAdminScreen()),
              );
              _loadAdmins();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Admins',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _loadAdmins();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _admins.length,
              itemBuilder: (context, index) {
                final admin = _admins[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(admin.fullName[0]),
                    ),
                    title: Text(admin.fullName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(admin.email),
                        Text(admin.phoneNumber),
                        if (admin.province != null) Text(admin.province!),
                      ],
                    ),
                    trailing: Switch(
                      value: admin.isActive,
                      onChanged: (_) => _toggleAdminStatus(admin),
                    ),
                    onTap: () {
                      // Show admin details
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
}