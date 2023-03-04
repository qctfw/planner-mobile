import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SMB/plan.dart';

class CreatePlan extends StatefulWidget {
  const CreatePlan({Key? key}) : super(key: key);

  @override
  State<CreatePlan> createState() => _CreatePlanState();
}

class _CreatePlanState extends State<CreatePlan> {
  List<Map<String, dynamic>> statuses = [
    {'value': 'todo', 'text': 'ToDo'},
    {'value': 'inprogress', 'text': 'In Progress'},
    {'value': 'review', 'text': 'Review'},
    {'value': 'done', 'text': 'Done'}
  ];
  bool onSubmit = false;
  String? statusValue;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deadlineAtController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> executeCreatePlan() async {
    onSubmit = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse('${ApiPreferences.baseUrl}/api/plans'),
      headers: {
        'Authorization': 'Bearer ${prefs.getString('token')}'
      },
      body: {
        'title': titleController.text,
        'description': descriptionController.text,
        'status': statusValue,
        'deadline_at': deadlineAtController.text
      }
    );
    onSubmit = false;
    log(response.body);
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plan has been created successfully.'))
      );
      Navigator.pop(context, true);
    } else {
      throw Exception('Failed to create plans');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Plan'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Title'),
                TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                const Text('Description'),
                TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                const Text('Status'),
                DropdownButtonFormField(
                    value: statusValue,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    items: statuses.map<DropdownMenuItem<String>>((status) {
                      return DropdownMenuItem<String>(
                        value: status['value'],
                        child: Text(status['text']!),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        statusValue = value;
                      });
                    }
                ),
                const SizedBox(height: 30),
                const Text('Deadline At'),
                TextFormField(
                    controller: deadlineAtController,
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2024),
                      ).then((value) {
                        setState(() {
                          deadlineAtController.text = value.toString();
                        });
                      });
                    }
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
                      child: Text('Create Your Plan', style: TextStyle(
                          color: Colors.white
                      )),
                    ),
                  ),
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing...')),
                      );
                      if (!onSubmit) {
                        executeCreatePlan();
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
