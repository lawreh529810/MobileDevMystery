class Task {
  String name;
  String priority;
  bool isCompleted;

  Task({
    required this.name,
    required this.priority,
    this.isCompleted = false,
  });
}
