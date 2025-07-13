import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/facility.dart';

class FacilityManagementScreen extends StatefulWidget {
  const FacilityManagementScreen({super.key});

  @override
  State<FacilityManagementScreen> createState() => _FacilityManagementScreenState();
}

class _FacilityManagementScreenState extends State<FacilityManagementScreen> {
  late Box<HealthFacility> _facilityBox;
  List<HealthFacility> _facilities = [];

  @override
  void initState() {
    super.initState();
    _facilityBox = Hive.box<HealthFacility>('facilities');
    _loadFacilities();
  }

  Future<void> _loadFacilities() async {
    setState(() {
      _facilities = _facilityBox.values.toList();
    });
  }

  Future<void> _addNewFacility() async {
    // Implementation for adding new facility
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Facility Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewFacility,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _facilities.length,
        itemBuilder: (context, index) {
          final facility = _facilities[index];
          return ListTile(
            leading: const Icon(Icons.local_hospital),
            title: Text(facility.name),
            subtitle: Text('${facility.district}, ${facility.province}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Edit facility
              },
            ),
            onTap: () {
              // Show facility details
            },
          );
        },
      ),
    );
  }
}