import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddExerciseScreen extends StatefulWidget {
  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();

  final String apiUrl = "https://widebrasssled61.conveyor.cloud/api/ExerciseListApi";

  Future<void> addExercise() async {
    final newExercise = {
      'name': nameController.text,
      'exerciseTime': timeController.text,
      'userId': userIdController.text,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newExercise),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      Navigator.pop(context, true); // Quay lại màn hình trước với kết quả thành công
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add exercise: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Exercise')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Exercise Name'),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Exercise Time (YYYY-MM-DDTHH:mm:ss)'),
            ),
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addExercise,
              child: const Text('Add Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}