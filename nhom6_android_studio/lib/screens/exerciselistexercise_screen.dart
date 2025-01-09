import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/exercisepost.dart';

class ExerciselistexerciseScreen extends StatelessWidget {
  final ExercisePost exerciseList;

  ExerciselistexerciseScreen({required this.exerciseList});

  @override
  Widget build(BuildContext context) {
    // List of all exercises (this can be fetched from the backend)
    final List<ExercisePost> allExercises = [
      ExercisePost(
        id: 1,
        name: "Push-ups",
        description: "A basic exercise for upper body strength.",
        img: "https://example.com/pushups.jpg",
        instruct: "Keep your back straight.",
        timeOnly: "30s",
        slThucHien: 10,
        reps: 15,
        categoryExerciseId: 1,
      ),
      // Add more exercises
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Exercises for ${exerciseList.name}"),
      ),
      body: ListView.builder(
        itemCount: allExercises.length,
        itemBuilder: (context, index) {
          final exercise = allExercises[index];
          return Card(
            child: ListTile(
              leading: exercise.img != null
                  ? Image.network(exercise.img!, width: 50, height: 50, fit: BoxFit.cover)
                  : const Icon(Icons.fitness_center),
              title: Text(exercise.name ?? "Unnamed Exercise"),
              subtitle: Text(exercise.description ?? "No description available."),
              trailing: ElevatedButton(
                onPressed: () {
                  // Logic to add the exercise to the Exercise List
                  // e.g., make an API call to associate the exercise with the list
                },
                child: const Text("Add"),
              ),
            ),
          );
        },
      ),
    );
  }
}
