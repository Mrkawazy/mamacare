import 'package:hive/hive.dart';

part 'milestone.g.dart';

@HiveType(typeId: 3)
class Milestone {
  @HiveField(0)
  final String title;
  
  @HiveField(1)
  final String description;
  
  @HiveField(2)
  final DateTime expectedDate;
  
  @HiveField(3)
  final DateTime? completedDate;
  
  @HiveField(4)
  bool isCompleted;
  
  @HiveField(5)
  final String? notes;
  
  Milestone({
    required this.title,
    required this.description,
    required this.expectedDate,
    this.completedDate,
    this.isCompleted = false,
    this.notes,
  });
}

@HiveType(typeId: 4)
class PregnancyCheckup {
  @HiveField(0)
  final DateTime date;
  
  @HiveField(1)
  final double weight;
  
  @HiveField(2)
  final double bloodPressure;
  
  @HiveField(3)
  final String? notes;
  
  @HiveField(4)
  final String? facility;
  
  PregnancyCheckup({
    required this.date,
    required this.weight,
    required this.bloodPressure,
    this.notes,
    this.facility,
  });
}