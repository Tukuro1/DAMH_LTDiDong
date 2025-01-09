import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:nhom6_android_studio/models/exerciselistexercise.dart';
import 'package:nhom6_android_studio/models/exerciselistpost.dart';
import 'package:nhom6_android_studio/models/exercisepost.dart';
import 'package:nhom6_android_studio/screens/select_exercise_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config_url.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  late Future<List<ExerciselistPost>> futureExercises;
  final String apiUrl = "${Config_URL.baseUrl}ExerciseListApi";

  @override
  void initState() {
    super.initState();
    _checkToken();
    futureExercises = fetchExerciseList();
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    if (token != null) {
      Map<String, dynamic> result = JwtDecoder.decode(token);
      String userId = result['UserId'];
      print('resultLogin: $result');
      print('UserIdEx: $userId');
    }
  }

  Future<List<ExerciselistPost>> fetchExerciseList() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => ExerciselistPost.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load exercises");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<void> refreshList() async {
    setState(() {
      futureExercises = fetchExerciseList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise List"),
      ),
      body: FutureBuilder<List<ExerciselistPost>>(
        future: futureExercises,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No exercises found"));
          }

          final exerciseList = snapshot.data!;
          return RefreshIndicator(
            onRefresh: refreshList,
            child: ListView.builder(
              itemCount: exerciseList.length,
              itemBuilder: (context, index) {
                final exercise = exerciseList[index];
                return ListTile(
                  title: Text(exercise.name ?? "Unknown"),
                  subtitle: Text(
                    "Time: ${exercise.exerciseTime?.toLocal().toString() ?? "Not set"}",
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ExerciseDetailScreen(exercise: exercise),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExerciseScreen()),
          );
          if (result == true) {
            refreshList();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddExerciseScreen extends StatefulWidget {
  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  bool isLoading = false;
  late int exerciseListId;
  DateTime? _selectedDateTime;
  Future<int?> _addExercise(String name, DateTime dateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String userId = decodedToken['UserId'];
      try {
        final response = await http.post(
          Uri.parse("${Config_URL.baseUrl}ExerciseListApi"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "name": name,
            "exerciseTime": dateTime.toIso8601String(),
            "userId": userId,
          }),
        );

        if (response.statusCode == 201) {
          final body = jsonDecode(response.body);
          int exerciseId = body['id'];
          return exerciseId;
        } else {
          print("Failed to add exercise: ${response.body}");
          return null;
        }
      } catch (e) {
        print("Error: $e");
        return null;
      }
    } else {
      print("Token not found");
      return null;
    }
  }

  Future<void> _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select date and time")),
        );
        return;
      }

      try {
        setState(() {
          isLoading = true;
        });
        await _addExercise(_name, _selectedDateTime!).then(
          (exerciseId) => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                SelectExerciseScreen(exerciseListId: exerciseId ?? 0),
          )),
        );
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Exercise"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Exercise Name"),
                onSaved: (value) => _name = value!,
                validator: (value) =>
                    value!.isEmpty ? "Please enter a name" : null,
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _selectDateTime,
                icon: const Icon(Icons.calendar_today),
                label: const Text("Select Date and Time"),
              ),
              if (_selectedDateTime != null)
                Text(
                  "Selected: ${_selectedDateTime!.toLocal()}",
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Add Exercise"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseDetailScreen extends StatefulWidget {
  final ExerciselistPost exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  bool isLoading = false;

  Future<List<Exerciselistexercise>>
      _fetchExerciseListExerciseByexerciseListId() async {
    try {
      final response = await http
          .get(Uri.parse('${Config_URL.baseUrl}ExerciseListExerciseApi'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        List<Exerciselistexercise> exerciselistexercises = jsonData
            .map((json) => Exerciselistexercise.fromJson(json))
            .toList();
        final result = exerciselistexercises
            .where(
              (element) => element.exerciseListId == widget.exercise.id,
            )
            .toList();
        return result;
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<ExercisePost>> getListExerciseApi() async {
    List<ExercisePost> exercisePosts = [];
    List<Exerciselistexercise> datas =
        await _fetchExerciseListExerciseByexerciseListId();
    for (int i = 0; i < datas.length; i++) {
      final exerciseId = datas[i].exerciseId;
      final response = await http
          .get(Uri.parse('${Config_URL.baseUrl}ExerciseApi/$exerciseId'));
      if (response.statusCode == 200) {
        final ExercisePost exercisePost =
            ExercisePost.fromJson(json.decode(response.body));
        exercisePosts.add(exercisePost);
      }
    }
    return exercisePosts;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name ?? "Exercise Details"),
      ),
      body: FutureBuilder(
          future: getListExerciseApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No exercises available'));
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Exercise Name: ${widget.exercise.name ?? "Unknown"}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Exercise Time: ${widget.exercise.exerciseTime?.toLocal() ?? "Not set"}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Exercise Time: ${widget.exercise.exerciseTime?.toLocal() ?? "Not set"}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final exercise = snapshot.data?[index];
                        return ListTile(
                          leading: const Icon(Icons.image_not_supported),
                          title: Text(exercise?.name ?? 'Unknown'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Description: ${exercise?.description ?? 'No description'}'),
                              Text(
                                  'Instructions: ${exercise?.instruct ?? 'No instructions'}'),
                              Text('Time: ${exercise?.timeOnly ?? 'No time'}'),
                              Text('Reps: ${exercise?.reps ?? 'No reps'}'),
                              Text(
                                  'Category ID: ${exercise?.categoryExerciseId ?? 'No category'}'),
                              Text(
                                  'SL thực hiện: ${exercise?.slThucHien ?? 'No data'}'),
                            ],
                          ),
                          isThreeLine: true,
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: snapshot.data?.length ?? 0,
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
