import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
enum UserRole {
  @HiveField(0)
  superuser,
  
  @HiveField(1)
  admin,
  
  @HiveField(2)
  user,
}

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String fullName;
  
  @HiveField(2)
  final String email;
  
  @HiveField(3)
  final String phoneNumber;
  
  @HiveField(4)
  final String passwordHash; // Always store hashed passwords
  
  @HiveField(5)
  final UserRole role;
  
  @HiveField(6)
  final DateTime registeredAt;
  
  @HiveField(7)
  final String? address;
  
  @HiveField(8)
  final String? province; // Zimbabwean province
  
  @HiveField(9)
  final DateTime? dateOfBirth;
  
  @HiveField(10)
  final bool isActive;
  
  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.passwordHash,
    required this.role,
    required this.registeredAt,
    this.address,
    this.province,
    this.dateOfBirth,
    this.isActive = true,
  });
}