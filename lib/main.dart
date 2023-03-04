import 'dart:convert';
import 'dart:developer';

import 'package:SMB/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SMB/create.dart';
import 'package:SMB/login.dart';
import 'package:SMB/plan.dart';
import 'package:SMB/view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMB',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SMB'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox.fromSize(
            size: Size.fromRadius(90),
            child: Image.asset('assets/logo.jpg')
          ),
        ),
      ),
    );
  }

  checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(
        Uri.parse('${ApiPreferences.baseUrl}/api/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token') ?? ''}'
        }
    );

    if (response.statusCode == 200) {
      String userName = json.decode(response.body)['data']['name'];
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome back, ${userName}!'))
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const DashboardPlan()
        ),
        (route) => false
      );
    }
    else if (response.statusCode == 401) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const LoginScreen()
          ),
          (route) => false
      );
    }
    else {
      throw Exception('Failed to get auth');
    }
  }
}
