import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 161, 116, 185),
        ),
      ),
      home: const TodoPage(),
    );
  }
}

class Todo {
  String task;
  bool isDone;
  Todo({required this.task, this.isDone = false});
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<Todo> todos = [
    Todo(task: "Go For A Short Walk Or Exercise", isDone: true),
    Todo(task: "Go To Gym", isDone: true),
    Todo(task: "Father's Appointment", isDone: false),
    Todo(task: "Complete Homework", isDone: true),
    Todo(task: "Give Notes To A Friend", isDone: false),
  ];

  void addTodo(String task) {
    setState(() {
      todos.add(Todo(task: task));
    });
  }

  void removeTodo(Todo todo) {
    setState(() {
      todos.remove(todo);
    });
  }

  void toggleTodo(Todo todo, bool value) {
    setState(() {
      todo.isDone = value;
    });
  }

  void _showAddTodoDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add New Task"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter task"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                addTodo(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My To-Do List"),
        backgroundColor: const Color.fromARGB(255, 147, 104, 200),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return TodoItem(
              todo: todos[index],
              onToggle: (value) => toggleTodo(todos[index], value),
              onDelete: () => removeTodo(todos[index]),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        backgroundColor: const Color.fromARGB(255, 102, 33, 147),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const TodoItem({
    Key? key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (value) => onToggle(value!),
        ),
        title: Text(
          todo.task,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Color.fromARGB(255, 157, 31, 31)),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
