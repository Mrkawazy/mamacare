import 'package:hive/hive.dart';
import '../models/pregnancy.dart';
import '../models/child.dart';
import '../models/health_education.dart';
import '../models/health_facility.dart';
import '../models/emergency.dart';

class DatabaseService {
  // Pregnancy operations
  final Box<Pregnancy> _pregnanciesBox = Hive.box<Pregnancy>('pregnancies');
  
  Future<void> addPregnancy(Pregnancy pregnancy) async {
    await _pregnanciesBox.put(pregnancy.id, pregnancy);
  }
  
  Future<List<Pregnancy>> getUserPregnancies(String userId) async {
    return _pregnanciesBox.values.where((p) => p.userId == userId).toList();
  }

  // Child operations
  final Box<Child> _childrenBox = Hive.box<Child>('children');
  
  Future<void> addChild(Child child) async {
    await _childrenBox.put(child.id, child);
  }
  
  Future<List<Child>> getUserChildren(String userId) async {
    return _childrenBox.values.where((c) => c.userId == userId).toList();
  }

  // Health Education operations
  final Box<HealthEducation> _healthEduBox = Hive.box<HealthEducation>('healthEducation');
  
  Future<void> addHealthEducation(HealthEducation education) async {
    await _healthEduBox.put(education.id, education);
  }
  
  Future<List<HealthEducation>> getHealthEducation({String? category}) async {
    return _healthEduBox.values
        .where((e) => category == null || e.category == category)
        .toList();
  }

  // Health Facility operations
  final Box<HealthFacility> _facilitiesBox = Hive.box<HealthFacility>('healthFacilities');
  
  Future<void> addHealthFacility(HealthFacility facility) async {
    await _facilitiesBox.put(facility.id, facility);
  }
  
  Future<List<HealthFacility>> getHealthFacilities({String? province}) async {
    return _facilitiesBox.values
        .where((f) => province == null || f.province == province)
        .toList();
  }

  // Emergency operations
  final Box<Emergency> _emergenciesBox = Hive.box<Emergency>('emergencies');
  
  Future<void> addEmergency(Emergency emergency) async {
    await _emergenciesBox.put(emergency.id, emergency);
  }
  
  Future<List<Emergency>> getEmergencyContacts({String? type}) async {
    return _emergenciesBox.values
        .where((e) => type == null || e.type == type)
        .toList();
  }

  // Sync with backend
  Future<bool> syncData() async {
    // Implement sync logic
    return true;
  }
}