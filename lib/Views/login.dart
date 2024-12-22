// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jobable_dpbo_final_project/Components/button.dart';
import 'package:jobable_dpbo_final_project/Components/colors.dart';
import 'package:jobable_dpbo_final_project/Components/textfield.dart';
import 'package:jobable_dpbo_final_project/Views/jobpage.dart';
import 'package:jobable_dpbo_final_project/Views/signup.dart';

import '../SQLite/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usrName = TextEditingController(); // Username controller
  final password = TextEditingController(); // Password controller
  bool isChecked = false;
  bool isLoginTrue = false;
  final db = DatabaseHelper(); // Database helper instance

  // Login Method
  void _login() async {
    final user = await db.getUser(usrName.text, password.text);
    if (user != null) {
      // Navigate to JobApplicationApp and pass the user details
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => JobApplicationApp(profile: user),
        ),
      );
    } else {
      // Show error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  // Clear all tables method
  void _clearAllTables() async {
    await db.clearAllTables();
    // Show a message to confirm that tables have been cleared
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Database cleared!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "LOGIN",
                  style: TextStyle(color: primaryColor, fontSize: 40),
                ),
                Image.asset(
                  "assets/logo.png",
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 50),
                InputField(
                  hint: "Username",
                  icon: Icons.account_circle,
                  controller: usrName,
                  decoration: const InputDecoration(),
                ),
                InputField(
                  hint: "Password",
                  icon: Icons.lock,
                  controller: password,
                  passwordInvisible: true,
                  decoration: const InputDecoration(),
                ),
                ListTile(
                  horizontalTitleGap: 2,
                  title: const Text("Remember me"),
                  leading: Checkbox(
                    activeColor: primaryColor,
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                ),
                Button(
                  label: "LOGIN",
                  press: () => _login(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text("SIGN UP"),
                    ),
                  ],
                ),
                isLoginTrue
                    ? Text(
                        "Username or password is incorrect",
                        style: TextStyle(color: Colors.red.shade900),
                      )
                    : const SizedBox(),
                // Clear Database Button
                ElevatedButton(
                  onPressed: _clearAllTables,
                  child: const Text('Clear All Tables'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
