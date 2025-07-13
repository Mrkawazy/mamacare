import 'package:hive/hive.dart';

part 'health_education.g.dart';

@HiveType(typeId: 8)
enum EducationCategory {
  @HiveField(0)
  nutrition,
  
  @HiveField(1)
  pregnancy,
  
  @HiveField(2)
  childcare,
  
  @HiveField(3)
  breastfeeding,
  
  @HiveField(4)
  family_planning,
  
  @HiveField(5)
  hygiene,
  
  @HiveField(6)
  disease_prevention,
}

@HiveType(typeId: 9)
class HealthEducation {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final EducationCategory category;
  
  @HiveField(3)
  final String content;
  
  @HiveField(4)
  final String? imageUrl;
  
  @HiveField(5)
  final DateTime publishDate;
  
  @HiveField(6)
  final String? author;
  
  @HiveField(7)
  final bool isFeatured;
  
  HealthEducation({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    this.imageUrl,
    required this.publishDate,
    this.author,
    this.isFeatured = false,
  });
}