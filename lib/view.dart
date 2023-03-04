import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SMB/plan.dart';
import 'package:SMB/update.dart';

class ViewPlan extends StatelessWidget {
  ViewPlan({Key? key, required this.plan}) : super(key: key);

  final Plan plan;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> executeDeletePlan(BuildContext context) async {
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

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.delete(
        Uri.parse('${ApiPreferences.baseUrl}/api/plans/${plan.id}'),
        headers: {
          'Authorization': 'Bearer ${prefs.getString('token')}'
        }
    );
    log(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plan has been deleted successfully.'))
      );
      var nav = Navigator.of(context);
      nav.pop();
      nav.pop();
    } else {
      throw Exception('Failed to delete plan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('View Plan'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Title',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                  ),
                ),
                Text(plan.title),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Description',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                  ),
                ),
                Text(plan.description),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Status',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                  ),
                ),
                Text(plan.status),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    plan.doneAt != null ? 'Done At' : 'Deadline At',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                  ),
                ),
                Text(plan.doneAt != null ? plan.doneAt.toString() : plan.deadlineAt.toString()),
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
                      child: Text(
                          'Update This Plan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          )
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => UpdatePlan(plan: plan)
                        )
                    );
                  },
                ),
                const SizedBox(height: 15),
                InkWell(
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    width: double.infinity,
                    child: const Center(
                      child: Text(
                          'Delete This Plan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          )
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Delete Confirmation'),
                          content: Text('Are you sure you want to delete "${plan.title}"?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.of(dialogContext).pop(),
                            ),
                            TextButton(
                              child: const Text('Confirm', style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                executeDeletePlan(context);
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
          ),
        )
    );
  }
}
