import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/user.dart';
import 'package:mamacare/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mamacare/utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Box<User> _usersBox;
  late Box _appSettingsBox;
  late User _currentUser;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String? _selectedProvince;
  String? _selectedLanguage;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  File? _profileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usersBox = Hive.box<User>('users');
    _appSettingsBox = Hive.box('settings');
    _currentUser = context.read<AuthService>().state!;
    _nameController = TextEditingController(text: _currentUser.fullName);
    _emailController = TextEditingController(text: _currentUser.email);
    _phoneController = TextEditingController(text: _currentUser.phoneNumber);
    _addressController = TextEditingController(text: _currentUser.address ?? '');
    _selectedProvince = _currentUser.province;
    _loadAppSettings();
  }

  void _loadAppSettings() {
    setState(() {
      _selectedLanguage = _appSettingsBox.get('language', defaultValue: 'English');
      _notificationsEnabled = _appSettingsBox.get('notifications', defaultValue: true);
      _darkModeEnabled = _appSettingsBox.get('darkMode', defaultValue: false);
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveUserProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedUser = User(
        id: _currentUser.id,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        passwordHash: _currentUser.passwordHash,
        role: _currentUser.role,
        registeredAt: _currentUser.registeredAt,
        address: _addressController.text.trim().isEmpty 
            ? null 
            : _addressController.text.trim(),
        province: _selectedProvince,
        dateOfBirth: _currentUser.dateOfBirth,
        isActive: true,
        profileImageUrl: _profileImage != null 
            ? 'path/to/uploaded/image.jpg' 
            : _currentUser.profileImageUrl, createdAt: null,
      );

      await _usersBox.put(updatedUser.id, updatedUser);
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      context.read<AuthService>().emit(updatedUser);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveAppSettings() async {
    await _appSettingsBox.put('language', _selectedLanguage);
    await _appSettingsBox.put('notifications', _notificationsEnabled);
    await _appSettingsBox.put('darkMode', _darkModeEnabled);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  Future<void> _saveAll() async {
    await _saveUserProfile();
    await _saveAppSettings();
  }

  Future<void> _changePassword() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );

    if (result != null) {
      setState(() => _isLoading = true);
      try {
        final updatedUser = User(
          id: _currentUser.id,
          fullName: _currentUser.fullName,
          email: _currentUser.email,
          phoneNumber: _currentUser.phoneNumber,
          passwordHash: result['newPassword']!, // Hash this in production
          role: _currentUser.role,
          registeredAt: _currentUser.registeredAt,
          address: _currentUser.address,
          province: _currentUser.province,
          dateOfBirth: _currentUser.dateOfBirth,
          isActive: true,
          profileImageUrl: _currentUser.profileImageUrl, createdAt: null,
        );

        await _usersBox.put(updatedUser.id, updatedUser);
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
        context.read<AuthService>().emit(updatedUser);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error changing password: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveAll,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              const Text(
                'Profile Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : (_currentUser.profileImageUrl != null
                              ? NetworkImage(_currentUser.profileImageUrl!)
                              : null) as ImageProvider?,
                      child: _profileImage == null && 
                              _currentUser.profileImageUrl == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  prefixText: '+263 ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^[0-9]{9}$').hasMatch(value)) {
                    return 'Please enter a valid Zimbabwean number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address (Optional)',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedProvince,
                decoration: const InputDecoration(
                  labelText: 'Province',
                  prefixIcon: Icon(Icons.map),
                  border: OutlineInputBorder(),
                ),
                items: AppConstants.zimbabweProvinces
                    .map((province) => DropdownMenuItem(
                          value: province,
                          child: Text(province),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedProvince = value),
              ),
              const SizedBox(height: 24),
              
              // App Settings Section
              const Text(
                'App Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                items: AppConstants.languages.map((language) {
                  return DropdownMenuItem(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Language',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Enable Notifications'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              // Account Settings Section
              const Text(
                'Account Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _isLoading ? null : _changePassword,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Show privacy policy
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & Support'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to help & support
                },
              ),
              const SizedBox(height: 16),
              
              // App Information
              const Text(
                'App Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Version'),
                subtitle: Text(AppConstants.appVersion),
              ),
              ListTile(
                title: const Text('About'),
                subtitle: Text(AppConstants.appDescription),
              ),
              const SizedBox(height: 24),
              
              // Logout Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<AuthService>().logout();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureCurrentPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () => setState(
                        () => _obscureCurrentPassword = !_obscureCurrentPassword),
                  ),
                  border: const OutlineInputBorder(),
                ),
                obscureText: _obscureCurrentPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureNewPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscureNewPassword = !_obscureNewPassword),
                  ),
                  border: const OutlineInputBorder(),
                ),
                obscureText: _obscureNewPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () => setState(
                        () => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  border: const OutlineInputBorder(),
                ),
                obscureText: _obscureConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
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
                'currentPassword': _currentPasswordController.text,
                'newPassword': _newPasswordController.text,
              });
            }
          },
          child: const Text('Change Password'),
        ),
      ],
    );
  }
}