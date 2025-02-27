class Task {
  String name;
  bool isCompleted;
  String priority; // Optional for graduate students

  Task({required this.name, this.isCompleted = false, this.priority = "Low"});
}
