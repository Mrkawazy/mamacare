import 'package:flutter/material.dart';
import 'package:mamacare/models/emergency.dart';
import 'package:hive/hive.dart';

class AddEditEmergencyScreen extends StatefulWidget {
  final EmergencyContact? existingContact;

  const AddEditEmergencyScreen({super.key, this.existingContact});

  @override
  State<AddEditEmergencyScreen> createState() => _AddEditEmergencyScreenState();
}

class _AddEditEmergencyScreenState extends State<AddEditEmergencyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late EmergencyType _selectedType;
  String? _selectedProvince;

  final List<String> _zimbabweProvinces = [
    'Bulawayo',
    'Harare',
    'Manicaland',
    'Mashonaland Central',
    'Mashonaland East',
    'Mashonaland West',
    'Masvingo',
    'Matabeleland North',
    'Matabeleland South',
    'Midlands',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
        text: widget.existingContact?.name ?? '');
    _phoneController = TextEditingController(
        text: widget.existingContact?.phoneNumber ?? '');
    _locationController = TextEditingController(
        text: widget.existingContact?.location ?? '');
    _selectedType = widget.existingContact?.type ?? EmergencyType.medical;
    _selectedProvince = widget.existingContact?.province;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveContact() async {
    if (_formKey.currentState!.validate()) {
      final contactsBox = Hive.box<EmergencyContact>('emergency_contacts');
      
      final contact = EmergencyContact(
        id: widget.existingContact?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        type: _selectedType,
        phoneNumber: _phoneController.text,
        location: _locationController.text.isEmpty ? null : _locationController.text,
        province: _selectedProvince,
      );

      await contactsBox.put(contact.id, contact);
      
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingContact == null 
              ? 'Add Emergency Contact' 
              : 'Edit Emergency Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<EmergencyType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Contact Type',
                    border: OutlineInputBorder(),
                  ),
                  items: EmergencyType.values.map((type) {
                    return DropdownMenuItem<EmergencyType>(
                      value: type,
                      child: Text(_getEmergencyTypeName(type)),
                    );
                  }).toList(),
                  onChanged: (type) {
                    if (type != null) {
                      setState(() {
                        _selectedType = type;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name/Organization',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixText: '+263 ',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    if (!RegExp(r'^[0-9]{9}$').hasMatch(value)) {
                      return 'Please enter a valid Zimbabwean number (e.g., 771234567)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedProvince,
                  decoration: const InputDecoration(
                    labelText: 'Province (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  items: _zimbabweProvinces.map((province) {
                    return DropdownMenuItem<String>(
                      value: province,
                      child: Text(province),
                    );
                  }).toList(),
                  onChanged: (province) {
                    setState(() {
                      _selectedProvince = province;
                    });
                  },
                  hint: const Text('Select Province'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveContact,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Save Contact'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getEmergencyTypeName(EmergencyType type) {
    switch (type) {
      case EmergencyType.medical:
        return 'Medical Emergency';
      case EmergencyType.police:
        return 'Police';
      case EmergencyType.fire:
        return 'Fire Brigade';
      case EmergencyType.ambulance:
        return 'Ambulance Service';
    }
  }
}