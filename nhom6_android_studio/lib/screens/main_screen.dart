import 'package:flutter/material.dart';
import 'package:nhom6_android_studio/screens/exerciselist_screen.dart';
import 'package:nhom6_android_studio/screens/login_screen.dart';
import 'package:nhom6_android_studio/screens/meallist_screen.dart';
import 'package:nhom6_android_studio/screens/update_user_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.featured_play_list),
              title: Text('Xây dựng bài tập'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExerciseListScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.featured_play_list),
              title: Text('Xây dựng thực đơn'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MealListPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.featured_play_list),
              title: Text('Màn hình chính'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Đăng Xuất'),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.featured_play_list),
              title: Text('UserUpdateInfo'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateUserInfoScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Chào mừng đến màn hình chính!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Xác nhận'),
      content: Text('Bạn có chắc chắn muốn đăng xuất không?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Đóng hộp thoại
          },
          child: Text('Hủy'),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => _logout(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            "Đăng xuất",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}