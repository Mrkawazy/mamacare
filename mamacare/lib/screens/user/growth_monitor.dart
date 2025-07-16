import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/child.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GrowthMonitorScreen extends StatefulWidget {
  const GrowthMonitorScreen({super.key});

  @override
  State<GrowthMonitorScreen> createState() => _GrowthMonitorScreenState();
}

class _GrowthMonitorScreenState extends State<GrowthMonitorScreen> {
  late Box<Child> _childrenBox;
  List<Child> _children = [];

  @override
  void initState() {
    super.initState();
    _childrenBox = Hive.box<Child>('children');
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    setState(() {
      _children = _childrenBox.values.toList();
    });
  }

  Future<void> _addChild() async {
    // Implement child registration
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Growth Monitor'),
      ),
      body: _children.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No children registered'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addChild,
                    child: const Text('Register Child'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildChildrenList(),
                  const SizedBox(height: 24),
                  _buildGrowthCharts(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addChild,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildChildrenList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Children',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._children.map((child) {
          final age = _calculateAge(child.dateOfBirth);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.child_care),
              title: Text(child.name),
              subtitle: Text('${child.gender} • ${age.years} years ${age.months} months'),
              trailing: IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  // Navigate to child details
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildGrowthCharts() {
    if (_children.isEmpty) return const SizedBox();

    // For demo, using first child's data
    final child = _children.first;
    final weightData = child.growthRecords
        .map((record) => _GrowthChartData(record.date, record.weight))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Growth Charts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            series: <CartesianSeries<_GrowthChartData, DateTime>>[
              LineSeries<_GrowthChartData, DateTime>(
                dataSource: weightData,
                xValueMapper: (_GrowthChartData data, _) => data.date,
                yValueMapper: (_GrowthChartData data, _) => data.value,
                name: 'Weight (kg)',
              ),
            ],
          ),
        ),
      ],
    );
  }

  _Age _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;

    if (months < 0) {
      years--;
      months += 12;
    }

    return _Age(years: years, months: months);
  }
}

class _GrowthChartData {
  final DateTime date;
  final double value;

  _GrowthChartData(this.date, this.value);
}

class _Age {
  final int years;
  final int months;

  _Age({required this.years, required this.months});
}