import 'package:hive/hive.dart';
import 'milestone.dart';  // Import the Milestone class

part 'pregnancy.g.dart';

@HiveType(typeId: 2)
class Pregnancy {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final DateTime lastMenstrualPeriod;
  
  @HiveField(3)
  final DateTime estimatedDeliveryDate;
  
  @HiveField(4)
  final List<Milestone> milestones;
  
  @HiveField(5)
  final List<PregnancyCheckup> checkups;
  
  @HiveField(6)
  final bool isActive;
  
  Pregnancy({
    required this.id,
    required this.userId,
    required this.lastMenstrualPeriod,
    required this.estimatedDeliveryDate,
    required this.milestones,
    this.checkups = const [],
    this.isActive = true,
  });
}