import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'current_user.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  Future<void> login() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/api/users/email/${emailController.text}",
        ),
      );

      if (response.statusCode == 200) {
        currentUser = jsonDecode(response.body);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const RideListScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not found"),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ST Carpool Login"),
      ),
      body: Center(
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.directions_car,
                size: 70,
              ),

              const SizedBox(height: 16),

              const Text(
                "ST Carpool",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Internal Ride Sharing Platform",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: login,
                  child: const Text("Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
),
    );
  }
}