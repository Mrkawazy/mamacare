import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/pregnancy.dart';
import 'package:mamacare/models/child.dart';
import 'package:mamacare/models/emergency.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late Box<Pregnancy> _pregnancyBox;
  late Box<Child> _childBox;
  late Box<EmergencyReport> _emergencyBox;
  int _activePregnancies = 0;
  int _registeredChildren = 0;
  int _emergencyReports = 0;

  @override
  void initState() {
    super.initState();
    _pregnancyBox = Hive.box<Pregnancy>('pregnancies');
    _childBox = Hive.box<Child>('children');
    _emergencyBox = Hive.box<EmergencyReport>('emergency_reports');
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _activePregnancies = _pregnancyBox.values.where((p) => p.isActive).length;
      _registeredChildren = _childBox.values.length;
      _emergencyReports = _emergencyBox.values.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Reports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatsCard(),
            const SizedBox(height: 20),
            _buildPregnancyChart(),
            const SizedBox(height: 20),
            _buildEmergencyChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Active Pregnancies', _activePregnancies),
            _buildStatItem('Registered Children', _registeredChildren),
            _buildStatItem('Emergency Reports', _emergencyReports),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildPregnancyChart() {
    final data = [
      {'month': 'Jan', 'count': 5},
      {'month': 'Feb', 'count': 8},
      {'month': 'Mar', 'count': 12},
      // Add more data from your actual database
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pregnancy Registrations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: data,
                    xValueMapper: (Map<String, dynamic> data, _) => data['month'],
                    yValueMapper: (Map<String, dynamic> data, _) => data['count'],
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyChart() {
    // Similar implementation for emergency reports chart
    // ...
    return Container(); // Replace with actual chart
  }
}