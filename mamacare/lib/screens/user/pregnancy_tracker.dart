import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/milestone.dart';
import 'package:mamacare/models/pregnancy.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PregnancyTrackerScreen extends StatefulWidget {
  const PregnancyTrackerScreen({super.key});

  @override
  State<PregnancyTrackerScreen> createState() => _PregnancyTrackerScreenState();
}

class _PregnancyTrackerScreenState extends State<PregnancyTrackerScreen> {
  late final Box<Pregnancy> _pregnancyBox;
  Pregnancy? _currentPregnancy;
  bool _isLoading = true;
  late CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _initPregnancyData();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Future<void> _initPregnancyData() async {
    try {
      _pregnancyBox = Hive.box<Pregnancy>('pregnancies');
      await _loadPregnancy();
    } catch (e) {
      debugPrint('Error loading pregnancy data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadPregnancy() async {
    if (_pregnancyBox.isNotEmpty && mounted) {
      setState(() {
        _currentPregnancy = _pregnancyBox.values.firstWhere(
          (p) => p.isActive,
          orElse: () => _pregnancyBox.values.first,
        );
      });
    }
  }

  Future<void> _addPregnancy() async {
    final lastPeriod = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (lastPeriod == null || !mounted) return;

    final estimatedDelivery = lastPeriod.add(const Duration(days: 280));
    final pregnancy = Pregnancy(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user_id',
      lastMenstrualPeriod: lastPeriod,
      estimatedDeliveryDate: estimatedDelivery,
      milestones: _generateMilestones(lastPeriod, estimatedDelivery),
      isActive: true,
    );

    await _pregnancyBox.put(pregnancy.id, pregnancy);
    if (mounted) await _loadPregnancy();
  }

  List<Milestone> _generateMilestones(DateTime lastPeriod, DateTime edd) {
    return [
      Milestone(
        title: 'First Trimester Ends',
        description: 'End of first trimester (12 weeks)',
        expectedDate: lastPeriod.add(const Duration(days: 84)),
        isCompleted: false,
      ),
      Milestone(
        title: 'Second Trimester Ends',
        description: 'End of second trimester (27 weeks)',
        expectedDate: lastPeriod.add(const Duration(days: 189)),
        isCompleted: false,
      ),
      Milestone(
        title: 'Third Trimester Starts',
        description: 'Start of third trimester (28 weeks)',
        expectedDate: lastPeriod.add(const Duration(days: 196)),
        isCompleted: false,
      ),
      Milestone(
        title: 'Expected Delivery Date',
        description: 'Baby is due!',
        expectedDate: edd,
        isCompleted: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pregnancy Tracker')),
      body: _currentPregnancy == null
          ? _buildEmptyState()
          : _buildPregnancyContent(),
      floatingActionButton: _currentPregnancy == null
          ? FloatingActionButton(
              onPressed: _addPregnancy,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No active pregnancy tracked'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addPregnancy,
            child: const Text('Start Tracking Pregnancy'),
          ),
        ],
      ),
    );
  }

  Widget _buildPregnancyContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPregnancyOverview(),
          const SizedBox(height: 24),
          _buildMilestones(),
          const SizedBox(height: 24),
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildPregnancyOverview() {
    final duration = DateTime.now().difference(_currentPregnancy!.lastMenstrualPeriod);
    final weeks = duration.inDays ~/ 7;
    final days = duration.inDays % 7;
    final progress = weeks / 40;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pregnancy Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 20,
              backgroundColor: Colors.grey[200],
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Week $weeks + $days days'),
                Text('${40 - weeks} weeks to go'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateInfo('Last Period', _currentPregnancy!.lastMenstrualPeriod),
                _buildDateInfo('Due Date', _currentPregnancy!.estimatedDeliveryDate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Text(DateFormat('MMM d, y').format(date)),
      ],
    );
  }

  Widget _buildMilestones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Milestones',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._currentPregnancy!.milestones.map(_buildMilestoneCard).toList(),
      ],
    );
  }

  Widget _buildMilestoneCard(Milestone milestone) {
    final daysToGo = milestone.expectedDate.difference(DateTime.now()).inDays;
    final dateText = DateFormat('MMM d, y').format(milestone.expectedDate);
    final statusText = daysToGo > 0 ? '$daysToGo days to go' : '${-daysToGo} days ago';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.flag, color: Colors.blue),
        title: Text(milestone.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(milestone.description),
            Text('$dateText ($statusText)'),
          ],
        ),
        trailing: Checkbox(
          value: milestone.isCompleted,
          onChanged: (value) => _toggleMilestoneCompletion(milestone, value),
        ),
        onTap: () => _zoomToCalendarDate(milestone.expectedDate),
      ),
    );
  }

  void _toggleMilestoneCompletion(Milestone milestone, bool? value) {
    if (value == null || !mounted) return;

    setState(() {
      milestone.isCompleted = value;
      _pregnancyBox.put(_currentPregnancy!.id, _currentPregnancy!);
    });
  }

  Widget _buildCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pregnancy Calendar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 400,
          child: SfCalendar(
            controller: _calendarController,
            view: CalendarView.month,
            dataSource: _getCalendarDataSource(),
            monthViewSettings: const MonthViewSettings(
              showAgenda: true,
              agendaViewHeight: 150,
            ),
            onTap: (calendarTapDetails) {
              if (calendarTapDetails.appointments != null && calendarTapDetails.appointments!.isNotEmpty) {
                _showAppointmentDetails(calendarTapDetails.appointments!.first);
              }
            },
          ),
        ),
      ],
    );
  }

  MeetingDataSource _getCalendarDataSource() {
    final appointments = _currentPregnancy!.milestones.map((milestone) {
      return Appointment(
        startTime: milestone.expectedDate,
        endTime: milestone.expectedDate.add(const Duration(hours: 1)),
        subject: milestone.title,
        color: milestone.isCompleted ? Colors.green : Colors.blue,
        notes: milestone.description,
      );
    }).toList();

    return MeetingDataSource(
    appointments,
    );
  }

  void _zoomToCalendarDate(DateTime date) {
    
    setState(() {
      _calendarController.displayDate = date;
    });
    
  
    _calendarController.view = CalendarView.month;
  }

  void _showAppointmentDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(appointment.subject),
        content: Text(appointment.notes ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}