import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SMB/create.dart';
import 'package:SMB/login.dart';
import 'package:SMB/plan.dart';
import 'package:SMB/view.dart';

class DashboardPlan extends StatefulWidget {
  const DashboardPlan({Key? key}) : super(key: key);

  @override
  State<DashboardPlan> createState() => _DashboardPlanState();
}

class _DashboardPlanState extends State<DashboardPlan> {
  late Future<List<Plan>> futurePlans;

  @override
  void initState() {
    super.initState();
    futurePlans = fetchAllPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox.fromSize(
              size: Size.fromRadius(20),
              child: Image.asset('assets/logo.jpg')
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Logout Confirmation'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                        TextButton(
                          child: const Text('Logout', style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            executeLogout();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Logged out successfully.')
                              )
                            );
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen()
                              ),
                              (route) => false
                            );
                          },
                        ),
                      ],
                    );
                  }
              );
            },
          )
        ],
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text('ToDo'),
            children: [
              FutureBuilder(
                  future: futurePlans,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error');
                    }
                    else if (snapshot.hasData) {
                      List<Widget> children = [];

                      var todos = snapshot.data?.where((element) => element.status == 'todo').toList();
                      todos?.forEach((element) {
                        children.add(
                            ListTile(
                              title: Text(element.title),
                              subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(element.deadlineAt)),
                              trailing: const Icon(Icons.open_in_new),
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ViewPlan(plan: element)
                                    )
                                ).then((value) async {
                                  setState(() {
                                    futurePlans = fetchAllPlans();
                                  });
                                });
                              },
                            )
                        );
                      });
                      return Column(children: children);
                    }
                    return const CircularProgressIndicator();
                  }
              )
            ],
          ),
          ExpansionTile(
            title: const Text('In Progress'),
            children: [
              FutureBuilder(
                  future: futurePlans,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error');
                    }
                    else if (snapshot.hasData) {
                      List<Widget> children = [];

                      var todos = snapshot.data?.where((element) => element.status == 'inprogress').toList();
                      todos?.forEach((element) {
                        children.add(
                            ListTile(
                              title: Text(element.title),
                              subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(element.deadlineAt)),
                              trailing: const Icon(Icons.open_in_new),
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ViewPlan(plan: element)
                                    )
                                ).then((value) async {
                                  setState(() {
                                    futurePlans = fetchAllPlans();
                                  });
                                });
                              },
                            )
                        );
                      });
                      return Column(children: children);
                    }
                    return const CircularProgressIndicator();
                  }
              )
            ],
          ),
          ExpansionTile(
            title: const Text('On Review'),
            children: [
              FutureBuilder(
                  future: futurePlans,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error');
                    }
                    else if (snapshot.hasData) {
                      List<Widget> children = [];

                      var todos = snapshot.data?.where((element) => element.status == 'review').toList();
                      todos?.forEach((element) {
                        children.add(
                            ListTile(
                              title: Text(element.title),
                              subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(element.deadlineAt)),
                              trailing: const Icon(Icons.open_in_new),
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ViewPlan(plan: element)
                                    )
                                ).then((value) async {
                                  setState(() {
                                    futurePlans = fetchAllPlans();
                                  });
                                });
                              },
                            )
                        );
                      });
                      return Column(children: children);
                    }
                    return const CircularProgressIndicator();
                  }
              )
            ],
          ),
          ExpansionTile(
            title: const Text('Done'),
            children: [
              FutureBuilder(
                  future: futurePlans,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error');
                    }
                    else if (snapshot.hasData) {
                      List<Widget> children = [];

                      var todos = snapshot.data?.where((element) => element.status == 'done').toList();
                      todos?.forEach((element) {
                        children.add(
                            ListTile(
                              title: Text(element.title),
                              subtitle: Text('Done at ${DateFormat('yyyy-MM-dd – kk:mm').format(element.doneAt ?? DateTime.now())}'),
                              trailing: const Icon(Icons.open_in_new),
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ViewPlan(plan: element)
                                    )
                                ).then((value) async {
                                  setState(() {
                                    futurePlans = fetchAllPlans();
                                  });
                                });
                              },
                            )
                        );
                      });
                      return Column(children: children);
                    }
                    return const CircularProgressIndicator();
                  }
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCreatePlan,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> navigateToCreatePlan() async {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => const CreatePlan()
        )
    ).then((value) async {
      if (value) {
        setState(() {
          futurePlans = fetchAllPlans();
        });
      }
    });
  }
}

void executeLogout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

Future<List<Plan>> fetchAllPlans() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await http.get(
      Uri.parse('${ApiPreferences.baseUrl}/api/plans?per_page=50'),
      headers: {
        'Authorization': 'Bearer ${prefs.getString('token')}'
      }
  );
  log(response.body);
  if (response.statusCode == 200) {
    return List<Plan>.from(json.decode(response.body)['data'].map((x) => Plan.fromJson(x)));
  } else {
    throw Exception('Failed to load plans');
  }
}
