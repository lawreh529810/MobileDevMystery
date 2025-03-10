// AdoptionAndTravelListApp - CSC 4360 Mobile App Development

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const AdoptionAndTravelListApp());
}

class AdoptionAndTravelListApp extends StatelessWidget {
  const AdoptionAndTravelListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adoption & Travel List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlanManagerScreen(),
    );
  }
}

class Plan {
  String name;
  String description;
  DateTime date;
  String priority;
  bool isCompleted;

  Plan({
    required this.name,
    required this.description,
    required this.date,
    required this.priority,
    this.isCompleted = false,
  });
}

class PlanManagerScreen extends StatefulWidget {
  const PlanManagerScreen({super.key});

  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  final List<Plan> _plans = [];
  DateTime _selectedDate = DateTime.now();

  void _addPlan(
      String name, String description, DateTime date, String priority) {
    setState(() {
      _plans.add(Plan(
          name: name,
          description: description,
          date: date,
          priority: priority));
      _sortPlansByPriority();
    });
  }

  void _toggleCompletion(int index) {
    setState(() {
      _plans[index].isCompleted = !_plans[index].isCompleted;
    });
  }

  void _sortPlansByPriority() {
    _plans.sort((a, b) {
      const priorities = {'High': 3, 'Medium': 2, 'Low': 1};
      return priorities[b.priority]!.compareTo(priorities[a.priority]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adoption & Travel Plans')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDate,
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];
                if (!isSameDay(plan.date, _selectedDate)) return Container();

                return LongPressDraggable<Plan>(
                  data: plan,
                  feedback: Material(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.blueAccent,
                      child: Text(plan.name,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  child: ListTile(
                    title: Text(plan.name),
                    subtitle: Text(
                        'Priority: ${plan.priority} | Date: ${DateFormat.yMMMd().format(plan.date)}'),
                    tileColor:
                        plan.isCompleted ? Colors.green[100] : Colors.white,
                    onTap: () => _toggleCompletion(index),
                  ),
                );
              },
            ),
          ),
          DragTarget<Plan>(
            builder: (context, candidateData, rejectedData) {
              return Container(
                height: 100,
                color: Colors.grey[200],
                child: const Center(
                  child: Text('Drop Here to Mark Completed'),
                ),
              );
            },
            onAccept: (plan) {
              setState(() {
                plan.isCompleted = true;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlanDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPlanDialog() {
    String name = '';
    String description = '';
    DateTime date = _selectedDate;
    String priority = 'Medium';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => name = value,
                decoration: const InputDecoration(labelText: 'Plan Name'),
              ),
              TextField(
                onChanged: (value) => description = value,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              DropdownButton<String>(
                value: priority,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      priority = newValue;
                    });
                  }
                },
                items: ['Low', 'Medium', 'High'].map((String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _addPlan(name, description, date, priority);
                  Navigator.pop(context);
                },
                child: const Text('Add Plan'),
              ),
            ],
          ),
        );
      },
    );
  }
}


