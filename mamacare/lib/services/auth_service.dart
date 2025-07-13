import 'package:hive/hive.dart';
import '../models/user.dart';

class AuthService {
  final Box<User> _usersBox = Hive.box<User>('users');

  Future<User?> login(String email, String password) async {
    try {
      return _usersBox.values.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> register(User user) async {
    try {
      if (_usersBox.values.any((u) => u.email == user.email)) {
        return false;
      }
      await _usersBox.put(user.id, user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<User>> getAdmins() async {
    return _usersBox.values.where((u) => u.role == UserRole.admin).toList();
  }

  Future<bool> createAdmin(User admin, String superuserId) async {
    try {
      if (_usersBox.values.any((u) => u.email == admin.email)) {
        return false;
      }
      admin.createdBy = superuserId;
      await _usersBox.put(admin.id, admin);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    // Clear any session data if needed
  }
}