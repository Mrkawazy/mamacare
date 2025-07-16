import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/user.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late Box<User> _usersBox;
  List<User> _users = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _usersBox = Hive.box<User>('users');
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _users = _usersBox.values.where((user) {
        return user.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

  Future<void> _createAdminUser() async {
    // Implementation for creating admin user
    // This would show a dialog with a form to create new admin
  }

  Future<void> _toggleUserStatus(User user) async {
    await _usersBox.put(user.id, User(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      phoneNumber: user.phoneNumber,
      passwordHash: user.passwordHash,
      role: user.role,
      registeredAt: user.registeredAt,
      address: user.address,
      province: user.province,
      dateOfBirth: user.dateOfBirth,
      isActive: !user.isActive, createdAt: null, profileImageUrl: null,
    ));
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createAdminUser,
            tooltip: 'Create Admin User',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Users',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _loadUsers();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(user.fullName[0]),
                  ),
                  title: Text(user.fullName),
                  subtitle: Text('${user.email} • ${user.role.toString().split('.').last}'),
                  trailing: Switch(
                    value: user.isActive,
                    onChanged: (_) => _toggleUserStatus(user),
                  ),
                  onTap: () {
                    // Show user details
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}