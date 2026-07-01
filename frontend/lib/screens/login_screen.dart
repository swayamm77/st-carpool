import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../constants/app_text.dart';
import '../current_user.dart';
import '../services/user_service.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your corporate email")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      currentUser = await UserService.login(emailController.text);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RideListScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.page,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.directions_car_rounded,
                    size: 82,
                    color: Color(0xFF7C4DFF),
                  ),

                  AppSpacing.lg,

                  const Text("ST Carpool", style: AppText.pageTitle),

                  AppSpacing.sm,

                  const Text(
                    "Internal Ride Sharing Platform\nfor STMicroelectronics",
                    textAlign: TextAlign.center,
                    style: AppText.subtitle,
                  ),

                  AppSpacing.xl,

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Corporate Email",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    onSubmitted: (_) => login(),
                  ),

                  AppSpacing.lg,

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Continue", style: AppText.button),
                    ),
                  ),

                  AppSpacing.lg,

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, size: 16, color: Colors.white54),

                      SizedBox(width: 6),

                      Text("Secure internal login", style: AppText.caption),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
