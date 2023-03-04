import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SMB/dashboard.dart';
import 'package:SMB/plan.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool onSubmit = false;

  Future<void> executeLogin(BuildContext context) async {
    onSubmit = true;
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        }
    );

    final response = await http.post(
        Uri.parse('${ApiPreferences.baseUrl}/api/user/register'),
        headers: {
          'Accept': 'application/json'
        },
        body: {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        }
    );
    onSubmit = false;
    log(response.body);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', json.decode(response.body)['data']['token']);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered successfully.'))
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const DashboardPlan()
          ),
              (route) => false
      );
    }
    else if (response.statusCode == 422) {
      String message = json.decode(response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message))
      );
      Navigator.of(context).pop();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to register'))
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox.fromSize(
                          size: Size.fromRadius(30),
                          child: Image.asset('assets/logo.jpg')
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          hintText: 'Name'
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: 'Email'
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                          hintText: 'Password'
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        else if (value.length < 6) {
                          return 'Please enter more than 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Confirmation Password'
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        else if (value != passwordController.text) {
                          return 'Please enter the same password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        width: double.infinity,
                        child: const Center(
                          child: Text('Register', style: TextStyle(
                              color: Colors.white
                          )),
                        ),
                      ),
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (!onSubmit) {
                            executeLogin(context);
                          }
                        }
                      },
                    ),
                    InkWell(
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        width: double.infinity,
                        child: const Center(
                          child: Text('Already have an account? Log In', style: TextStyle(
                              color: Colors.blue
                          )),
                        ),
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
