import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/child.dart';
import 'package:mamacare/models/emergency.dart';
import 'package:mamacare/models/facility.dart';
import 'package:mamacare/models/health_education.dart';
import 'package:mamacare/models/pregnancy.dart';
import 'package:mamacare/utils/app_exceptions.dart';

class DatabaseService {
  final Box<Pregnancy> _pregnancyBox;
  final Box<Child> _childBox;
  final Box<HealthEducation> _educationBox;
  final Box<HealthFacility> _facilityBox;
  final Box<EmergencyReport> _reportBox;

  DatabaseService()
      : _pregnancyBox = Hive.box<Pregnancy>('pregnancies'),
        _childBox = Hive.box<Child>('children'),
        _educationBox = Hive.box<HealthEducation>('health_education'),
        _facilityBox = Hive.box<HealthFacility>('facilities'),
        _reportBox = Hive.box<EmergencyReport>('emergency_reports');

  // Pregnancy Methods
  Future<Pregnancy> createPregnancy(Pregnancy pregnancy) async {
    try {
      if (_pregnancyBox.values.any((p) => p.userId == pregnancy.userId && p.isActive)) {
        throw DatabaseException('User already has an active pregnancy');
      }
      await _pregnancyBox.put(pregnancy.id, pregnancy);
      return pregnancy;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<List<Pregnancy>> getUserPregnancies(String userId) async {
    try {
      return _pregnancyBox.values
          .where((pregnancy) => pregnancy.userId == userId)
          .toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  // Child Methods
  Future<Child> registerChild(Child child) async {
    try {
      await _childBox.put(child.id, child);
      return child;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<List<Child>> getUserChildren(String userId) async {
    try {
      return _childBox.values
          .where((child) => child.userId == userId)
          .toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  // Health Education Methods
  Future<List<HealthEducation>> getHealthEducation({
    EducationCategory? category,
    bool featuredOnly = false,
  }) async {
    try {
      return _educationBox.values
          .where((item) => (category == null || item.category == category) &&
              (!featuredOnly || item.isFeatured))
          .toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  // Facility Methods
  Future<List<HealthFacility>> getNearbyFacilities(
    double latitude,
    double longitude,
    double radiusInKm,
  ) async {
    try {
      return _facilityBox.values.where((facility) {
        final distance = Geolocator.distanceBetween(
          latitude,
          longitude,
          facility.latitude,
          facility.longitude,
        ) / 1000; // Convert to kilometers
        return distance <= radiusInKm;
      }).toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  // Emergency Methods
  Future<EmergencyReport> reportEmergency(EmergencyReport report) async {
    try {
      await _reportBox.put(report.id, report);
      return report;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  Future<void> syncWithRemote() async {
    // Implementation for syncing local data with remote server
    throw UnimplementedError();
  }
}