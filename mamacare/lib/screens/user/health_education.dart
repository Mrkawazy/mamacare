import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/health_education.dart';

class HealthEducationScreen extends StatefulWidget {
  const HealthEducationScreen({super.key});

  @override
  State<HealthEducationScreen> createState() => _HealthEducationScreenState();
}

class _HealthEducationScreenState extends State<HealthEducationScreen> {
  late Box<HealthEducation> _educationBox;
  List<HealthEducation> _educationItems = [];
  EducationCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _educationBox = Hive.box<HealthEducation>('health_education');
    _loadEducationItems();
  }

  Future<void> _loadEducationItems() async {
    setState(() {
      _educationItems = _educationBox.values.where((item) {
        return _selectedCategory == null || item.category == _selectedCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Education'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: EducationCategory.values.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(_getCategoryName(category)),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? category : null;
                        });
                        _loadEducationItems();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _educationItems.length,
              itemBuilder: (context, index) {
                final item = _educationItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: item.imageUrl != null
                        ? Image.network(item.imageUrl!, width: 50, height: 50)
                        : Icon(_getCategoryIcon(item.category)),
                    title: Text(item.title),
                    subtitle: Text(_getCategoryName(item.category)),
                    onTap: () {
                      _showEducationDetail(item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEducationDetail(HealthEducation item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          initialChildSize: 0.7,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(_getCategoryName(item.category)),
                    ),
                    const SizedBox(height: 16),
                    if (item.imageUrl != null)
                      Container(
                        height: 200,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(item.imageUrl!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    Text(
                      item.content,
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (item.author != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Source: ${item.author}',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getCategoryName(EducationCategory category) {
    switch (category) {
      case EducationCategory.nutrition:
        return 'Nutrition';
      case EducationCategory.pregnancy:
        return 'Pregnancy';
      case EducationCategory.childcare:
        return 'Child Care';
      case EducationCategory.breastfeeding:
        return 'Breastfeeding';
      case EducationCategory.family_planning:
        return 'Family Planning';
      case EducationCategory.hygiene:
        return 'Hygiene';
      case EducationCategory.disease_prevention:
        return 'Disease Prevention';
    }
  }

  IconData _getCategoryIcon(EducationCategory category) {
    switch (category) {
      case EducationCategory.nutrition:
        return Icons.restaurant;
      case EducationCategory.pregnancy:
        return Icons.pregnant_woman;
      case EducationCategory.childcare:
        return Icons.child_care;
      case EducationCategory.breastfeeding:
        return Icons.health_and_safety;
      case EducationCategory.family_planning:
        return Icons.family_restroom;
      case EducationCategory.hygiene:
        return Icons.clean_hands;
      case EducationCategory.disease_prevention:
        return Icons.medical_services;
    }
  }
}