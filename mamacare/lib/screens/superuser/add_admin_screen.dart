import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/user.dart';
import 'package:mamacare/services/auth_service.dart';
import 'package:mamacare/utils/validators.dart';

class AddAdminScreen extends StatefulWidget {
  const AddAdminScreen({super.key});

  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _selectedProvince;

  // Zimbabwean provinces
  final List<String> _zimbabweProvinces = [
    'Bulawayo',
    'Harare',
    'Manicaland',
    'Mashonaland Central',
    'Mashonaland East',
    'Mashonaland West',
    'Masvingo',
    'Matabeleland North',
    'Matabeleland South',
    'Midlands',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAdmin() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      final currentUser = authService.state;

      if (currentUser == null || currentUser.role != UserRole.superuser) {
        throw Exception('Only superusers can create admin accounts');
      }

      // Check if email already exists
      final usersBox = Hive.box<User>('users');
      if (usersBox.values.any((user) => user.email == _emailController.text.trim())) {
        throw Exception('Email already registered');
      }

      // Check if phone already exists
      if (usersBox.values.any((user) => user.phoneNumber == _phoneController.text.trim())) {
        throw Exception('Phone number already registered');
      }

      final newAdmin = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        passwordHash: _passwordController.text, // Note: Hash this properly in production
        role: UserRole.admin,
        registeredAt: DateTime.now(),
        province: _selectedProvince,
        isActive: true, createdAt: null, profileImageUrl: null,
      );

      await authService.createAdmin(newAdmin, superuser: currentUser);

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin account created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Admin Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateName(value),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateEmail(value),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Phone Number Field (Zimbabwe specific)
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  prefixText: '+263 ',
                  border: OutlineInputBorder(),
                  hintText: '771234567',
                ),
                validator: (value) => Validators.validateZimbabweanPhone(value),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Province Dropdown
              DropdownButtonFormField<String>(
                value: _selectedProvince,
                decoration: const InputDecoration(
                  labelText: 'Province',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                items: _zimbabweProvinces
                    .map((province) => DropdownMenuItem(
                          value: province,
                          child: Text(province),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedProvince = value),
                validator: (value) =>
                    value == null ? 'Please select a province' : null,
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: const OutlineInputBorder(),
                ),
                obscureText: _obscurePassword,
                validator: (value) => Validators.validatePassword(value),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
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
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _createAdmin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Admin Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}