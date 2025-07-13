import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/health_education.dart';

class ContentManagementScreen extends StatefulWidget {
  const ContentManagementScreen({super.key});

  @override
  State<ContentManagementScreen> createState() => _ContentManagementScreenState();
}

class _ContentManagementScreenState extends State<ContentManagementScreen> {
  late Box<HealthEducation> _contentBox;
  List<HealthEducation> _contentItems = [];

  @override
  void initState() {
    super.initState();
    _contentBox = Hive.box<HealthEducation>('health_education');
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() {
      _contentItems = _contentBox.values.toList();
    });
  }

  Future<void> _addNewContent() async {
    // Implementation for adding new content
    // This would show a dialog with a form
  }

  Future<void> _editContent(HealthEducation item) async {
    // Implementation for editing content
  }

  Future<void> _deleteContent(String id) async {
    await _contentBox.delete(id);
    _loadContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Education Content'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewContent,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _contentItems.length,
        itemBuilder: (context, index) {
          final item = _contentItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: item.imageUrl != null 
                  ? Image.network(item.imageUrl!, width: 50, height: 50)
                  : const Icon(Icons.article, size: 40),
              title: Text(item.title),
              subtitle: Text(item.category.toString().split('.').last),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _editContent(item);
                  } else if (value == 'delete') {
                    _deleteContent(item.id);
                  }
                },
              ),
              onTap: () => _editContent(item),
            ),
          );
        },
      ),
    );
  }
}