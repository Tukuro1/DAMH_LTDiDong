import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhom6_android_studio/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  String _gender = "Nam";

  String? _jwtToken; // JWT token từ SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      setState(() {
        _jwtToken = token;
      });

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Lấy thông tin từ JWT
      setState(() {
        _usernameController.text = decodedToken['unique_name'] ?? 'Không có tên người dùng';
        _emailController.text = decodedToken['email'] ?? 'Không có email';
        _heightController.text = decodedToken['height']?.toString() ?? '';
        _weightController.text = decodedToken['weight']?.toString() ?? '';
        _birthDateController.text = decodedToken['dateOfBirth'] ?? '';
        _gender = decodedToken['gender'] ?? 'Nam';
      });
    }
  }

  Future<void> _updateAccount() async {
    if (_jwtToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bạn chưa đăng nhập!")),
      );
      return;
    }

    final url = Uri.parse("https://10.0.2.2:7289/api/user/update");

    final body = {
      "username": _usernameController.text,
      "email": _emailController.text,
      "height": double.tryParse(_heightController.text),
      "weight": double.tryParse(_weightController.text),
      "dateOfBirth": _birthDateController.text,
      "gender": _gender,
    };

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_jwtToken", // Đính kèm JWT token
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // Cập nhật thành công, lưu JWT mới (nếu có)
        final newToken = response.body; // Giả định server trả về JWT mới
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', newToken);

        setState(() {
          _jwtToken = newToken;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cập nhật tài khoản thành công!")),
        );
      } else {
        // Lỗi từ server
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: ${response.statusCode} - ${response.body}")),
        );
      }
    } catch (e) {
      // Lỗi mạng hoặc API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể kết nối đến server")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cập nhật thông tin tài khoản")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Tên người dùng"),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: "Chiều cao (cm)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: "Cân nặng (kg)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _birthDateController,
              decoration: const InputDecoration(labelText: "Ngày sinh"),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _birthDateController.text =
                    "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  });
                }
              },
              readOnly: true,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(labelText: "Giới tính"),
              items: const [
                DropdownMenuItem(value: "Nam", child: Text("Nam")),
                DropdownMenuItem(value: "Nữ", child: Text("Nữ")),
                DropdownMenuItem(value: "Khác", child: Text("Khác")),
              ],
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateAccount,
              child: const Text("Lưu thông tin"),
            ),
          ],
        ),
      ),
    );
  }
}