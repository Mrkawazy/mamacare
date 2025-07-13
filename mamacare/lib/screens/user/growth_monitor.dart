import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/child.dart';
import 'package:mamacare/utils/constants.dart';
import 'package:mamacare/utils/helpers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GrowthMonitorScreen extends StatefulWidget {
  const GrowthMonitorScreen({super.key});

  @override
  State<GrowthMonitorScreen> createState() => _GrowthMonitorScreenState();
}

class _GrowthMonitorScreenState extends State<GrowthMonitorScreen> {
  late Box<Child> _childrenBox;
  List<Child> _children = [];
  Child? _selectedChild;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _gender = 'Male';
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    _childrenBox = Hive.box<Child>('children');
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    setState(() {
      _children = _childrenBox.values.toList();
      if (_children.isNotEmpty) {
        _selectedChild = _children.first;
      }
    });
  }

  Future<void> _addChild() async {
    if (_nameController.text.isEmpty || 
        _birthDate == null || 
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final child = Child(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user_id', // Replace with actual user ID
      name: _nameController.text,
      birthDate: _birthDate!,
      gender: _gender,
      birthWeight: double.parse(_weightController.text),
      growthRecords: [
        {
          'date': DateTime.now(),
          'weight': double.parse(_weightController.text),
          'height': _heightController.text.isNotEmpty 
              ? double.parse(_heightController.text) 
              : null,
          'muac': null,
          'notes': 'Initial registration',
        }
      ],
      vaccinationRecords: [],
    );

    await _childrenBox.put(child.id, child);
    _loadChildren();
    
    _nameController.clear();
    _birthDateController.clear();
    _weightController.clear();
    _heightController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Child registered successfully')),
    );
  }

  Future<void> _addGrowthRecord() async {
    if (_selectedChild == null || _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a child and enter weight')),
      );
      return;
    }

    final record = {
      'date': DateTime.now(),
      'weight': double.parse(_weightController.text),
      'height': _heightController.text.isNotEmpty 
          ? double.parse(_heightController.text) 
          : null,
      'muac': null,
      'notes': 'Regular checkup',
    };

    _selectedChild!.growthRecords.add(record);
    await _childrenBox.put(_selectedChild!.id, _selectedChild!);
    _loadChildren();
    
    _weightController.clear();
    _heightController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Growth record added successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Child Growth Monitor'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.child_care), text: 'My Children'),
              Tab(icon: Icon(Icons.add), text: 'Register Child'),
              Tab(icon: Icon(Icons.show_chart), text: 'Growth Charts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // My Children Tab
            ListView.builder(
              itemCount: _children.length,
              itemBuilder: (context, index) {
                final child = _children[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(child.name),
                    subtitle: Text(
                        '${child.gender} | ${AppHelpers.formatDate(child.birthDate)}'),
                    trailing: Text(
                        '${child.growthRecords.last['weight']} kg'),
                    onTap: () {
                      setState(() {
                        _selectedChild = child;
                      });
                    },
                    selected: _selectedChild?.id == child.id,
                  ),
                );
              },
            ),

            // Register Child Tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Child's Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(
                      labelText: "Date of Birth",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _birthDate = date;
                          _birthDateController.text = AppHelpers.formatDate(date);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: "Birth Weight (kg)",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _heightController,
                    decoration: const InputDecoration(
                      labelText: "Length/Height (cm) - Optional",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _addChild,
                    child: const Text('Register Child'),
                  ),
                ],
              ),
            ),

            // Growth Charts Tab
            _selectedChild == null
                ? const Center(child: Text('No child selected'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Growth Chart for ${_selectedChild!.name}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            series: <LineSeries<Map<String, dynamic>, String>>[
                              LineSeries<Map<String, dynamic>, String>(
                                dataSource: _selectedChild!.growthRecords,
                                xValueMapper: (record, _) =>
                                    AppHelpers.formatDate(record['date']),
                                yValueMapper: (record, _) => record['weight'],
                                name: 'Weight (kg)',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Add New Growth Record',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _weightController,
                          decoration: const InputDecoration(
                            labelText: "Current Weight (kg)",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _heightController,
                          decoration: const InputDecoration(
                            labelText: "Current Height (cm) - Optional",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _addGrowthRecord,
                          child: const Text('Add Growth Record'),
                        ),
                        const SizedBox(height: 24),
                        const VaccinationScheduleWidget(),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}