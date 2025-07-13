import 'package:hive/hive.dart';

part 'facility.g.dart';

@HiveType(typeId: 10)
enum FacilityType {
  @HiveField(0)
  clinic,
  
  @HiveField(1)
  hospital,
  
  @HiveField(2)
  maternity,
  
  @HiveField(3)
  pharmacy,
}

@HiveType(typeId: 11)
class HealthFacility {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final FacilityType type;
  
  @HiveField(3)
  final String address;
  
  @HiveField(4)
  final String province; // Zimbabwean province
  
  @HiveField(5)
  final String district;
  
  @HiveField(6)
  final double latitude;
  
  @HiveField(7)
  final double longitude;
  
  @HiveField(8)
  final String phoneNumber;
  
  @HiveField(9)
  final String? email;
  
  @HiveField(10)
  final List<String> services;
  
  @HiveField(11)
  final bool is24Hours;
  
  HealthFacility({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.province,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    this.email,
    this.services = const [],
    this.is24Hours = false,
  });
}