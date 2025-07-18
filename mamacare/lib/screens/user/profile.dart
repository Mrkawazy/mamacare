import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/user.dart';
import 'package:mamacare/services/auth_service.dart';
import 'package:mamacare/screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  late Box<User> _usersBox;
  User? _currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _usersBox = Hive.box<User>('users');
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    _currentUser = _usersBox.values.firstWhere(
      (user) => user.email == '', 
      orElse: () => _usersBox.values.first,
    );
    
    if (_currentUser != null) {
      _nameController.text = _currentUser!.fullName;
      _emailController.text = _currentUser!.email;
      _phoneController.text = _currentUser!.phoneNumber;
    }
  }

  Future<void> _updateProfile() async {
    if (_currentUser == null) return;

    var user = User(
      id: _currentUser!.id,
      fullName: _nameController.text, // Change 'name' to 'fullName' or the correct field name in your User model
      email: _emailController.text,
      role: _currentUser!.role,
      createdAt: _currentUser!.createdAt, // Update to match the actual field name in your User model
      phoneNumber: _phoneController.text,
      passwordHash: _currentUser!.passwordHash,
      registeredAt: _currentUser!.registeredAt, profileImageUrl: null,
    );
    final updatedUser = user;

    await _usersBox.put(updatedUser.id, updatedUser);
    setState(() {
      _currentUser = updatedUser;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _updateProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Text(
                      _currentUser!.fullName[0],
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: !_isEditing,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: !_isEditing,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  if (_currentUser!.role == UserRole.admin ||
                      _currentUser!.role == UserRole.superuser)
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings),
                      title: Text(
                          'Role: ${_currentUser!.role.toString().split('.').last}'),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}