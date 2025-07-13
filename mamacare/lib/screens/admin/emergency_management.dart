import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/emergency.dart';
import 'package:mamacare/utils/constants.dart';

class ManageEmergencyContactsScreen extends StatefulWidget {
  const ManageEmergencyContactsScreen({super.key});

  @override
  State<ManageEmergencyContactsScreen> createState() => _ManageEmergencyContactsScreenState();
}

class _ManageEmergencyContactsScreenState extends State<ManageEmergencyContactsScreen> {
  late Box<Emergency> _emergenciesBox;
  List<Emergency> _emergencies = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedType = 'Ambulance';
  String? _selectedProvince;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _emergenciesBox = Hive.box<Emergency>('emergencies');
    _loadEmergencies();
  }

  Future<void> _loadEmergencies() async {
    setState(() => _isLoading = true);
    _emergencies = _emergenciesBox.values.toList();
    setState(() => _isLoading = false);
  }

  Future<void> _addEmergency() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final emergency = Emergency(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      phone: _phoneController.text,
      type: _selectedType,
      province: _selectedProvince,
    );

    await _emergenciesBox.put(emergency.id, emergency);
    _loadEmergencies();
    
    _nameController.clear();
    _phoneController.clear();
    _selectedProvince = null;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Emergency contact added successfully')),
    );
  }

  Future<void> _deleteEmergency(String id) async {
    await _emergenciesBox.delete(id);
    _loadEmergencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Emergency Contacts'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _emergencies.length,
                    itemBuilder: (context, index) {
                      final emergency = _emergencies[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(emergency.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${emergency.phone} • ${emergency.type}'),
                              if (emergency.province != null)
                                Text(emergency.province!),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEmergency(emergency.id),
                          ),
                          onTap: () {
                            _nameController.text = emergency.name;
                            _phoneController.text = emergency.phone;
                            _selectedType = emergency.type;
                            _selectedProvince = emergency.province;
                            showAddEditDialog(context, isEditing: true, id: emergency.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddEditDialog(BuildContext context, {bool isEditing = false, String? id}) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(isEditing ? 'Edit Contact' : 'Add New Contact'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Service Name*'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number*'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    items: const [
                      DropdownMenuItem(value: 'Ambulance', child: Text('Ambulance')),
                      DropdownMenuItem(value: 'Police', child: Text('Police')),
                      DropdownMenuItem(value: 'Fire', child: Text('Fire')),
                      DropdownMenuItem(value: 'Child Protection', child: Text('Child Protection')),
                      DropdownMenuItem(value: 'Medical Emergency', child: Text('Medical Emergency')),
                    ],
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedProvince,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('National')),
                      ...AppConstants.provinces.map((province) => 
                        DropdownMenuItem(value: province, child: Text(province))
                      ),
                    ],
                    onChanged: (value) => setState(() => _selectedProvince = value),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _nameController.clear();
                  _phoneController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (isEditing && id != null) {
                    final emergency = Emergency(
                      id: id,
                      name: _nameController.text,
                      phone: _phoneController.text,
                      type: _selectedType,
                      province: _selectedProvince,
                    );
                    await _emergenciesBox.put(id, emergency);
                  } else {
                    await _addEmergency();
                  }
                  _loadEmergencies();
                  Navigator.pop(context);
                },
                child: Text(isEditing ? 'Update' : 'Add'),
              ),
            ],
          );
        },
      ),
    );
  }
}