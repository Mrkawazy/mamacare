import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mamacare/models/user.dart';
import 'package:mamacare/utils/app_exceptions.dart';

class SyncService {
  final String _apiBaseUrl;
  final Box<User> _userBox;

  SyncService({required String apiBaseUrl})
      : _apiBaseUrl = apiBaseUrl,
        _userBox = Hive.box<User>('users');

  Future<void> syncAllData() async {
    try {
      // Sync users first
      await _syncUsers();

      // Then sync other data
      await Future.wait([
        _syncPregnancies(),
        _syncChildren(),
        _syncHealthEducation(),
        _syncFacilities(),
        _syncEmergencyContacts(),
      ]);
    } catch (e) {
      throw SyncException(e.toString());
    }
  }

  Future<void> _syncUsers() async {
    try {
      final response = await http.get(Uri.parse('$_apiBaseUrl/users'));

      if (response.statusCode == 200) {
        // Parse response and update local database
        // This is a simplified example - implement proper parsing
        final users = userFromJson(response.body);
        await _userBox.clear();
        await _userBox.addAll(users);
      } else {
        throw SyncException('Failed to sync users: ${response.statusCode}');
      }
    } catch (e) {
      throw SyncException(e.toString());
    }
  }

  Future<void> _syncPregnancies() async {
    // Implementation for syncing pregnancies
  }

  Future<void> _syncChildren() async {
    // Implementation for syncing children
  }

  Future<void> _syncHealthEducation() async {
    // Implementation for syncing health education
  }

  Future<void> _syncFacilities() async {
    // Implementation for syncing facilities
  }

  Future<void> _syncEmergencyContacts() async {
    // Implementation for syncing emergency contacts
  }
  
  userFromJson(String body) { 
    // This function should parse the JSON response and return a list of User objects
    // Implement this based on your actual User model and JSON structure
    // For example:
    // return (json.decode(body) as List).map((data) => User.fromJson(data)).toList();
    }
  // Implement other sync methods similarly
}