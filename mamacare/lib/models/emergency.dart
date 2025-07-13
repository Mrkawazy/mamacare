import 'package:hive/hive.dart';

part 'emergency.g.dart';

@HiveType(typeId: 12)
enum EmergencyType {
  @HiveField(0)
  medical,
  
  @HiveField(1)
  police,
  
  @HiveField(2)
  fire,
  
  @HiveField(3)
  ambulance,
}

@HiveType(typeId: 13)
class EmergencyContact {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final EmergencyType type;
  
  @HiveField(3)
  final String phoneNumber;
  
  @HiveField(4)
  final String? location;
  
  @HiveField(5)
  final String? province; // Zimbabwean province
  
  EmergencyContact({
    required this.id,
    required this.name,
    required this.type,
    required this.phoneNumber,
    this.location,
    this.province,
  });
}

@HiveType(typeId: 14)
class EmergencyReport {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final EmergencyType type;
  
  @HiveField(3)
  final DateTime reportedAt;
  
  @HiveField(4)
  final String description;
  
  @HiveField(5)
  final String? location;
  
  @HiveField(6)
  final double? latitude;
  
  @HiveField(7)
  final double? longitude;
  
  @HiveField(8)
  final bool isResolved;
  
  @HiveField(9)
  final String? responseNotes;
  
  EmergencyReport({
    required this.id,
    required this.userId,
    required this.type,
    required this.reportedAt,
    required this.description,
    this.location,
    this.latitude,
    this.longitude,
    this.isResolved = false,
    this.responseNotes,
  });
}