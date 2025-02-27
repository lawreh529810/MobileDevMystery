import 'package:flutter/material.dart';
import 'task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> tasks = [];
  final TextEditingController taskController = TextEditingController();
  String selectedPriority = "Low"; // Default priority

  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(Task(name: taskController.text, priority: selectedPriority));
        taskController.clear();
      });
    }
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Manager")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(labelText: "Enter task"),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedPriority,
                  items: ["Low", "Medium", "High"]
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value!;
                    });
                  },
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addTask,
                  child: Text("Add"),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: tasks[index].isCompleted,
                        onChanged: (_) => toggleTaskCompletion(index),
                      ),
                      title: Text(
                        tasks[index].name,
                        style: TextStyle(
                          decoration: tasks[index].isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text("Priority: ${tasks[index].priority}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteTask(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
