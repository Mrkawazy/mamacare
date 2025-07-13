import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  late Box _auditLogBox;
  List<Map<String, dynamic>> _logs = [];
  String _searchQuery = '';
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    _auditLogBox = Hive.box('audit_logs');
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final allLogs = _auditLogBox.values.cast<Map<String, dynamic>>().toList();
    
    setState(() {
      _logs = allLogs.where((log) {
        final matchesSearch = log['action'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            log['userId'].toString().contains(_searchQuery);
        
        final matchesDate = _dateRange == null || 
            (DateTime.parse(log['timestamp']).isAfter(_dateRange!.start) &&
            DateTime.parse(log['timestamp']).isBefore(_dateRange!.end));
        
        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    );
    
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: initialDateRange,
    );
    
    if (pickedRange != null) {
      setState(() => _dateRange = pickedRange);
      _loadLogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Logs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search Logs',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                      _loadLogs();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: () => _selectDateRange(context),
                ),
              ],
            ),
          ),
          if (_dateRange != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MMM d, y').format(_dateRange!.start),
                  ),
                  const Text(' to '),
                  Text(
                    DateFormat('MMM d, y').format(_dateRange!.end),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      setState(() => _dateRange = null);
                      _loadLogs();
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: Icon(
                      _getActionIcon(log['action']),
                      color: _getActionColor(log['action']),
                    ),
                    title: Text(log['action']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User: ${log['userId']}'),
                        Text('Date: ${DateFormat('MMM d, y - h:mm a').format(DateTime.parse(log['timestamp']))}'),
                        if (log['details'] != null) Text('Details: ${log['details']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActionIcon(String action) {
    if (action.toLowerCase().contains('login')) return Icons.login;
    if (action.toLowerCase().contains('create')) return Icons.add;
    if (action.toLowerCase().contains('delete')) return Icons.delete;
    if (action.toLowerCase().contains('update')) return Icons.edit;
    return Icons.history;
  }

  Color _getActionColor(String action) {
    if (action.toLowerCase().contains('delete')) return Colors.red;
    if (action.toLowerCase().contains('create')) return Colors.green;
    if (action.toLowerCase().contains('update')) return Colors.blue;
    return Colors.grey;
  }
}