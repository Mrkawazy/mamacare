import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mamacare/models/pregnancy.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PregnancyTrackerScreen extends StatefulWidget {
  const PregnancyTrackerScreen({super.key});

  @override
  State<PregnancyTrackerScreen> createState() => _PregnancyTrackerScreenState();
}

class _PregnancyTrackerScreenState extends State<PregnancyTrackerScreen> {
  late Box<Pregnancy> _pregnancyBox;
  Pregnancy? _currentPregnancy;

  @override
  void initState() {
    super.initState();
    _pregnancyBox = Hive.box<Pregnancy>('pregnancies');
    _loadPregnancy();
  }

  Future<void> _loadPregnancy() async {
    if (_pregnancyBox.isNotEmpty) {
      setState(() {
        _currentPregnancy = _pregnancyBox.values.first;
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

    if (lastPeriod != null) {
      final estimatedDelivery = lastPeriod.add(const Duration(days: 280));
      final pregnancy = Pregnancy(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user_id', // Replace with actual user ID
        lastMenstrualPeriod: lastPeriod,
        estimatedDeliveryDate: estimatedDelivery,
        milestones: _generateMilestones(lastPeriod, estimatedDelivery),
        isActive: true,
      );

      await _pregnancyBox.put(pregnancy.id, pregnancy);
      _loadPregnancy();
    }
  }

  List<Milestone> _generateMilestones(DateTime lastPeriod, DateTime edd) {
    // Generate standard pregnancy milestones
    return [
      Milestone(
        title: 'First Trimester Ends',
        description: 'End of first trimester (12 weeks)',
        expectedDate: lastPeriod.add(const Duration(days: 84)),
      ),
      Milestone(
        title: 'Second Trimester Ends',
        description: 'End of second trimester (27 weeks)',
        expectedDate: lastPeriod.add(const Duration(days: 189)),
      ),
      Milestone(
        title: 'Third Trimester Starts',
        description: 'Start of third trimester (28 weeks)',
        expectedDate: lastPeriod.add(const Duration(days: 196)),
      ),
      Milestone(
        title: 'Expected Delivery Date',
        description: 'Baby is due!',
        expectedDate: edd,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pregnancy Tracker'),
      ),
      body: _currentPregnancy == null
          ? Center(
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
            )
          : SingleChildScrollView(
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
            ),
    );
  }

  Widget _buildPregnancyOverview() {
    final weeks = ((DateTime.now().difference(_currentPregnancy!.lastMenstrualPeriod).inDays / 7).floor();
    final days = ((DateTime.now().difference(_currentPregnancy!.lastMenstrualPeriod).inDays % 7);

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
              value: weeks / 40,
              minHeight: 20,
              backgroundColor: Colors.grey[200],
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Last Period'),
                    Text(DateFormat('MMM d, y').format(_currentPregnancy!.lastMenstrualPeriod)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Due Date'),
                    Text(DateFormat('MMM d, y').format(_currentPregnancy!.estimatedDeliveryDate)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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
        ..._currentPregnancy!.milestones.map((milestone) {
          final daysToGo = milestone.expectedDate.difference(DateTime.now()).inDays;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.flag),
              title: Text(milestone.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(milestone.description),
                  Text(
                    '${DateFormat('MMM d, y').format(milestone.expectedDate)} (${daysToGo > 0 ? '$daysToGo days to go' : '${-daysToGo} days ago'})',
                  ),
                ],
              ),
              trailing: Checkbox(
                value: milestone.isCompleted,
                onChanged: (value) {
                  // Update milestone completion status
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
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
          height: 300,
          child: SfCalendar(
            view: CalendarView.month,
            dataSource: _getCalendarDataSource(),
            monthViewSettings: const MonthViewSettings(
              showAgenda: true,
            ),
          ),
        ),
      ],
    );
  }

  CalendarDataSource _getCalendarDataSource() {
    final List<Appointment> appointments = [];

    // Add milestones as calendar events
    for (final milestone in _currentPregnancy!.milestones) {
      appointments.add(Appointment(
        startTime: milestone.expectedDate,
        endTime: milestone.expectedDate.add(const Duration(hours: 1)),
        subject: milestone.title,
        color: Colors.blue,
      ));
    }

    // Add checkups
    for (final checkup in _currentPregnancy!.checkups) {
      appointments.add(Appointment(
        startTime: checkup.date,
        endTime: checkup.date.add(const Duration(hours: 1)),
        subject: 'Pregnancy Checkup',
        color: Colors.green,
      ));
    }

    return _AppointmentDataSource(appointments);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}