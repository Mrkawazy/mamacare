import 'package:hive/hive.dart';

part 'child.g.dart';

@HiveType(typeId: 5)
class Child {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final DateTime dateOfBirth;
  
  @HiveField(4)
  final String gender;
  
  @HiveField(5)
  final double birthWeight;
  
  @HiveField(6)
  final List<GrowthRecord> growthRecords;
  
  @HiveField(7)
  final List<VaccinationRecord> vaccinations;
  
  Child({
    required this.id,
    required this.userId,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.birthWeight,
    this.growthRecords = const [],
    this.vaccinations = const [],
  });
}

@HiveType(typeId: 6)
class GrowthRecord {
  @HiveField(0)
  final DateTime date;
  
  @HiveField(1)
  final double weight;
  
  @HiveField(2)
  final double height;
  
  @HiveField(3)
  final double headCircumference;
  
  @HiveField(4)
  final double muac; // Mid-upper arm circumference
  
  @HiveField(5)
  final String? notes;
  
  GrowthRecord({
    required this.date,
    required this.weight,
    required this.height,
    required this.headCircumference,
    required this.muac,
    this.notes,
  });
}

@HiveType(typeId: 7)
class VaccinationRecord {
  @HiveField(0)
  final String vaccineName;
  
  @HiveField(1)
  final DateTime dueDate;
  
  @HiveField(2)
  final DateTime? administeredDate;
  
  @HiveField(3)
  final bool isAdministered;
  
  @HiveField(4)
  final String? facility;
  
  @HiveField(5)
  final String? batchNumber;
  
  VaccinationRecord({
    required this.vaccineName,
    required this.dueDate,
    this.administeredDate,
    this.isAdministered = false,
    this.facility,
    this.batchNumber,
  });
}